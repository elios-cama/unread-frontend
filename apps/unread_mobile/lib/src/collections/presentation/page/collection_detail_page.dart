import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/router/route_constants.dart';
import '../widget/ebook_card_widget.dart';
import '../widget/collection_menu_widget.dart';

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
  late ScrollController _scrollController;

  bool _isEditing = false;
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;
  bool _isMenuExpanded = false;

  double _squareSize = 0;
  double _maxSquareSize = 0;
  static const double _scrollThreshold = 200;

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

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _titleController = TextEditingController();
    _titleFocusNode = FocusNode();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    final offset = _scrollController.offset;
    final progress = (offset / _scrollThreshold).clamp(0.0, 1.0);
    final newSize = _maxSquareSize * (1.0 - progress);

    if (newSize != _squareSize) {
      setState(() {
        _squareSize = newSize;
      });
    }
  }

  void _initializeSquareSize(BuildContext context) {
    if (_maxSquareSize == 0) {
      _maxSquareSize = MediaQuery.of(context).size.width - 64;
      _squareSize = _maxSquareSize;
    }
  }

  void _startEditing(String currentTitle) {
    setState(() {
      _isEditing = true;
      _titleController.text =
          currentTitle.isEmpty ? 'untitled project' : currentTitle;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _titleFocusNode.requestFocus();
      _titleController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _titleController.text.length,
      );
    });
  }

  void _finishEditing() async {
    if (!_isEditing) return;

    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) {
      _titleController.text = 'untitled project';
    }

    setState(() {
      _isEditing = false;
    });
    _titleFocusNode.unfocus();

    try {
      await ref.read(collectionUpdateProvider.notifier).updateCollection(
            collectionId: widget.collectionId,
            name: _titleController.text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update collection name: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleCollectionMenu() {
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
    });
  }

  Future<void> _deleteCollection() async {
    try {
      await ref
          .read(collectionDeletionProvider.notifier)
          .deleteCollection(widget.collectionId);
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete collection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeSquareSize(context);
    final collectionAsync =
        ref.watch(collectionDetailsProvider(widget.collectionId));

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAnimatedAppBar(collectionAsync),
      body: GestureDetector(
        onTap: () {
          if (_isMenuExpanded) {
            _toggleCollectionMenu();
          }
        },
        child: Stack(
          children: [
            collectionAsync.when(
              data: (collection) =>
                  _buildCollectionContent(context, collection),
              loading: () => _buildLoadingState(),
              error: (error, stack) =>
                  _buildErrorState(error.toString(), context),
            ),
            if (_isMenuExpanded)
              Positioned(
                top: 100,
                right: 24,
                child: collectionAsync.when(
                  data: (collection) => CollectionMenuWidget(
                    collectionId: widget.collectionId,
                    collectionName: collection.name.isEmpty
                        ? 'untitled project'
                        : collection.name,
                    onClose: () => _toggleCollectionMenu(),
                    onDelete: _deleteCollection,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      ),
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
                        ' / ${collection.name.isEmpty ? 'untitled project' : collection.name}',
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
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: collectionAsync.when(
                data: (collection) => GestureDetector(
                  onTap: () => _toggleCollectionMenu(),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionContent(
      BuildContext context, CollectionWithEbooks collection) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_squareSize > 0) ...[
                  _buildDynamicSquare(collection),
                  const SizedBox(height: 32),
                ],
                _buildEditableTitle(collection),
                const SizedBox(height: 8),
                _buildBookCount(collection),
                if (collection.ebooks.isEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAddBooksButton(),
                ],
                if (collection.ebooks.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildGridHeader(collection),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        if (collection.ebooks.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                childCount: collection.ebooks.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildDynamicSquare(CollectionWithEbooks collection) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: _squareSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: collection.color != null
            ? CollectionColorUtils.createGradient(
                collection.color!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withValues(alpha: 0.8),
                  Colors.blue.withValues(alpha: 0.8),
                ],
              ),
      ),
      child: collection.ebooks.isNotEmpty
          ? _buildBookCoversGrid(collection.ebooks)
          : null,
    );
  }

  Widget _buildBookCoversGrid(List<EbookWithAuthor> ebooks) {
    final coversToShow = ebooks.take(4).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: coversToShow.length == 1 ? 1 : 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: coversToShow.length,
        itemBuilder: (context, index) {
          final ebook = coversToShow[index];
          return _buildBookCover(ebook);
        },
      ),
    );
  }

  Widget _buildBookCover(EbookWithAuthor ebook) {
    final coverPath = ebook.coverImagePath;

    if (coverPath.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: coverPath,
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
        errorWidget: (context, url, error) => _buildPlaceholderCover(),
      );
    }

    return _buildPlaceholderCover();
  }

  Widget _buildPlaceholderCover() {
    return Container(
      color: Colors.grey[800],
      child: Icon(
        Icons.book,
        color: Colors.white.withValues(alpha: 0.5),
        size: 24,
      ),
    );
  }

  Widget _buildEditableTitle(CollectionWithEbooks collection) {
    if (_isEditing) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              controller: _titleController,
              focusNode: _titleFocusNode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onSubmitted: (_) => _finishEditing(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _finishEditing,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _startEditing(collection.name),
      child: Text(
        collection.name.isEmpty ? 'untitled project' : collection.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBookCount(CollectionWithEbooks collection) {
    return Text(
      '${collection.ebooks.length} ${collection.ebooks.length == 1 ? 'book' : 'books'}',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 16,
      ),
    );
  }

  Widget _buildGridHeader(CollectionWithEbooks collection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Books',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildAddBooksButton(),
      ],
    );
  }

  Widget _buildAddBooksButton() {
    return GestureDetector(
      onTap: _showAddBooksDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            const Text(
              'Add books',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBooksDialog() {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Add Books',
        content:
            'Feature coming soon! You\'ll be able to add books from your library to this collection.',
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
}
