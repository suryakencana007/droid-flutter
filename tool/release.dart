// Menyiapkan rilis: pindahkan Unreleased di CHANGELOG ke versi baru, bump
// pubspec, commit, dan tag.
//
//   dart run tool/release.dart <x.y.z>
import 'dart:io';

void main(List<String> args) {
  if (args.length != 1 || !RegExp(r'^\d+\.\d+\.\d+$').hasMatch(args[0])) {
    stderr.writeln('Pemakaian: dart run tool/release.dart <x.y.z>');
    exit(64);
  }
  final version = args[0];
  final today = DateTime.now().toIso8601String().substring(0, 10);

  final changelog = File('CHANGELOG.md');
  final text = changelog.readAsStringSync();
  const marker = '## [Unreleased]';
  if (!text.contains(marker)) {
    stderr.writeln('CHANGELOG.md tidak punya bagian "## [Unreleased]"');
    exit(1);
  }
  final updated = text.replaceFirst(
    marker,
    '$marker\n\n## [$version] - $today',
  );
  changelog.writeAsStringSync(updated);

  final bump = Process.runSync('dart', ['run', 'tool/bump.dart', version]);
  if (bump.exitCode != 0) {
    stderr.write(bump.stderr);
    exit(bump.exitCode);
  }
  final full = (bump.stdout as String).trim();

  for (final cmd in [
    ['git', 'add', 'pubspec.yaml', 'CHANGELOG.md'],
    ['git', 'commit', '-m', 'Release $version'],
    ['git', 'tag', '-a', 'v$version', '-m', 'v$version'],
  ]) {
    final r = Process.runSync(cmd.first, cmd.sublist(1));
    if (r.exitCode != 0) {
      stderr.write(r.stderr);
      exit(r.exitCode);
    }
  }
  stdout
    ..writeln('Rilis $full disiapkan: commit + tag v$version.')
    ..writeln(
      'Lanjutkan dengan: git push && git push --tags && just env=prod build-release',
    );
}
