import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/models.dart';

abstract class CollectionsRemoteDataSource {
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 10,
  });

  Future<CollectionWithEbooks> getCollectionWithEbooks(String collectionId);
}

class CollectionsRemoteDataSourceImpl implements CollectionsRemoteDataSource {
  final Dio dio;

  CollectionsRemoteDataSourceImpl(this.dio);

  @override
  Future<CollectionsResponse> getCollections({
    int page = 1,
    int size = 10,
  }) async {
    const mockResponse = '''
{
    "items": [
        {
            "id": "550e8400-e29b-41d4-a716-446655440001",
            "name": "Science Fiction Classics",
            "description": "A collection of timeless science fiction stories that shaped the genre.",
            "status": "public",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "created_at": "2024-01-15T10:30:00Z",
            "updated_at": "2024-02-20T14:45:00Z",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "550e8400-e29b-41d4-a716-446655440002",
            "name": "Mystery & Thriller Collection",
            "description": "Edge-of-your-seat stories that will keep you guessing until the very end.",
            "status": "private",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "created_at": "2024-02-01T16:20:00Z",
            "updated_at": "2024-02-25T11:30:00Z",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "550e8400-e29b-41d4-a716-446655440003",
            "name": "Historical Fiction Journey",
            "description": "Travel through time with these immersive historical narratives that bring the past to life.",
            "status": "invite_only",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "created_at": "2024-01-20T08:15:00Z",
            "updated_at": "2024-02-18T13:22:00Z",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "550e8400-e29b-41d4-a716-446655440004",
            "name": "Short Story Gems",
            "description": "Perfect bite-sized stories for your daily commute or lunch break.",
            "status": "public",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "created_at": "2024-02-10T12:45:00Z",
            "updated_at": "2024-02-28T09:17:00Z",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "550e8400-e29b-41d4-a716-446655440005",
            "name": "Romance & Drama",
            "description": null,
            "status": "private",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "created_at": "2024-02-05T14:30:00Z",
            "updated_at": "2024-02-15T16:45:00Z",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ],
    "total": 5,
    "page": 1,
    "size": 10,
    "pages": 1
}
''';

    final json = jsonDecode(mockResponse) as Map<String, dynamic>;
    return CollectionsResponse.fromJson(json);
  }

  @override
  Future<CollectionWithEbooks> getCollectionWithEbooks(
      String collectionId) async {
    String mockResponse;

    switch (collectionId) {
      case '550e8400-e29b-41d4-a716-446655440001':
        mockResponse = _getSciFiCollectionMock();
        break;
      case '550e8400-e29b-41d4-a716-446655440002':
        mockResponse = _getMysteryCollectionMock();
        break;
      case '550e8400-e29b-41d4-a716-446655440003':
        mockResponse = _getHistoricalCollectionMock();
        break;
      case '550e8400-e29b-41d4-a716-446655440004':
        mockResponse = _getShortStoriesCollectionMock();
        break;
      case '550e8400-e29b-41d4-a716-446655440005':
        mockResponse = _getRomanceCollectionMock();
        break;
      default:
        throw Exception('Collection not found');
    }

    final json = jsonDecode(mockResponse) as Map<String, dynamic>;
    return CollectionWithEbooks.fromJson(json);
  }

  String _getSciFiCollectionMock() {
    return '''
{
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "name": "Science Fiction Classics",
    "description": "A collection of timeless science fiction stories that shaped the genre.",
    "status": "public",
    "author_id": "550e8400-e29b-41d4-a716-446655440010",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-02-20T14:45:00Z",
    "author": {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "username": "elliotalderson",
        "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
        "created_at": "2023-12-01T09:00:00Z"
    },
    "ebooks": [
        {
            "id": "660e8400-e29b-41d4-a716-446655440001",
            "title": "Digital Dreams",
            "page_count": 342,
            "file_path": "/uploads/ebooks/digital-dreams.epub",
            "cover_image_path": "/uploads/covers/digital-dreams-cover.jpg",
            "file_size": 2458624,
            "status": "public",
            "download_count": 1247,
            "created_at": "2024-01-10T09:15:00Z",
            "updated_at": "2024-02-15T11:20:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440002",
            "title": "The Mars Expedition",
            "page_count": 278,
            "file_path": "/uploads/ebooks/mars-expedition.epub",
            "cover_image_path": "/uploads/covers/mars-expedition-cover.jpg",
            "file_size": 1876432,
            "status": "public",
            "download_count": 892,
            "created_at": "2024-01-05T14:30:00Z",
            "updated_at": "2024-02-10T16:45:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440003",
            "title": "Neural Networks",
            "page_count": 195,
            "file_path": "/uploads/ebooks/neural-networks.epub",
            "cover_image_path": "/uploads/covers/neural-networks-cover.jpg",
            "file_size": 1342567,
            "status": "public",
            "download_count": 654,
            "created_at": "2023-12-20T11:22:00Z",
            "updated_at": "2024-01-25T13:15:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440004",
            "title": "Quantum Leap",
            "page_count": 421,
            "file_path": "/uploads/ebooks/quantum-leap.epub",
            "cover_image_path": "/uploads/covers/quantum-leap-cover.jpg",
            "file_size": 3124789,
            "status": "public",
            "download_count": 1089,
            "created_at": "2023-11-15T16:40:00Z",
            "updated_at": "2024-01-30T10:25:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson", 
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ]
}
''';
  }

