import 'dart:math';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:app_ui/app_ui.dart';
import 'package:design_ui/design_ui.dart';

class EbookCardWidget extends StatelessWidget {
  final EbookWithAuthor ebook;
  final VoidCallback onTap;

  const EbookCardWidget({
    super.key,
    required this.ebook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _getCoverImage(),
          ),
        ),
      ),
    );
  }

  Widget _getCoverImage() {
    // If we have a real cover image, we would use it here
    // For now, we'll use a random book image as a placeholder
    final coverPath = _getRandomBookCover();

    return UnreadAsset(
      path: coverPath,
      fit: BoxFit.cover,
    );
  }

  String _getRandomBookCover() {
    final allBookImages = [
      Books.bookBlack,
      Books.bookBlue,
      Books.bookGreen,
      Books.bookGrey,
      Books.bookNavy,
      Books.bookRed,
      Books.bookWhite,
      BooksGenerated.camusBook,
      BooksGenerated.debrayBook,
      BooksGenerated.rubinBook,
      BooksGenerated.siddharthaBook,
      BooksGenerated.tessonBook,
    ];

    // Use the ebook ID as a seed for consistent randomization
    final random = Random(ebook.id.hashCode);
    return allBookImages[random.nextInt(allBookImages.length)];
  }
}
