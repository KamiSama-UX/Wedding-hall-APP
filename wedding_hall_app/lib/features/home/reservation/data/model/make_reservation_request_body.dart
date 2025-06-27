import 'package:json_annotation/json_annotation.dart';
part 'make_reservation_request_body.g.dart';
@JsonSerializable()
class MakeReservationRequestBody {
  MakeReservationRequestBody({
    required this.hallId,
    required this.guestCount,
    required this.eventDate,
    required this.evenTime,
    required this.serviceIds,
  });

  @JsonKey(name: "hall_id")
  final int hallId;

  @JsonKey(name: "guest_count")
  final int guestCount;

  @JsonKey(name: "event_date")
  final String eventDate;

  @JsonKey(name: "event_time")
  final String evenTime;

  @JsonKey(name: "service_ids")
  final List<int> serviceIds;

  Map<String, dynamic> toJson() => _$MakeReservationRequestBodyToJson(this);

  factory MakeReservationRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MakeReservationRequestBodyFromJson(json);
}
