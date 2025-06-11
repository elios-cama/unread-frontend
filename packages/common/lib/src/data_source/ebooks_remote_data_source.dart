import 'package:dio/dio.dart';
import '../models/models.dart';

abstract class EbooksRemoteDataSource {
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  });

  Future<EbookWithAuthor> getEbook(String ebookId);
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
}
