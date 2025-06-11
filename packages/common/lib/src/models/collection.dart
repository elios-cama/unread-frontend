import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_public.dart';
import 'ebook.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
abstract class CollectionListItem with _$CollectionListItem {
  const factory CollectionListItem({
    required String id,
    required String name,
    String? description,
    required String status,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required UserPublic author,
  }) = _CollectionListItem;

  factory CollectionListItem.fromJson(Map<String, dynamic> json) =>
      _$CollectionListItemFromJson(json);

  factory CollectionListItem.empty() => CollectionListItem(
        id: '',
        name: '',
        description: null,
        status: '',
        authorId: '',
        createdAt: '',
        updatedAt: '',
        author: UserPublic.empty(),
      );
}

@freezed
abstract class CollectionWithEbooks with _$CollectionWithEbooks {
  const factory CollectionWithEbooks({
    required String id,
    required String name,
    String? description,
    required String status,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required UserPublic author,
    required List<EbookWithAuthor> ebooks,
  }) = _CollectionWithEbooks;

  factory CollectionWithEbooks.fromJson(Map<String, dynamic> json) =>
      _$CollectionWithEbooksFromJson(json);

  factory CollectionWithEbooks.empty() => CollectionWithEbooks(
        id: '',
        name: '',
        description: null,
        status: '',
        authorId: '',
        createdAt: '',
        updatedAt: '',
        author: UserPublic.empty(),
        ebooks: [],
      );
}

@freezed
abstract class CollectionsResponse with _$CollectionsResponse {
  const factory CollectionsResponse({
    required List<CollectionListItem> items,
    required int total,
    required int page,
    required int size,
    required int pages,
  }) = _CollectionsResponse;

  factory CollectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionsResponseFromJson(json);

  factory CollectionsResponse.empty() => const CollectionsResponse(
        items: [],
        total: 0,
        page: 1,
        size: 20,
        pages: 0,
      );
}

@freezed
abstract class CollectionWithPreviews with _$CollectionWithPreviews {
  const factory CollectionWithPreviews({
    required String id,
    required String name,
    required String description,
    required String status,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'ebook_count') required int ebookCount,
    @JsonKey(name: 'cover_previews') required List<EbookPreview> coverPreviews,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CollectionWithPreviews;

  factory CollectionWithPreviews.fromJson(Map<String, dynamic> json) =>
      _$CollectionWithPreviewsFromJson(json);

  factory CollectionWithPreviews.empty() => CollectionWithPreviews(
        id: '',
        name: '',
        description: '',
        status: '',
        authorId: '',
        ebookCount: 0,
        coverPreviews: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

@freezed
abstract class CollectionsGridResponse with _$CollectionsGridResponse {
  const factory CollectionsGridResponse({
    required List<CollectionWithPreviews> items,
    required int total,
    required int page,
    required int size,
    required int pages,
  }) = _CollectionsGridResponse;

  factory CollectionsGridResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionsGridResponseFromJson(json);

  factory CollectionsGridResponse.empty() => const CollectionsGridResponse(
        items: [],
        total: 0,
        page: 1,
        size: 20,
        pages: 0,
      );
}
