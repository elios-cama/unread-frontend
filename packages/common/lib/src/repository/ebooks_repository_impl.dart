import 'dart:io';
import '../data_source/ebooks_remote_data_source.dart';
import '../models/models.dart';
import 'ebooks_repository.dart';

class EbooksRepositoryImpl implements EbooksRepository {
  final EbooksRemoteDataSource remoteDataSource;

  EbooksRepositoryImpl(this.remoteDataSource);

  @override
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    try {
      return await remoteDataSource.getEbooks(
        page: page,
        size: size,
        search: search,
        authorId: authorId,
      );
    } catch (e) {
      throw Exception('Failed to get ebooks: $e');
    }
  }

  @override
  Future<EbookWithAuthor> getEbook(String ebookId) async {
    try {
      return await remoteDataSource.getEbook(ebookId);
    } catch (e) {
      throw Exception('Failed to get ebook: $e');
    }
  }

  @override
  Future<Ebook> createEbook({
    required String title,
    int? pageCount,
    String status = 'PRIVATE',
  }) async {
    try {
      return await remoteDataSource.createEbook(
        title: title,
        pageCount: pageCount,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to create ebook: $e');
    }
  }

  @override
  Future<String> uploadEbookWithSupabase({
    required File file,
    required String title,
    required String collectionId,
    int? pageCount,
  }) async {
    try {
      // Step 1: Get signed upload URL
      final fileExtension = _getFileExtension(file.path);
      final uploadUrlResponse = await remoteDataSource.getUploadUrl(
        fileExtension: fileExtension,
        collectionId: collectionId,
      );

      // Step 2: Upload file directly to Supabase
      await remoteDataSource.uploadFileToSupabase(
        signedUrl: uploadUrlResponse.signedUrl,
        file: file,
      );

      // Step 3: Create ebook record
      final ebook = await remoteDataSource.createEbook(
        title: title,
        pageCount: pageCount,
        status: 'PRIVATE',
      );

      // Step 4: Confirm upload and link file
      await remoteDataSource.confirmUpload(
        filePath: uploadUrlResponse.filePath,
        bucket: uploadUrlResponse.bucket,
        ebookId: ebook.id,
      );

      return ebook.id;
    } catch (e) {
      throw Exception('Failed to upload ebook with Supabase: $e');
    }
  }

  String _getFileExtension(String filePath) {
    final parts = filePath.split('.');
    if (parts.length > 1) {
      return '.${parts.last.toLowerCase()}';
    }
    return '.epub'; // Default fallback
  }
}
