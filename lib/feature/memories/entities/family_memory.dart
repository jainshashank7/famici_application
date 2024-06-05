import 'package:equatable/equatable.dart';
import 'package:famici/core/enitity/barrel.dart';

class FamilyMemory extends Equatable {
  final String? mediaId;
  final String? url;
  final String? contactId;
  final bool isSelected;
  final MemoryType type;
  final String key;

  const FamilyMemory({
    this.mediaId,
    this.contactId,
    this.url,
    this.key = '',
    bool? isSelected,
    MemoryType? type,
  })  : isSelected = isSelected ?? false,
        type = type ?? MemoryType.photo;

  factory FamilyMemory.fromJson(Map<String, dynamic> json) {
    return FamilyMemory(
      mediaId: json['mediaId'] ?? '',
      url: json['url'] ?? '',
      contactId: json['contactId'] ?? '',
      key: json['key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaId'] = mediaId;
    data['url'] = url;
    data['contactId'] = contactId;
    return data;
  }

  @override
  List<Object?> get props => [mediaId, url, contactId, isSelected];

  FamilyMemory copyWith({
    String? mediaId,
    String? url,
    String? contactId,
    bool? isSelected,
    MemoryType? type,
    String? key,
  }) {
    return FamilyMemory(
      mediaId: mediaId ?? this.mediaId,
      url: url ?? this.url,
      contactId: contactId ?? this.contactId,
      isSelected: isSelected ?? this.isSelected,
      type: type ?? this.type,
      key: key ?? this.key,
    );
  }

  Picture toPicture() {
    return Picture(key: key, url: url ?? '');
  }
}

enum MemoryType { photo, video }
