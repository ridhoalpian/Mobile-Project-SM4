// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      birthdate: json['birthdate'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'fullname': instance.fullname,
      'email': instance.email,
      'birthdate': instance.birthdate,
      'phone': instance.phone,
      'password': instance.password,
    };
