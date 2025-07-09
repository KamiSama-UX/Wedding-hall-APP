import 'package:json_annotation/json_annotation.dart';
part 'success_response.g.dart';

@JsonSerializable()
class SuccessResponse {
  final bool status;
  final int statusCode;
  SuccessResponse(this.status, this.statusCode);

  factory SuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseFromJson(json);
}
