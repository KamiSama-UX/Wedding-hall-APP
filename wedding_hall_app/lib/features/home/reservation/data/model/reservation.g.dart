// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
  id: (json['id'] as num).toInt(),
  status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
  hallId: (json['hall_id'] as num).toInt(),
  guestCount: (json['guest_count'] as num).toInt(),
  eventDate: DateTime.parse(json['event_date'] as String),
  eventTime: json['event_time'] as String,
  hallName: json['hall_name'] as String,
  services:
      (json['services'] as List<dynamic>)
          .map((e) => HallServicesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'hall_id': instance.hallId,
      'guest_count': instance.guestCount,
      'event_date': instance.eventDate.toIso8601String(),
      'event_time': instance.eventTime,
      'hall_name': instance.hallName,
      'services': instance.services,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.declined: 'declined',
  ReservationStatus.pending: 'pending',
  ReservationStatus.canceled: 'canceled',
};
