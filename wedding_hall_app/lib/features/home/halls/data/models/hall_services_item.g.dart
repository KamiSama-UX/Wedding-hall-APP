// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_services_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HallServicesItem _$HallServicesItemFromJson(Map<String, dynamic> json) =>
    HallServicesItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      servicePrice: json['price_at_booking'] as String,
    );

Map<String, dynamic> _$HallServicesItemToJson(HallServicesItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_at_booking': instance.servicePrice,
    };