  String _getMysteryCollectionMock() {
    return '''
{
    "id": "550e8400-e29b-41d4-a716-446655440002",
    "name": "Mystery & Thriller Collection",
    "description": "Edge-of-your-seat stories that will keep you guessing until the very end.",
    "status": "private",
    "author_id": "550e8400-e29b-41d4-a716-446655440010",
    "created_at": "2024-02-01T16:20:00Z",
    "updated_at": "2024-02-25T11:30:00Z",
    "author": {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "username": "elliotalderson",
        "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
        "created_at": "2023-12-01T09:00:00Z"
    },
    "ebooks": [
        {
            "id": "660e8400-e29b-41d4-a716-446655440011",
            "title": "The Silent Witness",
            "page_count": 298,
            "file_path": "/uploads/ebooks/silent-witness.epub",
            "cover_image_path": "/uploads/covers/silent-witness-cover.jpg",
            "file_size": 2134567,
            "status": "private",
            "download_count": 432,
            "created_at": "2024-01-25T08:45:00Z",
            "updated_at": "2024-02-20T15:30:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440012",
            "title": "Blood on the Pages",
            "page_count": 387,
            "file_path": "/uploads/ebooks/blood-pages.epub",
            "cover_image_path": "/uploads/covers/blood-pages-cover.jpg",
            "file_size": 2876543,
            "status": "private",
            "download_count": 298,
            "created_at": "2024-02-03T12:20:00Z",
            "updated_at": "2024-02-22T09:15:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440013",
            "title": "Midnight Detective",
            "page_count": 256,
            "file_path": "/uploads/ebooks/midnight-detective.epub",
            "cover_image_path": "/uploads/covers/midnight-detective-cover.jpg",
            "file_size": 1923456,
            "status": "private",
            "download_count": 567,
            "created_at": "2024-01-18T19:30:00Z",
            "updated_at": "2024-02-18T14:22:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ]
}
''';
  }

  String _getHistoricalCollectionMock() {
    return '''
{
    "id": "550e8400-e29b-41d4-a716-446655440003",
    "name": "Historical Fiction Journey",
    "description": "Travel through time with these immersive historical narratives that bring the past to life.",
    "status": "invite_only",
    "author_id": "550e8400-e29b-41d4-a716-446655440010",
    "created_at": "2024-01-20T08:15:00Z",
    "updated_at": "2024-02-18T13:22:00Z",
    "author": {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "username": "elliotalderson",
        "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
        "created_at": "2023-12-01T09:00:00Z"
    },
    "ebooks": [
        {
            "id": "660e8400-e29b-41d4-a716-446655440021",
            "title": "Echoes of the Renaissance",
            "page_count": 456,
            "file_path": "/uploads/ebooks/echoes-renaissance.epub",
            "cover_image_path": "/uploads/covers/echoes-renaissance-cover.jpg",
            "file_size": 3245678,
            "status": "invite_only",
            "download_count": 234,
            "created_at": "2024-01-12T10:30:00Z",
            "updated_at": "2024-02-16T16:45:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440022",
            "title": "The Victorian Secret",
            "page_count": 389,
            "file_path": "/uploads/ebooks/victorian-secret.epub",
            "cover_image_path": "/uploads/covers/victorian-secret-cover.jpg",
            "file_size": 2789123,
            "status": "invite_only",
            "download_count": 178,
            "created_at": "2024-01-08T14:20:00Z",
            "updated_at": "2024-02-14T11:33:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440023",
            "title": "Medieval Shadows",
            "page_count": 312,
            "file_path": "/uploads/ebooks/medieval-shadows.epub",
            "cover_image_path": "/uploads/covers/medieval-shadows-cover.jpg",
            "file_size": 2156789,
            "status": "invite_only",
            "download_count": 145,
            "created_at": "2023-12-28T16:15:00Z",
            "updated_at": "2024-01-30T09:22:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440024",
            "title": "Letters from the Front",
            "page_count": 267,
            "file_path": "/uploads/ebooks/letters-front.epub",
            "cover_image_path": "/uploads/covers/letters-front-cover.jpg",
            "file_size": 1834567,
            "status": "invite_only",
            "download_count": 298,
            "created_at": "2024-01-15T11:45:00Z",
            "updated_at": "2024-02-12T14:18:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440025",
            "title": "Ancient Rome Chronicles",
            "page_count": 523,
            "file_path": "/uploads/ebooks/ancient-rome-chronicles.epub",
            "cover_image_path": "/uploads/covers/ancient-rome-chronicles-cover.jpg",
            "file_size": 3876543,
            "status": "invite_only",
            "download_count": 189,
            "created_at": "2023-12-05T13:30:00Z",
            "updated_at": "2024-02-08T17:25:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ]
}
''';
  }

