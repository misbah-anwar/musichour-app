// models/family.dart
class Family {
  final int id;
  final String familyName;
  final String musicHour;

  Family({
    required this.id,
    required this.familyName,
    required this.musicHour,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['family_id'],
      familyName: json['family_name'],
      musicHour: json['music_hour'],
    );
  }
}
