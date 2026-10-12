import 'package:flutter/material.dart';

import '../model/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({required this.user, super.key, this.trailing});

  final User user;

  /// Slot untuk aksi dari layer `features` (entity tidak boleh mengimpor feature).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(user.initials)),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: trailing,
      ),
    );
  }
}
