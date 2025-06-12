import 'dart:math';
import 'package:design_ui/design_ui.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CollectionCardWidget extends StatelessWidget {
  final CollectionWithPreviews collection;
  final VoidCallback onTap;

  const CollectionCardWidget({
    super.key,
    required this.collection,
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
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildBookCoversGrid(),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCoversGrid() {
    final hasRealCovers = collection.coverPreviews.isNotEmpty;

    if (hasRealCovers) {
      return _buildRealCoverGrid();
    } else if (collection.color != null) {
      return _buildGradientBackground();
    } else {
      return _buildPlaceholderGrid();
    }
  }

  Widget _buildRealCoverGrid() {
    final previews = collection.coverPreviews.take(4).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: previews.length,
      itemBuilder: (context, index) {
        final preview = previews[index];
        return CachedNetworkImage(
          imageUrl: preview.coverImageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[800],
            child: const Icon(
              Icons.book,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: CollectionColorUtils.createGradient(
          collection.color!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildPlaceholderGrid() {
    final bookImages = _getRandomBookImages();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: bookImages.length,
      itemBuilder: (context, index) {
        return Container(
          child: UnreadAsset(
            path: bookImages[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  List<String> _getRandomBookImages() {
    final allBookImages = [
      Books.bookBlack,
      Books.bookBlue,
      Books.bookGreen,
      Books.bookGrey,
      Books.bookNavy,
      Books.bookRed,
      Books.bookWhite,
    ];

    final random = Random(collection.id.hashCode);
    final shuffled = List<String>.from(allBookImages)..shuffle(random);

    final count = random.nextInt(4) + 1;
    return shuffled.take(count).toList();
  }
}
