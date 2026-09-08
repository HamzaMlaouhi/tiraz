import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// An [Icon] that mirrors horizontally under RTL (for directional glyphs
/// like arrows). [IconData.matchTextDirection] would do this, but setting
/// it means constructing a new `IconData` at runtime — icon tree-shaking
/// requires every `IconData` to be a compile-time constant, so instead this
/// flips the rendered icon visually with a [Transform].
class MirroredIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const MirroredIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final icon = Icon(this.icon, size: size, color: color);
    if (Directionality.of(context) != TextDirection.rtl) return icon;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: icon,
    );
  }
}
