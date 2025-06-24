import 'package:dio/dio.dart';
import 'dart:io';
import '../models/models.dart';

abstract class EbooksRemoteDataSource {
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  });

  Future<EbookWithAuthor> getEbook(String ebookId);

  Future<Ebook> createEbook({
    required String title,
    int? pageCount,
    String status = 'PRIVATE',
  });

  Future<UploadUrlResponse> getUploadUrl({
    required String fileExtension,
    String? collectionId,
  });

  Future<void> uploadFileToSupabase({
    required String signedUrl,
    required File file,
  });

  Future<ConfirmUploadResponse> confirmUpload({
    required String filePath,
    required String bucket,
    required String ebookId,
  });
}

class EbooksRemoteDataSourceImpl implements EbooksRemoteDataSource {
  final Dio dio;

  EbooksRemoteDataSourceImpl(this.dio);

  @override
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'skip': (page - 1) * size,
        'limit': size,
      };

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      if (authorId != null && authorId.isNotEmpty) {
        queryParameters['author_id'] = authorId;
      }

      final response = await dio.get(
        '/api/v1/ebooks',
        queryParameters: queryParameters,
      );

      return EbooksResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch ebooks: ${e.message}');
    }
  }

  @override
  Future<EbookWithAuthor> getEbook(String ebookId) async {
    try {
      final response = await dio.get('/api/v1/ebooks/$ebookId');

      return EbookWithAuthor.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch ebook: ${e.message}');
    }
  }

  @override
  Future<Ebook> createEbook({
    required String title,
    int? pageCount,
    String status = 'PRIVATE',
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/ebooks/',
        data: {
          'title': title,
          'page_count': pageCount,
          'status': status,
        },
      );

      return Ebook.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to create ebook: ${e.message}');
    }
  }

  @override
  Future<UploadUrlResponse> getUploadUrl({
    required String fileExtension,
    String? collectionId,
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/ebooks/upload-url',
        data: {
          'file_extension': fileExtension,
          if (collectionId != null) 'collection_id': collectionId,
        },
      );

      return UploadUrlResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to get upload URL: ${e.message}');
    }
  }

  @override
  Future<void> uploadFileToSupabase({
    required String signedUrl,
    required File file,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final mimeType = _getMimeType(file.path);

      final response = await dio.put(
        signedUrl,
        data: bytes,
        options: Options(
          headers: {
            'Content-Type': mimeType,
          },
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to upload file to Supabase: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to upload file to Supabase: ${e.message}');
    }
  }

  @override
  Future<ConfirmUploadResponse> confirmUpload({
    required String filePath,
    required String bucket,
    required String ebookId,
  }) async {
    try {
      final response = await dio.post(
        '/api/v1/ebooks/confirm-upload',
        data: {
          'file_path': filePath,
          'bucket': bucket,
          'ebook_id': ebookId,
        },
      );

      return ConfirmUploadResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to confirm upload: ${e.message}');
    }
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'epub':
        return 'application/epub+zip';
      case 'pdf':
        return 'application/pdf';
      case 'mobi':
        return 'application/x-mobipocket-ebook';
      case 'azw3':
        return 'application/vnd.amazon.ebook';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}
