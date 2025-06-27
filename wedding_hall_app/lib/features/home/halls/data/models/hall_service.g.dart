// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HallService _$HallServiceFromJson(Map<String, dynamic> json) => HallService(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  price: json['price_per_person'] as String,
  pricingType: $enumDecode(_$PricingTypeEnumMap, json['pricing_type']),
);

Map<String, dynamic> _$HallServiceToJson(HallService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_per_person': instance.price,
      'pricing_type': _$PricingTypeEnumMap[instance.pricingType]!,
    };

const _$PricingTypeEnumMap = {
  PricingType.invitation_based: 'invitation_based',
  PricingType.static: 'static',
};
