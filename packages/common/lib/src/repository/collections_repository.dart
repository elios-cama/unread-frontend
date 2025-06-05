import '../models/models.dart';

abstract class CollectionsRepository {
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 10,
  });

  Future<CollectionWithEbooks> getCollectionWithEbooks(String collectionId);
}
