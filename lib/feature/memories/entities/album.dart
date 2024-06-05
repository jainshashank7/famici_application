import 'package:equatable/equatable.dart';
import 'package:famici/feature/memories/entities/family_memory.dart';

class Album extends Equatable {
  final String? albumId;
  final String? title;
  final bool isSelected;
  final List<FamilyMemory> memories;

  const Album({
    this.albumId,
    this.title,
    bool? isSelected,
    List<FamilyMemory>? memories,
  })  : isSelected = isSelected ?? false,
        memories = memories ?? const [];

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumId: json['albumId'],
        title: json['title'],
        memories: (json['memories']['items'] as List)
            .map((n) => (FamilyMemory.fromJson(n)))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['title'] = title;
    data['memories'] = memories.map((e) => e.toJson()).toList();
    return data;
  }

  Album copyWith({
    String? albumId,
    String? title,
    bool? isSelected,
    List<FamilyMemory>? memories,
  }) {
    return Album(
        albumId: albumId ?? this.albumId,
        title: title ?? this.title,
        isSelected: isSelected ?? this.isSelected,
        memories: memories ?? this.memories);
  }

  @override
  List<Object?> get props => [
        albumId,
        title,
        isSelected,
        memories,
      ];
}
