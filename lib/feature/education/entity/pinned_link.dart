// class PinnedLink {
//   final String link;
//   final String title;
//   final String icon;
//   final bool isPinned;
//   final bool isLocalLink;
//
//   PinnedLink({
//     required this.link,
//     required this.title,
//     required this.icon,
//     required this.isPinned,
//     required this.isLocalLink,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'link': link,
//       'title': title,
//       'icon': icon,
//       'isPinned': isPinned,
//       'isLocalLink': isLocalLink,
//     };
//   }
//
//   factory PinnedLink.fromJson(Map<String, dynamic> json) {
//     return PinnedLink(
//       link: json['link'],
//       title: json['title'],
//       icon: json['icon'],
//       isPinned: json['isPinned'],
//       isLocalLink: json['isLocalLink'],
//     );
//   }
// }
