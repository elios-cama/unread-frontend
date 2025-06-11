import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:authentication/authentication.dart';
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
