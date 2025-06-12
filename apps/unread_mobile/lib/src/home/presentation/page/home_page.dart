import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import 'package:unread_mobile/src/auth/presentation/provider/auth_provider.dart';
import 'package:unread_mobile/src/auth/domain/model/auth_state_model.dart';
import '../../../../core/router/route_constants.dart';
import '../../../collections/presentation/widget/collection_card_widget.dart';
import 'dart:ui';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(userCollectionsGridProvider());

    // Listen for auth state changes and redirect if unauthenticated
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        debugPrint('🔄 Auth state changed to unauthenticated, redirecting...');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go(AppRoutes.auth);
          }
        });
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
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
            title: Row(
              children: [
                const Text(
                  'Unread',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _showSignOutDialog(context, ref),
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          collectionsAsync.when(
            data: (collectionsGridResponse) =>
                _buildHomeContent(context, collectionsGridResponse),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: _ExpandableUploadButton(ref: ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(
      BuildContext context, CollectionsGridResponse collectionsGridResponse) {
    if (collectionsGridResponse.items.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCollectionsSection(context, collectionsGridResponse.items),
        ],
      ),
    );
  }

  Widget _buildCollectionsSection(
      BuildContext context, List<CollectionWithPreviews> collections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CollectionCardWidget(
                    collection: collection,
                    onTap: () => context.pushNamed(
                      AppRoutes.collectionName,
                      pathParameters: {'collectionId': collection.id},
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  collection.name,
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
                  '${collection.ebookCount} books',
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
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorState(String error) {
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
            'Failed to load collections',
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
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        const BookIconWidget(
          size: 120,
          useBlueBook: true,
        ),
        const SizedBox(height: 32),
        const Text(
          'Welcome to Unread!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your ebook sanctuary is ready.\nStart by uploading your first book.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Sign Out',
        content: 'Are you sure you want to sign out?',
        actions: [
          UnreadDialogAction(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          UnreadDialogAction(
            text: 'Sign Out',
            onPressed: () async {
              Navigator.of(context).pop();

              debugPrint('🔄 Starting sign out process...');

              // Sign out - the auth state listener will handle navigation
              await ref.read(authProvider.notifier).signOut();

              debugPrint('✅ Sign out completed');
            },
            isDestructive: true,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _ExpandableUploadButton extends StatefulWidget {
  final WidgetRef ref;

  const _ExpandableUploadButton({required this.ref});

  @override
  State<_ExpandableUploadButton> createState() =>
      _ExpandableUploadButtonState();
}

class _ExpandableUploadButtonState extends State<_ExpandableUploadButton>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _iconController;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _menuOpacityAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 180 degrees (1/2 of a full rotation)
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));

    _menuOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _mainController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isExpanded) {
      // First start collapsing animations
      _mainController.reverse();
      _iconController.reverse();

      // Then update state after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _isExpanded = false;
          });
        }
      });
    } else {
      // Update state immediately for expansion
      setState(() {
        _isExpanded = true;
      });

      // Then start the animations
      _mainController.forward();
      _iconController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionCreationAsync =
        widget.ref.watch(collectionCreationProvider);

    // Show loading state if collection is being created
    if (collectionCreationAsync.isLoading) {
      return _buildLiquidGlassContainer(
        width: 120,
        height: 48,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      width: _isExpanded ? 220 : 120,
      height: _isExpanded ? 220 : 48,
      child: _buildLiquidGlassContainer(
        width: _isExpanded ? 220 : 120,
        height: _isExpanded ? 220 : 48,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: _isExpanded ? null : _toggleMenu,
          borderRadius: BorderRadius.circular(_isExpanded ? 16 : 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_isExpanded ? 16 : 24),
            child: _isExpanded
                ? _buildExpandedContent()
                : _buildCollapsedContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidGlassContainer({
    required double width,
    required double height,
    required Widget child,
  }) {
    final isCircular =
        height < 100; // Assuming collapsed state is more circular
    final borderRadiusValue = isCircular ? 24.0 : 16.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 12, sigmaY: 12), // Slightly more blur for softer glass
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15), // More transparent
                Colors.white.withValues(alpha: 0.05), // Even more transparent
              ],
              stops: const [0.1, 0.9], // Adjusted stops for smoother transition
            ),
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: Border.all(
              color: Colors.white
                  .withValues(alpha: 0.15), // Thinner, more transparent border
              width: 1.0,
            ),
            boxShadow: [
              // Very soft outer shadow for subtle depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 25,
                offset: const Offset(0, 5),
                spreadRadius: -10,
              ),
            ],
          ),
          child: child, // Removed the inner shimmer Stack for a cleaner glass
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _iconRotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _iconRotationAnimation.value * 2 * 3.14159,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            );
          },
        ),
        const SizedBox(width: 6),
        const Text(
          'Upload',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return FadeTransition(
      opacity: _menuOpacityAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Book',
                  onTap: () => _handleMenuAction('book'),
                ),
                _buildMenuItem(
                  icon: Icons.video_camera_back_outlined,
                  label: 'Convert',
                  onTap: () => _handleMenuAction('convert'),
                ),
                _buildMenuItem(
                  icon: Icons.add_circle_outline_outlined,
                  label: 'New Collection',
                  onTap: () => _handleMenuAction('collection'),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _toggleMenu,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Transform.rotate(
                      angle: _iconRotationAnimation.value * 3.14159,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        _toggleMenu();
        onTap();
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
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

  void _handleMenuAction(String action) {
    debugPrint('🎯 Menu action selected: $action');

    switch (action) {
      case 'book':
        _uploadBook();
        break;
      case 'convert':
        _convertFile();
        break;
      case 'collection':
        _createNewCollection();
        break;
    }
  }

  void _uploadBook() {}

  void _convertFile() {
    debugPrint('🔄 Convert file action');
    // TODO: Implement file conversion
  }

  void _createNewCollection() async {
    debugPrint('📝 Create new collection action');
    try {
      // Create collection using the provider
      final collection = await widget.ref
          .read(collectionCreationProvider.notifier)
          .createCollection(
            name: 'untitled project',
            description: '',
            status: 'private',
          );

      if (context.mounted) {
        // Navigate to the newly created collection
        context.pushNamed(
          AppRoutes.collectionName,
          pathParameters: {'collectionId': collection.id},
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Reset the provider state on error
        widget.ref.read(collectionCreationProvider.notifier).reset();

        // Show error message
        showDialog(
          context: context,
          builder: (context) => UnreadDialog(
            title: 'Error',
            content: 'Failed to create collection',
            actions: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
