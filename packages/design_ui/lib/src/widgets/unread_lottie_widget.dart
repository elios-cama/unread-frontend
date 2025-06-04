import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class UnreadLottie extends StatelessWidget {
  const UnreadLottie({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.animate = true,
    this.package = 'app_ui',
    this.controller,
    this.onLoaded,
    this.frameRate,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  final bool reverse;
  final bool animate;
  final String package;
  final AnimationController? controller;
  final void Function(LottieComposition)? onLoaded;
  final FrameRate? frameRate;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    return Lottie.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      animate: animate,
      controller: controller,
      onLoaded: onLoaded,
      frameRate: frameRate,
    );
  }
}
