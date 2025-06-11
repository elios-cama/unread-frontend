import '../data_source/ebooks_remote_data_source.dart';
import '../models/models.dart';
import 'ebooks_repository.dart';

class EbooksRepositoryImpl implements EbooksRepository {
  final EbooksRemoteDataSource remoteDataSource;

  EbooksRepositoryImpl(this.remoteDataSource);

  @override
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  }) async {
    try {
      return await remoteDataSource.getEbooks(
        page: page,
        size: size,
        search: search,
        authorId: authorId,
      );
    } catch (e) {
      throw Exception('Failed to get ebooks: $e');
    }
  }

  @override
  Future<EbookWithAuthor> getEbook(String ebookId) async {
    try {
      return await remoteDataSource.getEbook(ebookId);
    } catch (e) {
      throw Exception('Failed to get ebook: $e');
    }
  }
}
