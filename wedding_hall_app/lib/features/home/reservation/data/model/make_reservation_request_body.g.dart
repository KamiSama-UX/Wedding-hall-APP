// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'make_reservation_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakeReservationRequestBody _$MakeReservationRequestBodyFromJson(
  Map<String, dynamic> json,
) => MakeReservationRequestBody(
  hallId: (json['hall_id'] as num).toInt(),
  guestCount: (json['guest_count'] as num).toInt(),
  eventDate: json['event_date'] as String,
  evenTime: json['event_time'] as String,
  serviceIds:
      (json['service_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
);

Map<String, dynamic> _$MakeReservationRequestBodyToJson(
  MakeReservationRequestBody instance,
) => <String, dynamic>{
  'hall_id': instance.hallId,
  'guest_count': instance.guestCount,
  'event_date': instance.eventDate,
  'event_time': instance.evenTime,
  'service_ids': instance.serviceIds,
};
