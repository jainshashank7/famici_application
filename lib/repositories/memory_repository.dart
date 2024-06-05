import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/enitity/media.dart';
import 'package:famici/core/enitity/memory.dart';
import 'package:famici/core/enitity/upload_status.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:http/http.dart' as http;

import 'amplify_service.dart';


class MemoryRepository {
  static final MemoryRepository _singleton = MemoryRepository._internal();
  factory MemoryRepository() {
    return _singleton;
  }
  MemoryRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<Memory?> getMediaUploadURL(String familyId) async {
    String graphQLDocument = '''mutation UploadMedia (\$familyId: ID!) {
            uploadMedia (familyId:\$familyId, type: Memory, mediaCount: 1) {
                contactId
                createdAt
                familyId
                mediaCount
                media{
                  key
                  mediaId
                  uploadUrl
                }
                type
                uploadId
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return Memory.fromJson(
        jsonDecode(response.data)['uploadMedia'],
      );
    }
  }

  Future<UploadStatus> uploadPicture({
    required String imageUrl,
    required String uploadUrl,
  }) async {
    try {

      File image = File(imageUrl);
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Content-Type': lookupMimeType(imageUrl) ?? 'image/*',
          'Accept': "*/*",
          'Content-Length': image.lengthSync().toString(),
          'Connection': 'keep-alive',
        },
        body: image.readAsBytesSync(),
      );
      if (response.statusCode == 200) {
        return UploadStatus(status: Status.success, progress: 100);
      } else {
        return UploadStatus(status: Status.failure, progress: 50);
      }
    } catch (err) {
      _crashlytics.recordError(
        err,
        StackTrace.fromString(imageUrl),
        reason: [imageUrl, uploadUrl],
      );
      return UploadStatus(status: Status.failure, progress: 0);
    }
  }

  Future<MediaUploadStatus?> setUploadStatus(
    String mediaId,
    String uploadId,
  ) async {
    String graphQLDocument =
        '''mutation SetUploadStatus (\$uploadId: ID!,\$mediaIds: ID!) {
            setUploadStatus (uploadId:\$uploadId, mediaIds: \$mediaIds) {
               memory {
                  bucket
                  key
                  mediaId
                  url
               }
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"uploadId": uploadId, "mediaIds": mediaId},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return MediaUploadStatus.fromJson(
        jsonDecode(response.data)['setUploadStatus'][0],
      );
    }
  }

  Future<List<FamilyMemory>> fetchMemories({required String familyId}) async {
    String graphQLDocument = '''query GetMemories(\$familyId:ID!) {
      getMemories(familyId:\$familyId) {
        items {
          bucket
          contactId
          createdAt
          familyId
          key
          mediaId
          url
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
      return [];
    } else {
      List<FamilyMemory> memories = json
          .decode(response.data)['getMemories']['items']
          .map<FamilyMemory>((data) => FamilyMemory.fromJson(data))
          .toList();
      return memories;
    }
  }

  Future<bool> deleteMemory(
    List<String?> mediaIds,
    String contactId,
  ) async {
    String graphQLDocument =
        '''mutation DeleteMemories (\$contactId: ID!,\$mediaIds: [ID!]!) {
            deleteMemories (contactId:\$contactId, mediaIds: \$mediaIds)
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"contactId": contactId, "mediaIds": mediaIds},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> moveMemory(
    List<String?> mediaIds,
    String albumId,
  ) async {
    String graphQLDocument =
        '''mutation AddMediaToAlbum (\$albumId: ID!,\$mediaIds: [ID!]!) {
            addMediaToAlbum (albumId:\$albumId, mediaIds: \$mediaIds){
            albumId
            }
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"albumId": albumId, "mediaIds": mediaIds},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> shareMemories({
    List<String>? memoryIds,
    List<String>? contactIds,
    String? familyId,
  }) async {
    String graphQLDocument =
        '''mutation ShareMemories (\$contactIds: [ID],\$mediaIds: [ID]!,\$familyId: ID!) {
            shareMemories (contactIds:\$contactIds, mediaIds: \$mediaIds,familyId: \$familyId){
              type
              title
              status
              senderPicture
              senderName
              senderContactId
              notificationId
              familyId
              description
              data
              createdAt
            }
        }''';


    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "contactIds": null,
        "mediaIds": memoryIds,
        "familyId": familyId
      },
      apiName: AmplifyApiName.defaultApi,
    );
    return response.errors.isEmpty;
  }

  Future<bool> requestPhotos({
    List<String>? contactIds = const [],
    String? note = '',
    String? familyId = '',
  }) async {
    String graphQLDocument =
        '''mutation RequestMemories(\$contactIds: [ID!]!,\$note: String,\$familyId: ID!) {
            requestMemories (contactIds:\$contactIds, note: \$note,familyId: \$familyId)
        }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {"contactIds": contactIds, "note": note, "familyId": familyId},
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      throw response.errors.first;
    } else {
      return true;
    }
  }
}
