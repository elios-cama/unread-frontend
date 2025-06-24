import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_ui/design_ui.dart';
import 'package:common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import 'dart:io';

class AddBooksToCollectionDialog extends ConsumerStatefulWidget {
  final String collectionId;

  const AddBooksToCollectionDialog({
    super.key,
    required this.collectionId,
  });

  @override
  ConsumerState<AddBooksToCollectionDialog> createState() =>
      _AddBooksToCollectionDialogState();
}

class _AddBooksToCollectionDialogState
    extends ConsumerState<AddBooksToCollectionDialog> {
  File? selectedFile;
  String? selectedFileName;
  final TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ebookUploadAsync = ref.watch(ebookUploadProvider);

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
              width: 320,
              height: 0,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Book to Collection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (ebookUploadAsync.isLoading)
                      _buildLoadingState()
                    else if (selectedFile == null)
                      _buildFileSelector()
                    else
                      _buildFileSelected(),
                    const SizedBox(height: 16),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Uploading book...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.upload_file,
            color: Colors.white.withValues(alpha: 0.6),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Select an ebook file to upload',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Supported formats: EPUB, PDF, MOBI, TXT, AZW3',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_open,
                    color: Colors.blue,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Choose File',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelected() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedFileName ?? 'Unknown file',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFile = null;
                      selectedFileName = null;
                      titleController.clear();
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Book Title',
              labelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              hintText: 'Enter the book title',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final hasFile = selectedFile != null;
    final hasTitle = titleController.text.trim().isNotEmpty;
    final canUpload = hasFile && hasTitle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          onTap: canUpload ? _uploadBook : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: canUpload
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: canUpload
                    ? Colors.blue.withValues(alpha: 0.5)
                    : Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Upload',
              style: TextStyle(
                color: canUpload ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub', 'pdf', 'mobi', 'txt', 'azw3'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final fileName = result.files.first.name;

        setState(() {
          selectedFile = file;
          selectedFileName = fileName;
          // Auto-populate title from filename (remove extension)
          final nameWithoutExtension = fileName.split('.').first;
          titleController.text =
              nameWithoutExtension.replaceAll('_', ' ').replaceAll('-', ' ');
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick file: $e');
    }
  }

  Future<void> _uploadBook() async {
    if (selectedFile == null || titleController.text.trim().isEmpty) return;

    try {
      await ref.read(ebookUploadProvider.notifier).uploadEbookToCollection(
            title: titleController.text.trim(),
            file: selectedFile!,
            collectionId: widget.collectionId,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to upload book: $e');
      }
    }
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
