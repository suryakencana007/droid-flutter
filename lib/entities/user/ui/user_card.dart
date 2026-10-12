import 'package:droid/shared/ui/index.dart';
import 'package:flutter/widgets.dart';

import '../model/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.user, super.key, this.trailing});

  final User user;

  /// Slot untuk aksi dari layer `features` (entity tidak boleh mengimpor feature).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = context.theme.cardStyle;

    return FCard(
      child: Padding(
        padding: style.padding,
        child: Row(
          children: [
            FAvatar.raw(child: Text(user.initials)),
            const Gap(AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: style.titleTextStyle),
                  const Gap(AppSpacing.xs),
                  Text(user.email, style: style.subtitleTextStyle),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
