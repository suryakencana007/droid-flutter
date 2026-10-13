import 'package:flagsmith/flagsmith.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env.dart';
import '../logging/app_logger.dart';

/// Satu flag: aktif/nonaktif plus nilai opsional (string dari remote config).
class FlagValue {
  const FlagValue({required this.enabled, this.value});

  final bool enabled;
  final String? value;

  @override
  String toString() => value == null ? '$enabled' : '$enabled ($value)';
}

/// Sumber feature flag. [load] mengembalikan snapshot; [identify] mengikat
/// evaluasi ke user (segmentasi) dan harus diikuti [load] lagi.
abstract interface class FeatureFlags {
  String get sourceName;
  Future<Map<String, FlagValue>> load();
  Future<void> identify(String? userId);
}

/// Flag dari `FEATURE_FLAGS` di `env/*.json`; tanpa jaringan.
class LocalFeatureFlags implements FeatureFlags {
  LocalFeatureFlags([String? spec]) : _flags = parse(spec ?? Env.featureFlags);

  final Map<String, FlagValue> _flags;

  static Map<String, FlagValue> parse(String spec) {
    final result = <String, FlagValue>{};
    for (final entry in spec.split(';')) {
      final trimmed = entry.trim();
      if (trimmed.isEmpty) continue;
      final i = trimmed.indexOf(':');
      final key = i < 0 ? trimmed : trimmed.substring(0, i).trim();
      final raw = i < 0 ? 'true' : trimmed.substring(i + 1).trim();
      result[key] = switch (raw.toLowerCase()) {
        'true' || '1' || 'on' => const FlagValue(enabled: true),
        'false' || '0' || 'off' => const FlagValue(enabled: false),
        _ => FlagValue(enabled: true, value: raw),
      };
    }
    return result;
  }

  @override
  String get sourceName => 'env/${Env.flavor.name}.json';

  @override
  Future<Map<String, FlagValue>> load() async => _flags;

  @override
  Future<void> identify(String? userId) async {}
}

/// Flag dari Flagsmith. Cache in-memory SDK dipakai saat offline; nilai
/// terakhir yang berhasil dimuat tetap dikembalikan bila fetch gagal.
class FlagsmithFeatureFlags implements FeatureFlags {
  FlagsmithFeatureFlags({required this.environmentKey, this._client});

  final String environmentKey;
  FlagsmithClient? _client;
  Identity? _identity;
  Map<String, FlagValue> _last = const {};
  final _log = log('flags');

  Future<FlagsmithClient> _ensureClient() async =>
      _client ??= await FlagsmithClient.init(
        apiKey: environmentKey,
        config: const FlagsmithConfig(caches: true, enableAnalytics: false),
      );

  @override
  String get sourceName => 'Flagsmith';

  @override
  Future<Map<String, FlagValue>> load() async {
    try {
      final client = await _ensureClient();
      final flags = await client.getFeatureFlags(user: _identity);
      _last = {
        for (final f in flags)
          f.feature.name: FlagValue(
            enabled: f.enabled ?? false,
            value: f.stateValue,
          ),
      };
    } on Exception catch (e, st) {
      _log.warning('gagal memuat flag, memakai nilai terakhir', e, st);
    }
    return _last;
  }

  @override
  Future<void> identify(String? userId) async {
    _identity = userId == null ? null : Identity(identifier: userId);
  }
}

/// Untuk test dan prototipe.
class MemoryFeatureFlags implements FeatureFlags {
  MemoryFeatureFlags(Map<String, bool> flags)
    : _flags = {
        for (final e in flags.entries) e.key: FlagValue(enabled: e.value),
      };

  final Map<String, FlagValue> _flags;
  String? identifiedUser;

  @override
  String get sourceName => 'memory';

  @override
  Future<Map<String, FlagValue>> load() async => _flags;

  @override
  Future<void> identify(String? userId) async => identifiedUser = userId;
}

final featureFlagsProvider = Provider<FeatureFlags>(
  (_) => Env.flagsmithEnvKey.isEmpty
      ? LocalFeatureFlags()
      : FlagsmithFeatureFlags(environmentKey: Env.flagsmithEnvKey),
);

/// Snapshot flag yang sedang berlaku. Baca dengan `ref.watch(flagProvider('x'))`.
class FlagsNotifier extends AsyncNotifier<Map<String, FlagValue>> {
  @override
  Future<Map<String, FlagValue>> build() =>
      ref.read(featureFlagsProvider).load();

  Future<void> refresh() async {
    state = AsyncData(await ref.read(featureFlagsProvider).load());
  }

  Future<void> identify(String? userId) async {
    await ref.read(featureFlagsProvider).identify(userId);
    await refresh();
  }
}

final flagsProvider =
    AsyncNotifierProvider<FlagsNotifier, Map<String, FlagValue>>(
      FlagsNotifier.new,
    );

/// `true` bila flag ada dan aktif. Flag yang belum dimuat dianggap nonaktif,
/// jadi fitur baru aman tersembunyi sampai flag datang.
final flagProvider = Provider.family<bool, String>(
  (ref, key) => ref.watch(flagsProvider).value?[key]?.enabled ?? false,
);
