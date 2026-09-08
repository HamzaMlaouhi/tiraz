import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_box.dart';

/// A skeleton of the loaded home feed's shape (search bar, hero, a couple
/// of rails, a grid) — shown in place of a bare spinner while
/// [HomeCubit.load] is in flight, so the first paint (and pull-to-refresh)
/// already reads as "this page".
class HomeLoadingSkeleton extends StatelessWidget {
  final double horizontalPadding;

  const HomeLoadingSkeleton({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 190, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(height: 22),
          const ShimmerBox(width: 140, height: 15),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: Row(
              children: List.generate(2, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: i == 1 ? 0 : 12),
                    child: const ShimmerBox(borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 22),
          const ShimmerBox(width: 160, height: 15),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: Row(
              children: List.generate(3, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: i == 2 ? 0 : 12),
                    child: const ShimmerBox(borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 22),
          const ShimmerBox(width: 130, height: 15),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 150 / 88,
            children: List.generate(4, (i) => const ShimmerBox(borderRadius: BorderRadius.all(Radius.circular(14)))),
          ),
        ],
      ),
    );
  }
}
