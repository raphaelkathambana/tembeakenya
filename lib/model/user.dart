import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class User {
  int? _id;

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

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

  int? _roleNo;

  int? get roleNo => _roleNo;

  set roleNo(int? value) {
    _roleNo = value;
  }

  DateTime? email_verified_at;

  int? no_of_steps_taken;
  int? total_distance_walked;
  int? no_of_hikes;
  int? followers_count;
  int? following_count;

  User({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? image_id,
    int? roleNo,
    this.email_verified_at,
    this.no_of_hikes,
    this.total_distance_walked,
    this.no_of_steps_taken,
    this.followers_count,
    this.following_count,
  })  : _roleNo = roleNo,
        _email = email,
        _username = username,
        _lastName = lastName,
        _image_id = image_id,
        _id = id,
        _firstName = firstName;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstName $lastName';

  bool get isVerified => email_verified_at != null;
}
