import 'package:flutter/material.dart';

/// Translates a gradient horizontally across its bounds — the sweep that
/// makes [ShimmerBox] read as "loading" rather than a static three-tone box.
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// A skeleton-loading placeholder: a soft base tone with a lighter
/// highlight band that sweeps left-to-right on a loop. Used to build
/// [HomeLoadingSkeleton] instead of a bare spinner.
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: widget.borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1, 0),
                  end: const Alignment(1, 0),
                  colors: const [Color(0xFFEDE7DA), Color(0xFFF8F5EE), Color(0xFFEDE7DA)],
                  stops: const [0.35, 0.5, 0.65],
                  transform: _SlidingGradientTransform(_controller.value * 2 - 1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
