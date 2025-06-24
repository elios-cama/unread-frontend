import 'package:common/src/providers/collections_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:authentication/authentication.dart';
import 'dart:io';
import '../data_source/ebooks_remote_data_source.dart';
import '../repository/ebooks_repository.dart';
import '../repository/ebooks_repository_impl.dart';
import '../models/models.dart';

part 'ebooks_provider.g.dart';

@riverpod
EbooksRemoteDataSource ebooksRemoteDataSource(Ref ref) {
  final authenticatedDio = ref.watch(authenticatedDioProvider);
  return EbooksRemoteDataSourceImpl(authenticatedDio);
}

@riverpod
EbooksRepository ebooksRepository(Ref ref) {
  final remoteDataSource = ref.watch(ebooksRemoteDataSourceProvider);
  return EbooksRepositoryImpl(remoteDataSource);
}

@riverpod
class EbooksList extends _$EbooksList {
  @override
  Future<EbooksResponse> build({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    final repository = ref.watch(ebooksRepositoryProvider);
    return repository.getEbooks(
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
      final repository = ref.read(ebooksRepositoryProvider);
      return repository.getEbooks(
        page: page,
        size: size,
        search: search,
        authorId: authorId,
      );
    });
  }
}

@riverpod
class EbookDetails extends _$EbookDetails {
  @override
  Future<EbookWithAuthor> build(String ebookId) async {
    final repository = ref.watch(ebooksRepositoryProvider);
    return repository.getEbook(ebookId);
  }

  Future<void> refresh(String ebookId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ebooksRepositoryProvider);
      return repository.getEbook(ebookId);
    });
  }
}

@riverpod
class EbookUpload extends _$EbookUpload {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<String> uploadEbookToCollection({
    required String title,
    required File file,
    required String collectionId,
    int? pageCount,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(ebooksRepositoryProvider);

      // Upload ebook using new Supabase flow
      final ebookId = await repository.uploadEbookWithSupabase(
        file: file,
        title: title,
        collectionId: collectionId,
        pageCount: pageCount,
      );

      // Add to collection
      await ref
          .read(ebookCollectionManagementProvider.notifier)
          .addEbookToCollection(
            collectionId: collectionId,
            ebookId: ebookId,
          );

      // Refresh ebook lists
      ref.invalidate(ebooksListProvider);

      return ebookId;
    });

    return state.requireValue!;
  }

  void reset() {
    state = const AsyncData(null);
  }
}
