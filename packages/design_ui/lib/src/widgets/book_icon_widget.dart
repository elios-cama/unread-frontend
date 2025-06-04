import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class BookIconWidget extends StatelessWidget {
  const BookIconWidget({
    super.key,
    this.size = 120,
    this.useBlueBook = false,
  });

  final double size;
  final bool useBlueBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Image.asset(
        useBlueBook ? Books.bookBlue : Books.bookWhite,
        package: 'app_ui',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
