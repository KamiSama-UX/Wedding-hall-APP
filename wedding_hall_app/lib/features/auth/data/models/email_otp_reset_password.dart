import 'package:json_annotation/json_annotation.dart';

part 'email_otp_reset_password.g.dart';
@JsonSerializable()
class EmailOtpResetPassword {
  final String email;

  EmailOtpResetPassword(this.email);

  Map<String, dynamic> toJson() => _$EmailOtpResetPasswordToJson(this);
}
