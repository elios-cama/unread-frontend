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
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
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
        createdAt: '',
        updatedAt: '',
        authorId: '',
        author: UserPublic.empty(),
      );
}
