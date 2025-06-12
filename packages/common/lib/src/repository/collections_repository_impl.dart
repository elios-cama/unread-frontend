import '../data_source/collections_remote_data_source.dart';
import '../models/models.dart';
import 'collections_repository.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  final CollectionsRemoteDataSource remoteDataSource;

  CollectionsRepositoryImpl(this.remoteDataSource);

  @override
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    try {
      return await remoteDataSource.getCollections(
        page: page,
        size: size,
        search: search,
        authorId: authorId,
      );
    } catch (e) {
      throw Exception('Failed to get collections: $e');
    }
  }

  @override
  Future<CollectionsResponse> getUserCollections({
    int page = 1,
    int size = 100,
  }) async {
    try {
      return await remoteDataSource.getUserCollections(
        page: page,
        size: size,
      );
    } catch (e) {
      throw Exception('Failed to get user collections: $e');
    }
  }

  @override
  Future<CollectionsGridResponse> getUserCollectionsGrid({
    int page = 1,
    int size = 20,
  }) async {
    try {
      return await remoteDataSource.getUserCollectionsGrid(
        page: page,
        size: size,
      );
    } catch (e) {
      throw Exception('Failed to get user collections grid: $e');
    }
  }

  @override
  Future<CollectionWithEbooks> getCollectionWithEbooks(
      String collectionId) async {
    try {
      return await remoteDataSource.getCollectionWithEbooks(collectionId);
    } catch (e) {
      throw Exception('Failed to get collection with ebooks: $e');
    }
  }

  @override
  Future<CollectionWithEbooks> createCollection({
    required String name,
    String? description,
    String status = 'private',
  }) async {
    try {
      return await remoteDataSource.createCollection(
        name: name,
        description: description,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to create collection: $e');
    }
  }

  @override
  Future<CollectionWithEbooks> updateCollection({
    required String collectionId,
    String? name,
    String? description,
    String? status,
  }) async {
    try {
      return await remoteDataSource.updateCollection(
        collectionId: collectionId,
        name: name,
        description: description,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to update collection: $e');
    }
  }

  @override
  Future<void> deleteCollection(String collectionId) async {
    try {
      await remoteDataSource.deleteCollection(collectionId);
    } catch (e) {
      throw Exception('Failed to delete collection: $e');
    }
  }

  @override
  Future<void> addEbookToCollection({
    required String collectionId,
    required String ebookId,
  }) async {
    try {
      await remoteDataSource.addEbookToCollection(
        collectionId: collectionId,
        ebookId: ebookId,
      );
    } catch (e) {
      throw Exception('Failed to add ebook to collection: $e');
    }
  }

  @override
  Future<void> removeEbookFromCollection({
    required String collectionId,
    required String ebookId,
  }) async {
    try {
      await remoteDataSource.removeEbookFromCollection(
        collectionId: collectionId,
        ebookId: ebookId,
      );
    } catch (e) {
      throw Exception('Failed to remove ebook from collection: $e');
    }
  }
}
