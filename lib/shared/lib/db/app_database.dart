import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

/// Cache catatan. Tambahkan tabel entity lain di sini dan naikkan
/// [AppDatabase.schemaVersion] dengan migrasi.
class NoteRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Antrian perubahan yang dibuat saat offline, dijalankan berurutan saat
/// online. [payload] adalah JSON input operasi.
class PendingOps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get op => text()(); // create | update | delete
  TextColumn get targetId => text()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [NoteRows, PendingOps])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// File SQLite di direktori dokumen app.
  AppDatabase.open() : super(driftDatabase(name: 'droid'));

  /// In-memory untuk test.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});
