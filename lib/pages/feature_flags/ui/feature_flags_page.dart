import 'package:droid/features/view_feature_flags/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:material_ui/material_ui.dart';

class FeatureFlagsPage extends StatelessWidget {
  const FeatureFlagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.featureFlagsLabel)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: FeatureFlagsList(),
      ),
    );
  }
}
