import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/common.dart';
import 'package:design_ui/design_ui.dart';
import 'dart:ui';

class CollectionSelectorWidget extends ConsumerStatefulWidget {
  final String? selectedCollectionId;
  final Function(CollectionListItem) onCollectionSelected;
  final VoidCallback? onCreateNew;
  final bool showCreateNew;

  const CollectionSelectorWidget({
    super.key,
    this.selectedCollectionId,
    required this.onCollectionSelected,
    this.onCreateNew,
    this.showCreateNew = true,
  });

  @override
  ConsumerState<CollectionSelectorWidget> createState() =>
      _CollectionSelectorWidgetState();
}

class _CollectionSelectorWidgetState
    extends ConsumerState<CollectionSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(userCollectionsListProvider());

    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: LiquidGlassContainer(
              width: 300,
              height: 0,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Collection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    collectionsAsync.when(
                      data: (collectionsResponse) {
                        if (collectionsResponse.items.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildCollectionsList(collectionsResponse.items);
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      error: (error, stack) => _buildErrorState(),
                    ),
                    if (widget.showCreateNew) ...[
                      const SizedBox(height: 16),
                      _buildCreateNewButton(),
                    ],
                    const SizedBox(height: 16),
                    _buildCancelButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.collections_bookmark_outlined,
            color: Colors.white.withValues(alpha: 0.6),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No collections found',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white.withValues(alpha: 0.6),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load collections',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsList(List<CollectionListItem> collections) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          children: collections.map((collection) {
            final isSelected = collection.id == widget.selectedCollectionId;
            return _buildCollectionItem(collection, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCollectionItem(CollectionListItem collection, bool isSelected) {
    final color = collection.color != null
        ? CollectionColorUtils.getPrimaryColor(collection.color!)
        : Colors.purple;

    return GestureDetector(
      onTap: () => widget.onCollectionSelected(collection),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                collection.name,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return GestureDetector(
      onTap: widget.onCreateNew,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              'Create New Collection',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
