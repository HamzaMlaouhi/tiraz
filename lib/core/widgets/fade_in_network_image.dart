import 'package:flutter/material.dart';

/// A network image that crossfades in once it decodes, and quietly shows
/// [fallback] instead if the load fails or is still in flight — e.g. no
/// network on a fresh install. Every other "image" in the app is the
/// lightweight gradient-tile placeholder; this is for the handful of spots
/// (store banners/logos) that use real placeholder photography.
class FadeInNetworkImage extends StatelessWidget {
  final String url;
  final Widget fallback;
  final double? width;
  final double? height;
  final BoxFit fit;

  const FadeInNetworkImage({
    super.key,
    required this.url,
    required this.fallback,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: frame == null
              ? SizedBox(key: const ValueKey('placeholder'), width: width, height: height, child: fallback)
              : KeyedSubtree(key: const ValueKey('image'), child: child),
        );
      },
      errorBuilder: (context, error, stack) => SizedBox(width: width, height: height, child: fallback),
    );
  }
}
