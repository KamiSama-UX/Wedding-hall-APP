import 'package:json_annotation/json_annotation.dart';

import '../../domain/enums/pricing_type.dart';

part 'hall_service.g.dart';

// this is the model of returning a service from reservation, while creating a reservation it's HallService
@JsonSerializable()
class HallService {
  final int id;
  final String name;
  @JsonKey(name: "price_per_person")
  final String price;
  @JsonKey(name: "pricing_type")
  final PricingType pricingType;

  const HallService({
    required this.id,
    required this.name,
    required this.price,
    required this.pricingType,
  });

  factory HallService.fromJson(Map<String, dynamic> json) =>
      _$HallServiceFromJson(json);
}
