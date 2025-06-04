import 'package:flutter/material.dart';

class UnreadDialog extends StatelessWidget {
  const UnreadDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.backgroundColor = const Color(0xFF2D2D2D),
    this.borderRadius = 24.0,
    this.titleStyle,
    this.contentStyle,
  });

  final String title;
  final String content;
  final List<Widget> actions;
  final Color backgroundColor;
  final double borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: contentStyle ??
                    TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .map((action) => [
                            action,
                            if (action != actions.last)
                              const SizedBox(width: 12),
                          ])
                      .expand((element) => element)
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class UnreadDialogAction extends StatelessWidget {
  const UnreadDialogAction({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.fontWeight = FontWeight.w500,
    this.isDestructive = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = isDestructive ? Colors.red : textColor;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: effectiveTextColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(64, 40),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: fontWeight,
          color: effectiveTextColor,
        ),
      ),
    );
  }
}
