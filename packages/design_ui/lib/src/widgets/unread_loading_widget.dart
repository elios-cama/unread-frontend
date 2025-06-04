import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'unread_lottie_widget.dart';

enum LoadingColor { white, black }

class UnreadLoading extends StatelessWidget {
  const UnreadLoading({
    super.key,
    this.size = 32.0,
    this.color = LoadingColor.white,
    this.repeat = true,
    this.animate = true,
  });

  final double size;
  final LoadingColor color;
  final bool repeat;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final animationPath = color == LoadingColor.white
        ? LottieAssets.loadingWhite
        : LottieAssets.loadingBlack;

    return SizedBox(
      width: size,
      height: size,
      child: UnreadLottie(
        path: animationPath,
        width: size,
        height: size,
        repeat: repeat,
        animate: animate,
        fit: BoxFit.contain,
      ),
    );
  }
}
