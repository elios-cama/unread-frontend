import 'dart:io';
import '../models/models.dart';

abstract class EbooksRepository {
  Future<EbooksResponse> getEbooks({
    int page = 1,
    int size = 20,
    String? search,
    String? authorId,
  });

  Future<EbookWithAuthor> getEbook(String ebookId);

  Future<Ebook> createEbook({
    required String title,
    int? pageCount,
    String status = 'PRIVATE',
  });

  Future<String> uploadEbookWithSupabase({
    required File file,
    required String title,
    required String collectionId,
    int? pageCount,
  });
}
