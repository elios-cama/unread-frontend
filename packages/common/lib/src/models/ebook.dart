import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_public.dart';

part 'ebook.freezed.dart';
part 'ebook.g.dart';

@freezed
abstract class EbookListItem with _$EbookListItem {
  const factory EbookListItem({
    required String id,
    required String title,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    required UserPublic author,
    @JsonKey(name: 'page_count') required int pageCount,
    required String status,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _EbookListItem;

  factory EbookListItem.fromJson(Map<String, dynamic> json) =>
      _$EbookListItemFromJson(json);

  factory EbookListItem.empty() => EbookListItem(
        id: '',
        title: '',
        coverImageUrl: null,
        author: UserPublic.empty(),
        pageCount: 0,
        status: '',
        downloadCount: 0,
        createdAt: '',
      );
}

@freezed
abstract class EbookWithAuthor with _$EbookWithAuthor {
  const factory EbookWithAuthor({
    required String id,
    required String title,
    @JsonKey(name: 'page_count') required int pageCount,
    required String status,
    @JsonKey(name: 'file_path') required String filePath,
    @JsonKey(name: 'cover_image_path') required String coverImagePath,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'author_id') required String authorId,
    required UserPublic author,
  }) = _EbookWithAuthor;

  factory EbookWithAuthor.fromJson(Map<String, dynamic> json) =>
      _$EbookWithAuthorFromJson(json);

  factory EbookWithAuthor.empty() => EbookWithAuthor(
        id: '',
        title: '',
        pageCount: 0,
        status: '',
        filePath: '',
        coverImagePath: '',
        fileSize: 0,
        downloadCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authorId: '',
        author: UserPublic.empty(),
      );
}

@freezed
abstract class EbookPreview with _$EbookPreview {
  const factory EbookPreview({
    required String id,
    required String title,
    @JsonKey(name: 'cover_image_url') required String coverImageUrl,
  }) = _EbookPreview;

  factory EbookPreview.fromJson(Map<String, dynamic> json) =>
      _$EbookPreviewFromJson(json);

  factory EbookPreview.empty() => const EbookPreview(
        id: '',
        title: '',
        coverImageUrl: '',
      );
}

@freezed
abstract class EbooksResponse with _$EbooksResponse {
  const factory EbooksResponse({
    required List<EbookListItem> items,
    required int total,
    required int page,
    required int size,
    required int pages,
  }) = _EbooksResponse;

  factory EbooksResponse.fromJson(Map<String, dynamic> json) =>
      _$EbooksResponseFromJson(json);

  factory EbooksResponse.empty() => const EbooksResponse(
        items: [],
        total: 0,
        page: 1,
        size: 20,
        pages: 0,
      );
}
