import '../data_source/collections_remote_data_source.dart';
import '../models/models.dart';
import 'collections_repository.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  final CollectionsRemoteDataSource remoteDataSource;

  CollectionsRepositoryImpl(this.remoteDataSource);

  @override
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 10,
  }) async {
    try {
      return await remoteDataSource.getCollections(page: page, size: size);
    } catch (e) {
      throw Exception('Failed to get collections: $e');
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
}
