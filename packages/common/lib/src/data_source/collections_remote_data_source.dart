import 'package:dio/dio.dart';
import '../models/models.dart';

abstract class CollectionsRemoteDataSource {
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  });

  Future<CollectionsResponse> getUserCollections({
    int page = 1,
    int size = 100,
  });

  Future<CollectionsGridResponse> getUserCollectionsGrid({
    int page = 1,
    int size = 20,
  });

  Future<CollectionWithEbooks> getCollectionWithEbooks(String collectionId);
}

class CollectionsRemoteDataSourceImpl implements CollectionsRemoteDataSource {
  final Dio dio;

  CollectionsRemoteDataSourceImpl(this.dio);

  @override
  Future<CollectionsResponse> getCollections({
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
        '/api/v1/collections',
        queryParameters: queryParameters,
      );

      return CollectionsResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch collections: ${e.message}');
    }
  }

  @override
  Future<CollectionsResponse> getUserCollections({
    int page = 1,
    int size = 100,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'skip': (page - 1) * size,
        'limit': size,
      };

      final response = await dio.get(
        '/api/v1/collections/me',
        queryParameters: queryParameters,
      );

      return CollectionsResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user collections: ${e.message}');
    }
  }

  @override
  Future<CollectionsGridResponse> getUserCollectionsGrid({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': size,
      };

      final response = await dio.get(
        '/api/v1/collections/me/grid',
        queryParameters: queryParameters,
      );

      return CollectionsGridResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user collections grid: ${e.message}');
    }
  }

  @override
  Future<CollectionWithEbooks> getCollectionWithEbooks(
      String collectionId) async {
    try {
      final response = await dio.get('/api/v1/collections/$collectionId');

      return CollectionWithEbooks.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch collection with ebooks: ${e.message}');
    }
  }
}
