import 'package:json_annotation/json_annotation.dart';
part 'hall_services_item.g.dart';


// this is the model of returning a service from reservation while creating a reservation it's HallService
@JsonSerializable()
class HallServicesItem {
  final int id;
  final String name;
  @JsonKey(name: "price_at_booking")
  final String servicePrice;

  const HallServicesItem({
    required this.id,
    required this.name,
    required this.servicePrice,
  });

  factory HallServicesItem.fromJson(Map<String, dynamic> json) =>
      _$HallServicesItemFromJson(json);
}
