import 'package:droid/shared/ui/index.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../model/note.dart';

/// Format tanggal pendek sesuai locale aktif.
String formatNoteDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(date);

class NoteTile extends StatelessWidget {
  const NoteTile({required this.note, super.key, this.onPress});

  final Note note;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return FTile(
      prefix: const Icon(FLucideIcons.fileText),
      title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        note.excerpt,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      suffix: const Icon(FLucideIcons.chevronRight),
      onPress: onPress,
    );
  }
}
