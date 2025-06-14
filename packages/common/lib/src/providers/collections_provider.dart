import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:authentication/authentication.dart';
import '../data_source/collections_remote_data_source.dart';
import '../repository/collections_repository.dart';
import '../repository/collections_repository_impl.dart';
import '../models/models.dart';

part 'collections_provider.g.dart';

@riverpod
CollectionsRemoteDataSource collectionsRemoteDataSource(Ref ref) {
  final authenticatedDio = ref.watch(authenticatedDioProvider);
  return CollectionsRemoteDataSourceImpl(authenticatedDio);
}

@riverpod
CollectionsRepository collectionsRepository(Ref ref) {
  final remoteDataSource = ref.watch(collectionsRemoteDataSourceProvider);
  return CollectionsRepositoryImpl(remoteDataSource);
}

@riverpod
class CollectionsList extends _$CollectionsList {
  @override
  Future<CollectionsResponse> build({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    final repository = ref.watch(collectionsRepositoryProvider);
    return repository.getCollections(
      page: page,
      size: size,
      search: search,
      authorId: authorId,
    );
  }

  Future<void> refresh({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      return repository.getCollections(
        page: page,
        size: size,
        search: search,
        authorId: authorId,
      );
    });
  }
}

@riverpod
class UserCollectionsList extends _$UserCollectionsList {
  @override
  Future<CollectionsResponse> build({
    int page = 1,
    int size = 100,
  }) async {
    final repository = ref.watch(collectionsRepositoryProvider);
    return repository.getUserCollections(
      page: page,
      size: size,
    );
  }

  Future<void> refresh({
    int page = 1,
    int size = 100,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      return repository.getUserCollections(
        page: page,
        size: size,
      );
    });
  }
}

@riverpod
class UserCollectionsGrid extends _$UserCollectionsGrid {
  @override
  Future<CollectionsGridResponse> build({
    int page = 1,
    int size = 20,
  }) async {
    final repository = ref.watch(collectionsRepositoryProvider);
    return repository.getUserCollectionsGrid(
      page: page,
      size: size,
    );
  }

  Future<void> refresh({
    int page = 1,
    int size = 20,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      return repository.getUserCollectionsGrid(
        page: page,
        size: size,
      );
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

@riverpod
class CollectionCreation extends _$CollectionCreation {
  @override
  FutureOr<CollectionWithEbooks?> build() {
    // Initial state - no collection being created
    return null;
  }

  Future<CollectionWithEbooks> createCollection({
    required String name,
    String? description,
    String status = 'private',
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      final collection = await repository.createCollection(
        name: name,
        description: description,
        status: status,
      );

      // Refresh collections grid after creation
      ref.invalidate(userCollectionsGridProvider);

      return collection;
    });

    return state.requireValue!;
  }

  void reset() {
    state = const AsyncData(null);
  }
}

@riverpod
class CollectionUpdate extends _$CollectionUpdate {
  @override
  FutureOr<CollectionWithEbooks?> build() async {
    return null;
  }

  Future<void> updateCollection({
    required String collectionId,
    String? name,
    String? description,
    String? status,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      await repository.updateCollection(
        collectionId: collectionId,
        name: name,
        description: description,
        status: status,
      );

      // Refresh collection details after update
      ref.invalidate(collectionDetailsProvider(collectionId));
      ref.invalidate(userCollectionsGridProvider);

      return;
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

@riverpod
class CollectionDeletion extends _$CollectionDeletion {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> deleteCollection(String collectionId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(collectionsRepositoryProvider);
      await repository.deleteCollection(collectionId);

      ref.invalidate(userCollectionsGridProvider);
      ref.invalidate(userCollectionsListProvider);

      return;
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}
