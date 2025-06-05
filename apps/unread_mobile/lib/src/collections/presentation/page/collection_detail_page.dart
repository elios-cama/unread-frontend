import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import '../../../../core/router/route_constants.dart';
import '../widget/ebook_card_widget.dart';

class CollectionDetailPage extends ConsumerWidget {
  final String collectionId;

  const CollectionDetailPage({
    super.key,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionDetailsProvider(collectionId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: collectionAsync.when(
          data: (collection) => _buildCollectionContent(context, collection),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error.toString(), context),
        ),
      ),
    );
  }

  Widget _buildCollectionContent(
      BuildContext context, CollectionWithEbooks collection) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 120,
          floating: false,
          pinned: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () => _showCollectionMenu(context),
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              collection.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCollectionInfo(collection),
                const SizedBox(height: 24),
                _buildSectionHeader('${collection.ebooks.length} ebooks'),
              ],
            ),
          ),
        ),
        if (collection.ebooks.isEmpty)
          SliverFillRemaining(
            child: _buildEmptyEbooksState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ebook = collection.ebooks[index];
                  return EbookCardWidget(
                    ebook: ebook,
                    onTap: () => context.pushNamed(
                      AppRoutes.ebookName,
                      pathParameters: {'ebookId': ebook.id},
                    ),
                  );
                },
                childCount: collection.ebooks.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  Widget _buildCollectionInfo(CollectionWithEbooks collection) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(collection.status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(collection.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(collection.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '@${collection.author.username}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (collection.description != null) ...[
            const SizedBox(height: 12),
            Text(
              collection.description!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorState(String error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load collection',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          UnreadButton(
            text: 'Go Back',
            onPressed: () => context.pop(),
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            borderColor: Colors.white,
            borderWidth: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEbooksState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BookIconWidget(
            size: 80,
            useBlueBook: true,
          ),
          const SizedBox(height: 24),
          Text(
            'No ebooks in this collection',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some ebooks to get started',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showCollectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text(
                'Share Collection',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                'Edit Collection',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'public':
        return Colors.green;
      case 'private':
        return Colors.orange;
      case 'invite_only':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'public':
        return 'PUBLIC';
      case 'private':
        return 'PRIVATE';
      case 'invite_only':
        return 'INVITE ONLY';
      default:
        return 'UNKNOWN';
    }
  }
}
