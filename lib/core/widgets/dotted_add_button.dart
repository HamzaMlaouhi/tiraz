import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The dashed "+ add" affordance used on Measurement profiles and
/// Addresses — a deliberately inert stub in the design too (no add
/// flow behind it yet).
class DottedAddButton extends StatelessWidget {
  final String label;
  const DottedAddButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child:
            Center(child: Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textMuted, fontSize: 13))),
      ),
    );
  }
}

class DottedBorder extends StatelessWidget {
  final Widget child;
  const DottedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DashedRRectPainter(), child: child);
  }
}

class _DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = const Color(0xFFC9C0B0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        const dash = 5.0, gap = 4.0;
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
