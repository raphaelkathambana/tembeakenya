import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class User {
  String? _firstName;

  String? get firstName => _firstName;

  set firstName(String? value) {
    _firstName = value;
  }

  String? _lastName;

  String? get lastName => _lastName;

  set lastName(String? value) {
    _lastName = value;
  }

  String? _username;

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? _email;

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? password;
  String? roleNo;
  DateTime? emailVerifiedAt;

  User({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    this.password,
    this.roleNo,
    this.emailVerifiedAt,
  })  : _email = email,
        _username = username,
        _lastName = lastName,
        _firstName = firstName;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstName $lastName';

  bool get isVerified => emailVerifiedAt != null;
}
