// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String username;
  String fullname;
  String email;
  String birthdate;
  String phone;
  String password;
  
  User({
    required this.username,
    required this.fullname,
    required this.email,
    required this.birthdate,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
