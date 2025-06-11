import '../models/models.dart';

abstract class EbooksRepository {
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  });

  Future<EbookWithAuthor> getEbook(String ebookId);
}
