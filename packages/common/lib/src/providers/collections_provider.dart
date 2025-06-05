import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data_source/collections_remote_data_source.dart';
import '../repository/collections_repository.dart';
import '../repository/collections_repository_impl.dart';
import '../models/models.dart';

part 'collections_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return Dio();
}

@riverpod
CollectionsRemoteDataSource collectionsRemoteDataSource(
  CollectionsRemoteDataSourceRef ref,
) {
  final dio = ref.watch(dioProvider);
  return CollectionsRemoteDataSourceImpl(dio);
}

@riverpod
CollectionsRepository collectionsRepository(CollectionsRepositoryRef ref) {
  final remoteDataSource = ref.watch(collectionsRemoteDataSourceProvider);
  return CollectionsRepositoryImpl(remoteDataSource);
}

@riverpod
class CollectionsList extends _$CollectionsList {
  @override
  Future<CollectionsResponse> build({int page = 1, int size = 10}) async {
    final repository = ref.watch(collectionsRepositoryProvider);
    return repository.getCollections(page: page, size: size);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      return repository.getCollections(page: 1, size: 10);
    });
  }
}

@riverpod
class CollectionDetails extends _$CollectionDetails {
  @override
  Future<CollectionWithEbooks> build(String collectionId) async {
    final repository = ref.watch(collectionsRepositoryProvider);
    return repository.getCollectionWithEbooks(collectionId);
  }

  Future<void> refresh(String collectionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      return repository.getCollectionWithEbooks(collectionId);
    });
  }
}
