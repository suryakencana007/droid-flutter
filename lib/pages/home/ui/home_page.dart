import 'package:droid/entities/user/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:droid/widgets/app_bar/index.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const user = User(id: '1', name: 'Surya', email: 'surya@example.com');

    return Scaffold(
      appBar: const DroidAppBar(title: 'Droid'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Feature-Sliced Design bootstrap',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Halaman ini merakit widget, feature, dan entity dari layer di bawahnya.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(AppSpacing.lg),
          const UserCard(user: user),
        ],
      ),
    );
  }
}
