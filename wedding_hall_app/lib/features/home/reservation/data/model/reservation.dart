import 'package:json_annotation/json_annotation.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_service.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_services_item.dart';
import 'package:wedding_hall_app/features/home/reservation/domain/enums/reservation_status.dart';
part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  final int id;
  final ReservationStatus status;
  @JsonKey(name: "hall_id")
  final int hallId;
  @JsonKey(name: "guest_count")
  final int guestCount;
  @JsonKey(name: "event_date")
  final DateTime eventDate;
  @JsonKey(name: "event_time")
  final String eventTime;
  @JsonKey(name: "hall_name")
  final String hallName;
  final List<HallServicesItem> services;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Reservation({
    required this.id,
    required this.status,
    required this.hallId,
    required this.guestCount,
    required this.eventDate,
    required this.eventTime,
    required this.hallName,
    required this.services,
  });
}
