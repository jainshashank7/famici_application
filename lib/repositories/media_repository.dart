import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mime/mime.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/enitity/upload_status.dart';
import 'package:famici/utils/barrel.dart';
import 'package:http/http.dart' as http;

import 'amplify_service.dart';

class MediaRepository {
  static final MediaRepository _singleton = MediaRepository._internal();
  factory MediaRepository() {
    return _singleton;
  }
  MediaRepository._internal();

  final AmplifyService _amplifyAPI = AmplifyService();
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<Picture?> getProfilePicUploadURL(
    String contactId,
    String familyId,
  ) async {
    String graphQLDocument = '''
      mutation UpdateContactPicture (\$contactId: ID!,\$familyId: ID!){
        updateContactPicture(contactId: \$contactId, familyId: \$familyId) {
          bucket
          key
          region
          uploadUrl
          url
        }
      }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "contactId": contactId,
        "familyId": familyId,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return Picture.fromJson(
        jsonDecode(response.data)['updateContactPicture'],
      );
    }
  }

  Future<Picture?> updateContactPictureByKey(
    String? contactId,
    String? familyId,
    String? key,
  ) async {
    String graphQLDocument = '''
      mutation UpdateContactPicture (\$contactId: ID!,\$familyId: ID!,\$key:String){
        updateContactPicture(contactId: \$contactId, familyId: \$familyId,key:\$key) {
          bucket
          key
          region
          url
        }
      }''';

    GraphQLResponse response = await _amplifyAPI.mutate(
      document: graphQLDocument,
      variables: {
        "contactId": contactId,
        "familyId": familyId,
        "key": key,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (response.errors.isNotEmpty) {
      return null;
    } else {
      return Picture.fromJson(
        jsonDecode(response.data)['updateContactPicture'],
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

  Future<UploadStatus> uploadAudio({
    required String audioUrl,
    required String uploadUrl,
  }) async {
    try {
      File image = File(audioUrl);
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Content-Type': lookupMimeType(audioUrl) ?? 'audio/*',
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
        StackTrace.fromString(audioUrl),
        reason: [audioUrl, uploadUrl],
      );
      return UploadStatus(status: Status.failure, progress: 0);
    }
  }

  Future<UploadStatus> uploadPictureToSend({
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
}
