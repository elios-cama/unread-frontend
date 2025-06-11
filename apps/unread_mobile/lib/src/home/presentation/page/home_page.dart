import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import 'package:unread_mobile/src/auth/presentation/provider/auth_provider.dart';
import 'package:unread_mobile/src/auth/domain/model/auth_state_model.dart';
import '../../../../core/router/route_constants.dart';
import '../../../collections/presentation/widget/collection_card_widget.dart';

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
            bottom: 24,
            left: MediaQuery.of(context).size.width / 2 - 60,
            child: _buildFloatingButton(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(WidgetRef ref) {
    return Container(
      width: 120,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _uploadBook(ref),
          borderRadius: BorderRadius.circular(24),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'Upload',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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

  void _uploadBook(WidgetRef ref) {
    // ref.read(authProvider.notifier).getStoredUser();
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
