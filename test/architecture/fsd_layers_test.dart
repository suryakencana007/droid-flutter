// Menguji aturan import Feature-Sliced Design (FSD) di `lib/`.
//
// Aturan yang ditegakkan:
//  1. Layer hanya boleh mengimpor layer yang berada DI BAWAHNYA.
//  2. Slice tidak boleh mengimpor slice lain pada layer yang sama.
//  3. Import lintas slice harus lewat public API slice (`index.dart`).
//  4. Import di dalam satu slice memakai path relatif dan tidak keluar dari slice.
//  5. Package UI kit (forui) hanya boleh diimpor dari `shared/ui`; layer lain
//     memakai `package:droid/shared/ui/index.dart`.
//  6. Library Material/Cupertino bawaan Flutter (deprecated sejak 3.47) tidak
//     dipakai; gunakan `package:material_ui` / `package:cupertino_ui`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

const packageName = 'droid';

/// Urutan dari paling atas ke paling bawah.
const layers = ['app', 'pages', 'widgets', 'features', 'entities', 'shared'];

/// Layer tanpa slice: isinya langsung segment, jadi bebas saling impor di dalamnya.
const sliceLessLayers = {'app', 'shared'};

/// Package pihak ketiga yang dibungkus di satu tempat. Key: nama package,
/// value: prefix path (relatif terhadap lib/) yang boleh mengimpornya.
const wrappedPackages = {'forui': 'shared/ui/', 'forui_lucide': 'shared/ui/'};

/// Import yang dilarang di mana pun, beserta penggantinya.
const forbiddenImports = {
  'package:flutter/material.dart': 'package:material_ui/material_ui.dart',
  'package:flutter/cupertino.dart': 'package:cupertino_ui/cupertino_ui.dart',
};

final _importPattern = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

class Location {
  Location(this.layer, this.slice);
  final String layer;
  final String? slice;

  int get rank => layers.indexOf(layer);
  bool get hasSlice => slice != null;
  String get label => slice == null ? layer : '$layer/$slice';
}

Location? locate(String libRelativePath) {
  final parts = p.split(libRelativePath);
  if (parts.isEmpty || !layers.contains(parts.first)) return null;
  final layer = parts.first;
  if (sliceLessLayers.contains(layer)) return Location(layer, null);
  return parts.length > 1 ? Location(layer, parts[1]) : Location(layer, null);
}

void main() {
  final libDir = Directory('lib');
  final files =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  test('lib/ berisi minimal satu layer FSD', () {
    expect(files, isNotEmpty);
  });

  final violations = <String>[];

  for (final file in files) {
    final rel = p.relative(file.path, from: libDir.path);
    if (rel == 'main.dart') continue; // entry point bebas

    final from = locate(rel);
    if (from == null) {
      violations.add('$rel: berada di luar layer FSD ${layers.join(', ')}');
      continue;
    }

    final source = file.readAsStringSync();
    for (final match in _importPattern.allMatches(source)) {
      final uri = match.group(1)!;
      if (uri.startsWith('dart:')) continue;

      final replacement = forbiddenImports[uri];
      if (replacement != null) {
        violations.add('$rel -> $uri: deprecated, pakai $replacement');
        continue;
      }

      String target;
      var isPackageImport = false;
      if (uri.startsWith('package:$packageName/')) {
        target = uri.substring('package:$packageName/'.length);
        isPackageImport = true;
      } else if (uri.startsWith('package:')) {
        final pkg = uri.substring('package:'.length).split('/').first;
        final allowedPrefix = wrappedPackages[pkg];
        if (allowedPrefix != null && !rel.startsWith(allowedPrefix)) {
          violations.add(
            '$rel -> $uri: package $pkg hanya boleh diimpor dari '
            '$allowedPrefix, pakai package:$packageName/shared/ui/index.dart',
          );
        }
        continue; // dependency eksternal
      } else {
        target = p.normalize(p.join(p.dirname(rel), uri));
      }

      final to = locate(target);
      if (to == null) {
        violations.add('$rel -> $uri: target di luar layer FSD');
        continue;
      }

      final sameLocation =
          to.layer == from.layer && (!from.hasSlice || to.slice == from.slice);

      if (sameLocation) {
        if (isPackageImport && from.hasSlice) {
          violations.add(
            '$rel -> $uri: import di dalam slice yang sama harus relatif',
          );
        }
        continue;
      }

      if (to.rank <= from.rank) {
        violations.add(
          '$rel -> $uri: layer ${from.layer} tidak boleh mengimpor '
          '${to.label} (hanya layer di bawahnya)',
        );
        continue;
      }

      if (!isPackageImport) {
        violations.add(
          '$rel -> $uri: import lintas slice harus memakai package:$packageName/...',
        );
        continue;
      }

      if (to.hasSlice && p.basename(target) != 'index.dart') {
        violations.add(
          '$rel -> $uri: harus lewat public API ${to.layer}/${to.slice}/index.dart',
        );
      }
    }
  }

  test('tidak ada pelanggaran aturan import FSD', () {
    expect(
      violations,
      isEmpty,
      reason: '\n${violations.map((v) => '  • $v').join('\n')}\n',
    );
  });

  test('setiap slice memiliki public API index.dart', () {
    final missing = <String>[];
    for (final layer in layers.where((l) => !sliceLessLayers.contains(l))) {
      final dir = Directory(p.join(libDir.path, layer));
      if (!dir.existsSync()) continue;
      for (final slice in dir.listSync().whereType<Directory>()) {
        if (!File(p.join(slice.path, 'index.dart')).existsSync()) {
          missing.add(p.relative(slice.path, from: libDir.path));
        }
      }
    }
    expect(missing, isEmpty, reason: 'Slice tanpa index.dart: $missing');
  });
}