  String _getShortStoriesCollectionMock() {
    return '''
{
    "id": "550e8400-e29b-41d4-a716-446655440004",
    "name": "Short Story Gems",
    "description": "Perfect bite-sized stories for your daily commute or lunch break.",
    "status": "public",
    "author_id": "550e8400-e29b-41d4-a716-446655440010",
    "created_at": "2024-02-10T12:45:00Z",
    "updated_at": "2024-02-28T09:17:00Z",
    "author": {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "username": "elliotalderson",
        "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
        "created_at": "2023-12-01T09:00:00Z"
    },
    "ebooks": [
        {
            "id": "660e8400-e29b-41d4-a716-446655440031",
            "title": "Coffee Shop Chronicles",
            "page_count": 89,
            "file_path": "/uploads/ebooks/coffee-shop-chronicles.epub",
            "cover_image_path": "/uploads/covers/coffee-shop-chronicles-cover.jpg",
            "file_size": 876543,
            "status": "public",
            "download_count": 1456,
            "created_at": "2024-02-05T09:30:00Z",
            "updated_at": "2024-02-25T14:22:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440032",
            "title": "Midnight Musings",
            "page_count": 67,
            "file_path": "/uploads/ebooks/midnight-musings.epub",
            "cover_image_path": "/uploads/covers/midnight-musings-cover.jpg",
            "file_size": 623456,
            "status": "public",
            "download_count": 987,
            "created_at": "2024-02-08T18:15:00Z",
            "updated_at": "2024-02-26T11:45:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440033",
            "title": "Urban Legends",
            "page_count": 124,
            "file_path": "/uploads/ebooks/urban-legends.epub",
            "cover_image_path": "/uploads/covers/urban-legends-cover.jpg",
            "file_size": 1123456,
            "status": "public",
            "download_count": 756,
            "created_at": "2024-01-28T13:20:00Z",
            "updated_at": "2024-02-20T16:30:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440034",
            "title": "Weekend Tales",
            "page_count": 98,
            "file_path": "/uploads/ebooks/weekend-tales.epub",
            "cover_image_path": "/uploads/covers/weekend-tales-cover.jpg",
            "file_size": 934567,
            "status": "public",
            "download_count": 1234,
            "created_at": "2024-02-12T10:45:00Z",
            "updated_at": "2024-02-27T15:18:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440035",
            "title": "Flash Fiction Anthology",
            "page_count": 156,
            "file_path": "/uploads/ebooks/flash-fiction-anthology.epub",
            "cover_image_path": "/uploads/covers/flash-fiction-anthology-cover.jpg",
            "file_size": 1456789,
            "status": "public",
            "download_count": 2103,
            "created_at": "2024-01-22T14:30:00Z",
            "updated_at": "2024-02-24T12:25:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440036",
            "title": "Lunch Break Stories",
            "page_count": 72,
            "file_path": "/uploads/ebooks/lunch-break-stories.epub",
            "cover_image_path": "/uploads/covers/lunch-break-stories-cover.jpg",
            "file_size": 678901,
            "status": "public",
            "download_count": 834,
            "created_at": "2024-02-15T16:20:00Z",
            "updated_at": "2024-02-28T08:40:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ]
}
''';
  }

  String _getRomanceCollectionMock() {
    return '''
{
    "id": "550e8400-e29b-41d4-a716-446655440005",
    "name": "Romance & Drama",
    "description": null,
    "status": "private",
    "author_id": "550e8400-e29b-41d4-a716-446655440010",
    "created_at": "2024-02-05T14:30:00Z",
    "updated_at": "2024-02-15T16:45:00Z",
    "author": {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "username": "elliotalderson",
        "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
        "created_at": "2023-12-01T09:00:00Z"
    },
    "ebooks": [
        {
            "id": "660e8400-e29b-41d4-a716-446655440041",
            "title": "Hearts in the City",
            "page_count": 324,
            "file_path": "/uploads/ebooks/hearts-in-city.epub",
            "cover_image_path": "/uploads/covers/hearts-in-city-cover.jpg",
            "file_size": 2234567,
            "status": "private",
            "download_count": 123,
            "created_at": "2024-01-30T11:15:00Z",
            "updated_at": "2024-02-12T09:30:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        },
        {
            "id": "660e8400-e29b-41d4-a716-446655440042",
            "title": "Summer Love Affair",
            "page_count": 267,
            "file_path": "/uploads/ebooks/summer-love-affair.epub",
            "cover_image_path": "/uploads/covers/summer-love-affair-cover.jpg",
            "file_size": 1876543,
            "status": "private",
            "download_count": 89,
            "created_at": "2024-02-02T15:45:00Z",
            "updated_at": "2024-02-14T13:20:00Z",
            "author_id": "550e8400-e29b-41d4-a716-446655440010",
            "author": {
                "id": "550e8400-e29b-41d4-a716-446655440010",
                "username": "elliotalderson",
                "avatar_url": "https://example.com/avatars/sci_fi_lover.jpg",
                "created_at": "2023-12-01T09:00:00Z"
            }
        }
    ]
}
''';
  }
}
