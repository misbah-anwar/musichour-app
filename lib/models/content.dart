// models/content.dart
class Content {
  final String familyName;
  final String youtubeLink;

  Content({
    required this.familyName,
    required this.youtubeLink,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      familyName: json['family_name'],
      youtubeLink: json['music_url'],
    );
  }
}
