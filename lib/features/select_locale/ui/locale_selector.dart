import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../model/locale_provider.dart';

/// Pilihan bahasa (sistem / Indonesia / English) sebagai grup tile radio.
class LocaleSelector extends ConsumerWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(localeProvider).value;
    // Nilai `null` (ikuti sistem) diwakili locale kosong agar bisa jadi key.
    const system = Locale('und');
    final selected = current ?? system;

    return FSelectTileGroup<Locale>(
      control: FMultiValueControl.lifted(
        value: {selected},
        onChange: (values) {
          final next = values.difference({selected});
          if (next.isEmpty) return;
          final locale = next.first;
          ref.read(localeProvider.notifier).set(locale == system ? null : locale);
        },
      ),
      label: Text(l10n.languageLabel),
      description: Text(l10n.languageDescription),
      children: [
        FSelectTile(title: Text(l10n.languageSystem), value: system),
        FSelectTile(title: Text(l10n.languageId), value: AppLocales.id),
        FSelectTile(title: Text(l10n.languageEn), value: AppLocales.en),
      ],
    );
  }
}
