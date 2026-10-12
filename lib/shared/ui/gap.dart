import 'package:flutter/widgets.dart';

/// Spasi kosong yang mengikuti arah parent (Column/Row) secara otomatis.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final axis = Scrollable.maybeOf(context)?.axisDirection;
    final isHorizontal = axis == AxisDirection.left || axis == AxisDirection.right;
    return SizedBox(
      width: isHorizontal ? size : null,
      height: isHorizontal ? null : size,
    );
  }
}
