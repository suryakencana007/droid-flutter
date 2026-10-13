// Generator slice FSD.
//
// Pemakaian:
//   dart run tool/fsd.dart <layer> <nama_slice> [segment ...]
//
// Contoh:
//   dart run tool/fsd.dart feature auth            -> ui, model
//   dart run tool/fsd.dart entity product ui model api
//   dart run tool/fsd.dart page profile
import 'dart:io';

const layerAliases = {
  'page': 'pages',
  'pages': 'pages',
  'widget': 'widgets',
  'widgets': 'widgets',
  'feature': 'features',
  'features': 'features',
  'entity': 'entities',
  'entities': 'entities',
};

const defaultSegments = {
  'pages': ['ui'],
  'widgets': ['ui'],
  'features': ['ui', 'model'],
  'entities': ['ui', 'model'],
};

const allowedSegments = {'ui', 'model', 'api', 'lib', 'config'};

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'Pemakaian: dart run tool/fsd.dart <layer> <nama_slice> [segment ...]',
    );
    stderr.writeln('Layer: ${layerAliases.keys.join(', ')}');
    exit(64);
  }

  final layer = layerAliases[args[0]];
  if (layer == null) {
    stderr.writeln(
      'Layer tidak dikenal: ${args[0]}. Pilihan: ${layerAliases.keys.join(', ')}',
    );
    exit(64);
  }

  final slice = args[1];
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(slice)) {
    stderr.writeln('Nama slice harus snake_case: $slice');
    exit(64);
  }

  final segments = args.length > 2 ? args.sublist(2) : defaultSegments[layer]!;
  final unknown = segments.where((s) => !allowedSegments.contains(s)).toList();
  if (unknown.isNotEmpty) {
    stderr.writeln(
      'Segment tidak dikenal: $unknown. Pilihan: ${allowedSegments.join(', ')}',
    );
    exit(64);
  }

  final sliceDir = Directory('lib/$layer/$slice');
  if (sliceDir.existsSync()) {
    stderr.writeln('Slice sudah ada: ${sliceDir.path}');
    exit(1);
  }

  final exports = <String>[];
  for (final segment in segments) {
    final dir = Directory('${sliceDir.path}/$segment')
      ..createSync(recursive: true);
    final fileName = _starterFileName(layer, slice, segment);
    if (fileName == null) continue;
    final file = File('${dir.path}/$fileName')
      ..writeAsStringSync(_starterContent(layer, slice, segment));
    exports.add('$segment/$fileName');
    stdout.writeln('  + ${file.path}');
  }

  final index = File('${sliceDir.path}/index.dart')
    ..writeAsStringSync(
      ['library;', '', for (final e in exports) "export '$e';", ''].join('\n'),
    );
  stdout.writeln('  + ${index.path}');
  stdout.writeln('Selesai. Import dari layer di atasnya dengan:');
  stdout.writeln("  import 'package:droid/$layer/$slice/index.dart';");
}

String? _starterFileName(String layer, String slice, String segment) =>
    switch (segment) {
      'ui' when layer == 'pages' => '${slice}_page.dart',
      'ui' => '${slice}_widget.dart',
      'model' => '${slice}_model.dart',
      'api' => '${slice}_api.dart',
      _ => null,
    };

String _starterContent(String layer, String slice, String segment) {
  final className = slice
      .split('_')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join();

  return switch (segment) {
    'ui' when layer == 'pages' =>
      '''
import 'package:flutter/material.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('$className')),
    );
  }
}
''',
    'ui' =>
      '''
import 'package:flutter/material.dart';

class ${className}Widget extends StatelessWidget {
  const ${className}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
''',
    'model' =>
      '''
// Model, state, dan logika domain untuk slice `$slice`.
''',
    'api' =>
      '''
// Akses data (HTTP, storage, dll.) untuk slice `$slice`.
// Gunakan `dioProvider` dari package:droid/shared/api/index.dart.
''',
    _ => '',
  };
}
