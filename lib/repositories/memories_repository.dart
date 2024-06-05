import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/memories/entities/album.dart';
import 'package:famici/feature/memories/entities/family_memory.dart';

import '../utils/helpers/amplify_helper.dart';
import 'amplify_service.dart';

class MemoriesRepository {
  static final MemoriesRepository _singleton = MemoriesRepository._internal();

  factory MemoriesRepository() {
    return _singleton;
  }

  MemoriesRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();

  List<Album> albums = [];

  Future<List<FamilyMemory>> fetchMemories({
    int offset = 0,
  }) async {
    return List<FamilyMemory>.empty();
  }

  Future<List<Album>?> fetchAlbums({required String familyId}) async {
    String graphQLDocument = '''query GetAlbums(\$familyId:ID!) {
      getAlbums(familyId:\$familyId, limit: 100) {
        items {
          albumId
          title
          memories(limit: 100) {
            items {
              url
              mediaId
              contactId
            }
            nextToken
          }
        }
        nextToken
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      albums = (json.decode(response.data)['getAlbums']['items'] as List)
          .map((n) => (Album.fromJson(n)))
          .toList();
      return albums;
    }
  }

  Future<Album?> saveAlbum({
    required String title,
    required List<String?> mediaIds,
    required String familyId,
  }) async {
    String graphQLDocument =
        '''mutation CreateAlbum(\$familyId:ID!,\$mediaIds: [ID!]!,\$title:String!) {
      createAlbum(familyId:\$familyId,album: {mediaIds: \$mediaIds, title: \$title}) {
          albumId
          title
          createdAt
          memories(limit: 100) {
            items {
              contactId
              mediaId
              url
            }
            nextToken
          }
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"familyId": familyId, "mediaIds": mediaIds, "title": title},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      Album? savedAlbum = Album.fromJson(
        jsonDecode(response.data)['createAlbum'],
      );
      albums.add(savedAlbum);
      return savedAlbum;
    }
  }

  Future<bool> saveEditedAlbumTitle({
    required String title,
    required String albumId,
  }) async {
    String graphQLDocument =
        '''mutation UpdateAlbum(\$albumId:ID!,\$title:String!) {
      updateAlbum(albumId:\$albumId,album: {title: \$title}) {
          albumId
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"albumId": albumId, "title": title},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<Album?> getAlbum({required String albumId}) async {
    String graphQLDocument = '''query GetAlbum(\$albumId:ID!) {
      getAlbum(albumId:\$albumId) {
          albumId
          title
          memories(limit: 100) {
            items {
              contactId
              mediaId
              url
            }
          }
      }
    }''';

    GraphQLResponse response = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {"albumId": albumId},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      Album? getAlbum = Album.fromJson(
        jsonDecode(response.data)['getAlbum'],
      );
      return getAlbum;
    }
  }

  Future<bool> deleteAlbum(String? albumId, String contactId) async {
    String graphQLDocument =
        '''mutation DeleteAlbum (\$contactId: ID!,\$albumId: ID!) {
            deleteAlbum (contactId:\$contactId, albumId: \$albumId)
            {
            albumId
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"contactId": contactId, "albumId": albumId},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
