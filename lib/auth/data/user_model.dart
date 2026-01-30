import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class AppUser {
  final String uid;
  final String email;
  final String role;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json)
      => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}