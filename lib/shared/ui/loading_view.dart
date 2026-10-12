import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Indikator loading di tengah area yang tersedia.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: FCircularProgress());
}
