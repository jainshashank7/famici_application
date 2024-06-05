import 'dart:io';

import 'package:flutter/material.dart';
import 'package:famici/utils/barrel.dart';

enum StorageType { asset, local, network }

StorageType storageType(String path) {
  if (path.contains('http://') || path.contains('https://')) {
    return StorageType.network;
  } else if (path.contains('assets/')) {
    return StorageType.asset;
  } else {
    return StorageType.local;
  }
}

ImageProvider getImageProvider(String? url) {
  StorageType _type = storageType(url ?? '');
  if (_type == StorageType.local) {
    return FileImage(File(url!));
  } else if (_type == StorageType.network) {
    return NetworkImage(
      url!,
    );
  } else if (_type == StorageType.asset) {
    return AssetImage(
      FCDefaultImage.userProfile,
    );
  } else {
    return AssetImage(
      AssetImagePath.welcomeImage,
    );
  }
}

bool isNull(dynamic object) {
  return object == null;
}
