import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import '../../../../core/router/route_constants.dart';
import '../widget/ebook_card_widget.dart';

class CollectionDetailPage extends ConsumerStatefulWidget {
  final String collectionId;

  const CollectionDetailPage({
    super.key,
    required this.collectionId,
  });

  @override
  ConsumerState<CollectionDetailPage> createState() =>
      _CollectionDetailPageState();
}

class _CollectionDetailPageState extends ConsumerState<CollectionDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCubic),
    );
    // Delay the animation to sync with page transition
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionAsync =
        ref.watch(collectionDetailsProvider(widget.collectionId));

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAnimatedAppBar(collectionAsync),
      body: collectionAsync.when(
        data: (collection) => _buildCollectionContent(context, collection),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error.toString(), context),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar(
      AsyncValue<CollectionWithEbooks> collectionAsync) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.8, 1.0],
          ),
        ),
        child: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              _animationController.reverse().then((_) {
                context.pop();
              });
            },
            child: Row(
              children: [
                const Text(
                  '[u]',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    child: collectionAsync.when(
                      data: (collection) => Text(
                        ' / ${collection.name}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      loading: () => Text(
                        ' / ...',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      error: (_, __) => Text(
                        ' / error',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: 34,
              height: 34,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                alignment: Alignment.center,
                onPressed: () => _showCollectionMenu(context),
                icon:
                    const Icon(Icons.more_horiz, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return SizedBox(
      width: 120,
      height: 48,
      child: FloatingActionButton.extended(
        onPressed: () => _uploadBook(),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionContent(
      BuildContext context, CollectionWithEbooks collection) {
    if (collection.ebooks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 66),
        child: _buildEmptyEbooksState(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 28,
      ),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemCount: collection.ebooks.length,
              itemBuilder: (context, index) {
                final ebook = collection.ebooks[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: EbookCardWidget(
                        ebook: ebook,
                        onTap: () => context.pushNamed(
                          AppRoutes.ebookName,
                          pathParameters: {'ebookId': ebook.id},
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ebook.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${ebook.author.username}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _uploadBook() {
    // TODO: Navigate to book upload
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
    // TODO: Implement collection menu
  }
}
