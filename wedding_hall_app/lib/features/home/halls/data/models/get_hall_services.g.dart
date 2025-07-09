// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_hall_services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetHallServices _$GetHallServicesFromJson(Map<String, dynamic> json) =>
    GetHallServices(
      services:
          (json['services'] as List<dynamic>)
              .map((e) => HallService.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$GetHallServicesToJson(GetHallServices instance) =>
    <String, dynamic>{'services': instance.services};
