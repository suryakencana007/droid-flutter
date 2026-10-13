// Mengganti identitas template menjadi app baru.
//
// Pemakaian (dari root project, setelah "Use this template" / clone):
//   dart run tool/rename.dart --name myapp --org com.example --title "My App"
//
// Yang diganti:
//   - name di pubspec.yaml dan semua import package:<lama>/
//   - packageName di test arsitektur, app_id di justfile, AppInfo.name
//   - Android: namespace, applicationId, android:label, paket MainActivity.kt
//   - iOS: PRODUCT_BUNDLE_IDENTIFIER, CFBundleDisplayName, CFBundleName
//   - Judul README
//
// Jalankan `flutter clean && flutter pub get && dart fix --apply` setelahnya
// (atau cukup `just rename ...` yang sudah melakukannya).
import 'dart:io';

const _usage = '''
Pemakaian: dart run tool/rename.dart --name <nama_package> --org <com.perusahaan> [--title "Judul App"]

  --name   nama package Dart, snake_case, contoh: kasir_app
  --org    reverse-domain untuk application/bundle id, contoh: com.kubus.work
  --title  nama tampilan di launcher (default: --name dengan huruf kapital)
  --dry-run  hanya tampilkan file yang akan berubah
''';

void main(List<String> args) {
  final opts = _parse(args);
  if (opts == null) {
    stderr.writeln(_usage);
    exit(64);
  }

  final current = _currentIdentity();
  final next = opts;
  stdout
    ..writeln('Dari : ${current.name} / ${current.appId} / "${current.title}"')
    ..writeln('Ke   : ${next.name} / ${next.appId} / "${next.title}"')
    ..writeln(opts.dryRun ? '(dry run, tidak ada yang ditulis)' : '');

  final changed = <String>[];

  void replaceIn(String path, Map<String, String> replacements) {
    final file = File(path);
    if (!file.existsSync()) return;
    final before = file.readAsStringSync();
    var after = before;
    replacements.forEach((from, to) => after = after.replaceAll(from, to));
    if (after != before) {
      changed.add(path);
      if (!opts.dryRun) file.writeAsStringSync(after);
    }
  }

  // Dart: nama package dan import.
  replaceIn('pubspec.yaml', {
    'name: ${current.name}\n': 'name: ${next.name}\n',
  });
  for (final dir in ['lib', 'test', 'tool', 'integration_test']) {
    for (final file in _dartFiles(dir)) {
      replaceIn(file.path, {
        'package:${current.name}/': 'package:${next.name}/',
        "const packageName = '${current.name}';":
            "const packageName = '${next.name}';",
      });
    }
  }
  replaceIn('lib/shared/config/app_info.dart', {
    "static const name = '${current.title}';":
        "static const name = '${next.title}';",
  });
  replaceIn('justfile', {
    'app_id := "${current.appId}"': 'app_id := "${next.appId}"',
  });
  replaceIn('README.md', {'# ${current.name}\n': '# ${next.name}\n'});

  // Android.
  replaceIn('android/app/build.gradle.kts', {
    'namespace = "${current.appId}"': 'namespace = "${next.appId}"',
    'applicationId = "${current.appId}"': 'applicationId = "${next.appId}"',
  });
  replaceIn('android/app/src/main/AndroidManifest.xml', {
    'android:label="${current.name}"': 'android:label="${next.title}"',
  });
  final oldActivity = File(
    'android/app/src/main/kotlin/${current.appId.replaceAll('.', '/')}/MainActivity.kt',
  );
  if (oldActivity.existsSync()) {
    final newDir = Directory(
      'android/app/src/main/kotlin/${next.appId.replaceAll('.', '/')}',
    );
    final source = oldActivity.readAsStringSync().replaceFirst(
      'package ${current.appId}',
      'package ${next.appId}',
    );
    changed.add('${newDir.path}/MainActivity.kt (dipindah)');
    if (!opts.dryRun) {
      newDir.createSync(recursive: true);
      File('${newDir.path}/MainActivity.kt').writeAsStringSync(source);
      oldActivity.deleteSync();
      _pruneEmptyDirs(
        oldActivity.parent,
        Directory('android/app/src/main/kotlin'),
      );
    }
  }

  // iOS.
  replaceIn('ios/Runner.xcodeproj/project.pbxproj', {
    'PRODUCT_BUNDLE_IDENTIFIER = ${current.appId}':
        'PRODUCT_BUNDLE_IDENTIFIER = ${next.appId}',
  });
  replaceIn('ios/Runner/Info.plist', {
    '<key>CFBundleDisplayName</key>\n\t<string>${current.title}</string>':
        '<key>CFBundleDisplayName</key>\n\t<string>${next.title}</string>',
    '<key>CFBundleName</key>\n\t<string>${current.name}</string>':
        '<key>CFBundleName</key>\n\t<string>${next.name}</string>',
  });

  stdout.writeln('\nFile berubah (${changed.length}):');
  for (final path in changed) {
    stdout.writeln('  ~ $path');
  }
  if (!opts.dryRun) {
    stdout
      ..writeln(
        '\nSelesai. Jalankan: flutter clean && flutter pub get && dart fix --apply',
      )
      ..writeln(
        'Lalu ganti assets/brand/*.png dan jalankan `just brand` untuk ikon dan splash.',
      );
  }
}

typedef _Identity = ({String name, String appId, String title, bool dryRun});

_Identity? _parse(List<String> args) {
  String? name;
  String? org;
  String? title;
  var dryRun = false;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--name' when i + 1 < args.length:
        name = args[++i];
      case '--org' when i + 1 < args.length:
        org = args[++i];
      case '--title' when i + 1 < args.length:
        title = args[++i];
      case '--dry-run':
        dryRun = true;
      default:
        return null;
    }
  }
  if (name == null || org == null) return null;
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name)) {
    stderr.writeln('--name harus snake_case: $name');
    return null;
  }
  if (!RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9_]*)+$').hasMatch(org)) {
    stderr.writeln('--org harus reverse-domain, contoh com.example: $org');
    return null;
  }
  title ??= name
      .split('_')
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
  return (name: name, appId: '$org.$name', title: title, dryRun: dryRun);
}

/// Identitas saat ini dibaca dari file sumber, jadi tool bisa dijalankan
/// berulang (template → app A → app A versi baru).
_Identity _currentIdentity() {
  final name = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)!;
  final appId = RegExp(r'applicationId\s*=\s*"([^"]+)"')
      .firstMatch(File('android/app/build.gradle.kts').readAsStringSync())!
      .group(1)!;
  final title = RegExp(r"static const name = '([^']+)';")
      .firstMatch(File('lib/shared/config/app_info.dart').readAsStringSync())!
      .group(1)!;
  return (name: name, appId: appId, title: title, dryRun: false);
}

Iterable<File> _dartFiles(String dir) => !Directory(dir).existsSync()
    ? const []
    : Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

void _pruneEmptyDirs(Directory dir, Directory stopAt) {
  var current = dir;
  while (current.path != stopAt.path &&
      current.existsSync() &&
      current.listSync().isEmpty) {
    current.deleteSync();
    current = current.parent;
  }
}
