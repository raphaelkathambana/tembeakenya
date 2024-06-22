import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class User {
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? password;
  String? roleNo;
  DateTime? emailVerifiedAt;

  User({
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.password,
    this.roleNo,
    this.emailVerifiedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstname $lastname';

  bool get isVerified => emailVerifiedAt != null;
}
