import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(createToJson: false)
class LoginResponse {
  @JsonKey(name: "user")
  final UserData? userData;
  final String token;

  LoginResponse({
    required this.userData,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class UserData {
  final int id;
  final String name;
  final String email;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  UserData({required this.id, required this.name, required this.email});
}
