class EducationFeed {
  final String title;
  final String description;
  final int id;
  final bool isLiked;
  final String image;

  EducationFeed({
    required this.title,
    required this.description,
    required this.id,
    required this.image,
    required this.isLiked,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'image': image,
      'isLiked': isLiked,
    };
  }

  factory EducationFeed.fromJson(Map<String, dynamic> json) {
    return EducationFeed(
      title: json['title'],
      description: json['description'],
      id: json['id'],
      image: json['image'],
      isLiked: json['isLiked'],
    );
  }
}
