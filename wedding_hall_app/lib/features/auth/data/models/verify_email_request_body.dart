import 'package:json_annotation/json_annotation.dart';


part 'verify_email_request_body.g.dart';
@JsonSerializable()
class VerifyEmailRequestBody {
  final String email;
  @JsonKey(name: "verification_code")
  final String code;

  VerifyEmailRequestBody({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => _$VerifyEmailRequestBodyToJson(this);
}
