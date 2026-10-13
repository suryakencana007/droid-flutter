// Menaikkan versi di pubspec.yaml.
//
//   dart run tool/bump.dart patch|minor|major|<x.y.z>
//
// Build number (+N) selalu naik satu. Dipakai `just bump` dan `just release`.
import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln(
      'Pemakaian: dart run tool/bump.dart patch|minor|major|<x.y.z>',
    );
    exit(64);
  }
  final file = File('pubspec.yaml');
  final content = file.readAsStringSync();
  final match = RegExp(
    r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$',
    multiLine: true,
  ).firstMatch(content);
  if (match == null) {
    stderr.writeln('version: x.y.z+n tidak ditemukan di pubspec.yaml');
    exit(1);
  }
  var (major, minor, patch) = (
    int.parse(match[1]!),
    int.parse(match[2]!),
    int.parse(match[3]!),
  );
  final build = int.parse(match[4]!) + 1;

  switch (args[0]) {
    case 'major':
      major++;
      minor = 0;
      patch = 0;
    case 'minor':
      minor++;
      patch = 0;
    case 'patch':
      patch++;
    case final explicit when RegExp(r'^\d+\.\d+\.\d+$').hasMatch(explicit):
      final parts = explicit.split('.').map(int.parse).toList();
      (major, minor, patch) = (parts[0], parts[1], parts[2]);
    default:
      stderr.writeln('Argumen tidak dikenal: ${args[0]}');
      exit(64);
  }

  final next = '$major.$minor.$patch+$build';
  file.writeAsStringSync(content.replaceFirst(match[0]!, 'version: $next\n'));
  stdout.writeln(next);
}
