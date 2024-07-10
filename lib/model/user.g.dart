// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      image_id: json['image_id'] as String?,
      role_id: (json['role_id'] as num?)?.toInt(),
      email_verified_at: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      no_of_hikes: (json['no_of_hikes'] as num?)?.toInt(),
      total_distance_walked: (json['total_distance_walked'] as num?)?.toInt(),
      no_of_steps_taken: (json['no_of_steps_taken'] as num?)?.toInt(),
      followers_count: (json['followers_count'] as num?)?.toInt(),
      following_count: (json['following_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'image_id': instance.image_id,
      'role_id': instance.role_id,
      'email_verified_at': instance.email_verified_at?.toIso8601String(),
      'no_of_steps_taken': instance.no_of_steps_taken,
      'total_distance_walked': instance.total_distance_walked,
      'no_of_hikes': instance.no_of_hikes,
      'followers_count': instance.followers_count,
      'following_count': instance.following_count,
    };
