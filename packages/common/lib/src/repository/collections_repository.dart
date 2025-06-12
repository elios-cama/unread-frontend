import '../models/models.dart';

abstract class CollectionsRepository {
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

  Future<CollectionWithEbooks> createCollection({
    required String name,
    String? description,
    String status = 'private',
  });

  Future<CollectionWithEbooks> updateCollection({
    required String collectionId,
    String? name,
    String? description,
    String? status,
  });

  Future<void> deleteCollection(String collectionId);

  Future<void> addEbookToCollection({
    required String collectionId,
    required String ebookId,
  });

  Future<void> removeEbookFromCollection({
    required String collectionId,
    required String ebookId,
  });
}
