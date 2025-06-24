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
abstract class Ebook with _$Ebook {
  const factory Ebook({
    required String id,
    required String title,
    @JsonKey(name: 'page_count') int? pageCount,
    required String status,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'file_path') String? filePath,
    @JsonKey(name: 'cover_image_path') String? coverImagePath,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'download_count') required int downloadCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Ebook;

  factory Ebook.fromJson(Map<String, dynamic> json) => _$EbookFromJson(json);

  factory Ebook.empty() => Ebook(
        id: '',
        title: '',
        pageCount: null,
        status: '',
        authorId: '',
        filePath: null,
        coverImagePath: null,
        fileSize: null,
        downloadCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

@freezed
abstract class EbookWithAuthor with _$EbookWithAuthor {
  const factory EbookWithAuthor({
    required String id,
    required String title,
    @JsonKey(name: 'page_count') int? pageCount,
    required String status,
    @JsonKey(name: 'file_path') String? filePath,
    @JsonKey(name: 'cover_image_path') String? coverImagePath,
    @JsonKey(name: 'file_size') int? fileSize,
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
        pageCount: null,
        status: '',
        filePath: null,
        coverImagePath: null,
        fileSize: null,
        downloadCount: 0,
        createdAt: '',
        updatedAt: '',
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

enum PrivacyStatus {
  private,
  public,
  inviteOnly,
}

@freezed
abstract class UploadUrlRequest with _$UploadUrlRequest {
  const factory UploadUrlRequest({
    @JsonKey(name: 'file_extension') required String fileExtension,
    @JsonKey(name: 'collection_id') String? collectionId,
  }) = _UploadUrlRequest;

  factory UploadUrlRequest.fromJson(Map<String, dynamic> json) =>
      _$UploadUrlRequestFromJson(json);

  factory UploadUrlRequest.empty() => const UploadUrlRequest(
        fileExtension: '',
        collectionId: null,
      );
}

@freezed
abstract class UploadUrlResponse with _$UploadUrlResponse {
  const factory UploadUrlResponse({
    @JsonKey(name: 'signed_url') required String signedUrl,
    @JsonKey(name: 'file_path') required String filePath,
    required String bucket,
    @JsonKey(name: 'expires_in') required int expiresIn,
    String? token,
  }) = _UploadUrlResponse;

  factory UploadUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadUrlResponseFromJson(json);

  factory UploadUrlResponse.empty() => const UploadUrlResponse(
        signedUrl: '',
        filePath: '',
        bucket: '',
        expiresIn: 0,
        token: null,
      );
}

@freezed
abstract class ConfirmUploadRequest with _$ConfirmUploadRequest {
  const factory ConfirmUploadRequest({
    @JsonKey(name: 'file_path') required String filePath,
    required String bucket,
    @JsonKey(name: 'ebook_id') required String ebookId,
  }) = _ConfirmUploadRequest;

  factory ConfirmUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmUploadRequestFromJson(json);

  factory ConfirmUploadRequest.empty() => const ConfirmUploadRequest(
        filePath: '',
        bucket: '',
        ebookId: '',
      );
}

@freezed
abstract class ConfirmUploadResponse with _$ConfirmUploadResponse {
  const factory ConfirmUploadResponse({
    required bool confirmed,
    @JsonKey(name: 'file_path') required String filePath,
    required String bucket,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'last_modified') required String lastModified,
  }) = _ConfirmUploadResponse;

  factory ConfirmUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmUploadResponseFromJson(json);

  factory ConfirmUploadResponse.empty() => const ConfirmUploadResponse(
        confirmed: false,
        filePath: '',
        bucket: '',
        fileSize: 0,
        contentType: '',
        lastModified: '',
      );
}
