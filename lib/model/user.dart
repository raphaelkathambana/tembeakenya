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

  String? _image_id;

  String? get image_id => _image_id;

  set profileImageId(String? value) {
    _image_id = value;
  }

  String? roleNo;
  DateTime? email_verified_at;

  User({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? image_id,
    this.roleNo,
    this.email_verified_at,
  })  : _email = email,
        _username = username,
        _lastName = lastName,
        _image_id = image_id,
        _firstName = firstName;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstName $lastName';

  bool get isVerified => email_verified_at != null;
}
