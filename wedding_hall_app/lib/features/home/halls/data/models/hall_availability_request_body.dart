import 'package:json_annotation/json_annotation.dart';

part 'hall_availability_request_body.g.dart';

@JsonSerializable()
class HallAvailabilityRequestBody {
  @JsonKey(name: "hall_id")
  final int hallId;

  HallAvailabilityRequestBody({
    required this.hallId,
  });

  Map<String, dynamic> toJson() => _$HallAvailabilityRequestBodyToJson(this);
}
