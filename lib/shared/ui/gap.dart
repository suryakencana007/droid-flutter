import 'package:flutter/widgets.dart';

/// Spasi kosong yang mengikuti arah [Row]/[Column] terdekat secara otomatis.
///
/// Arah diambil dari [Flex] leluhur terdekat, bukan dari [Scrollable], supaya
/// tetap benar di dalam `PageView` horizontal yang berisi `Column`.
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    Axis direction = Axis.vertical;
    context.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is Flex) {
        direction = widget.direction;
        return false;
      }
      return true;
    });

    return direction == Axis.horizontal
        ? SizedBox(width: size)
        : SizedBox(height: size);
  }
}
