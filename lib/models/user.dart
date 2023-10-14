// models/user.dart
class User {
  final int id;
  final String familyName;
  final String adminName;
  final String email;
  final String passcode;

  User({
    required this.id,
    required this.familyName,
    required this.adminName,
    required this.email,
    required this.passcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['family_id'],
      familyName: json['family_name'],
      adminName: json['admin_name'],
      email: json['email'],
      passcode: json['passcode'],
    );
  }
}
