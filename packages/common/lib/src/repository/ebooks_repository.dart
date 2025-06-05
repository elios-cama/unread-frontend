import '../models/models.dart';

abstract class EbooksRepository {
  Future<List<EbookListItem>> getEbooks({
    int page = 1,
    int size = 10,
  });

  Future<EbookWithAuthor> getEbook(String ebookId);
}
