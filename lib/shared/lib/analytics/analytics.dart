import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/app_logger.dart';

/// Tujuan event analitik. Default hanya mencatat ke log; ganti dengan
/// Firebase Analytics, PostHog, dll. lewat override `analyticsProvider`.
abstract interface class Analytics {
  Future<void> logEvent(
    String name, [
    Map<String, Object?> parameters = const {},
  ]);
  Future<void> logScreen(String name);
  Future<void> setUser(String? id);
}

class LogAnalytics implements Analytics {
  LogAnalytics();

  final _log = log('analytics');

  @override
  Future<void> logEvent(
    String name, [
    Map<String, Object?> parameters = const {},
  ]) async {
    _log.fine('event $name ${parameters.isEmpty ? '' : parameters}');
  }

  @override
  Future<void> logScreen(String name) async => _log.fine('screen $name');

  @override
  Future<void> setUser(String? id) async => _log.fine('user $id');
}

/// Menyimpan semua panggilan; untuk test.
class MemoryAnalytics implements Analytics {
  final events = <(String, Map<String, Object?>)>[];
  final screens = <String>[];
  String? userId;

  @override
  Future<void> logEvent(
    String name, [
    Map<String, Object?> parameters = const {},
  ]) async {
    events.add((name, parameters));
  }

  @override
  Future<void> logScreen(String name) async => screens.add(name);

  @override
  Future<void> setUser(String? id) async => userId = id;
}

final analyticsProvider = Provider<Analytics>((_) => LogAnalytics());
