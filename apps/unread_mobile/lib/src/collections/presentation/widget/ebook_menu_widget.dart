import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_ui/design_ui.dart';
import 'package:common/common.dart';
import 'dart:ui';
import 'collection_selector_widget.dart';

class EbookMenuWidget extends ConsumerStatefulWidget {
  final EbookWithAuthor ebook;
  final String? currentCollectionId;
  final VoidCallback? onClose;
  final bool showCloseButton;

  const EbookMenuWidget({
    super.key,
    required this.ebook,
    this.currentCollectionId,
    this.showCloseButton = false,
    this.onClose,
  });

  @override
  ConsumerState<EbookMenuWidget> createState() => _EbookMenuWidgetState();
}

class _EbookMenuWidgetState extends ConsumerState<EbookMenuWidget> {
  void _closeMenu() {
    if (widget.onClose != null) {
      widget.onClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ebookCollectionManagementAsync =
        ref.watch(ebookCollectionManagementProvider);

    if (ebookCollectionManagementAsync.isLoading) {
      return LiquidGlassContainer(
        width: 48,
        height: 48,
        borderRadius: 24,
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

    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: LiquidGlassContainer(
          width: 160,
          height: 0,
          borderRadius: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildExpandedContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuItem(
            icon: Icons.add_to_photos_outlined,
            label: 'Add to Collection',
            onTap: () => _handleAddToCollection(),
          ),
          if (widget.currentCollectionId != null) ...[
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.remove_circle_outline,
              label: 'Remove from Collection',
              onTap: () => _handleRemoveFromCollection(),
              isDestructive: true,
            ),
          ],
          if (widget.showCloseButton) ...[
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _closeMenu,
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
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: () {
        _closeMenu();
        onTap();
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddToCollection() {
    _showCollectionSelector();
  }

  void _handleRemoveFromCollection() {
    _showRemoveConfirmationDialog();
  }

  void _showCollectionSelector() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => CollectionSelectorWidget(
        onCollectionSelected: (collection) async {
          Navigator.of(context).pop();
          await _addEbookToCollection(collection.id);
        },
        onCreateNew: () async {
          Navigator.of(context).pop();
          try {
            final collection = await ref
                .read(collectionCreationProvider.notifier)
                .createCollection(
                  name: 'New Collection',
                  description: '',
                  status: 'private',
                );
            await _addEbookToCollection(collection.id);
          } catch (e) {
            _showErrorDialog('Failed to create collection');
          }
        },
      ),
    );
  }

  Future<void> _addEbookToCollection(String collectionId) async {
    try {
      await ref
          .read(ebookCollectionManagementProvider.notifier)
          .addEbookToCollection(
            collectionId: collectionId,
            ebookId: widget.ebook.id,
          );
      _showSuccessDialog('Ebook added to collection');
    } catch (e) {
      _showErrorDialog('Failed to add ebook to collection');
    }
  }

  void _showRemoveConfirmationDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Dialog(
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
                        'Remove from Collection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Are you sure you want to remove "${widget.ebook.title}" from this collection?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              await _removeEbookFromCollection();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _removeEbookFromCollection() async {
    if (widget.currentCollectionId == null) return;

    try {
      await ref
          .read(ebookCollectionManagementProvider.notifier)
          .removeEbookFromCollection(
            collectionId: widget.currentCollectionId!,
            ebookId: widget.ebook.id,
          );
      _showSuccessDialog('Ebook removed from collection');
    } catch (e) {
      _showErrorDialog('Failed to remove ebook from collection');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Success',
        content: message,
        actions: [
          UnreadDialogAction(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => UnreadDialog(
        title: 'Error',
        content: message,
        actions: [
          UnreadDialogAction(
            text: 'OK',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
