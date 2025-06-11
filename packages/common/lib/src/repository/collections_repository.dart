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
}
