import 'package:flutter/material.dart';

class BookIconWidget extends StatelessWidget {
  const BookIconWidget({
    super.key,
    this.size = 120,
    this.primaryColor = const Color(0xFF6366F1),
    this.secondaryColor = const Color(0xFF8B5CF6),
  });

  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF2D2D2D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.7,
          height: size * 0.7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                primaryColor.withValues(alpha: 0.8),
                secondaryColor.withValues(alpha: 0.9),
                const Color(0xFF1F2937),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
