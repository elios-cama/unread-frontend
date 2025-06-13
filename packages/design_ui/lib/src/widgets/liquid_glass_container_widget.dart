import 'package:flutter/material.dart';
import 'dart:ui';

class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
  });

  final double width;
  final double height;
  final Widget child;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isCircular = height < 100 && height > 0;
    final borderRadiusValue = borderRadius ?? (isCircular ? 24.0 : 16.0);
    final isDynamic = height == 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: isDynamic ? null : width,
          height: isDynamic ? null : height,
          constraints: isDynamic ? BoxConstraints(minWidth: width) : null,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
              ],
              stops: const [0.1, 0.9],
            ),
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 25,
                offset: const Offset(0, 5),
                spreadRadius: -10,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
