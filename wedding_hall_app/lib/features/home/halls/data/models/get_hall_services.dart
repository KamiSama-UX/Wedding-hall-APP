import 'package:json_annotation/json_annotation.dart';

import 'hall_service.dart';

part 'get_hall_services.g.dart';

@JsonSerializable()
class GetHallServices {
  final List<HallService> services;

  GetHallServices({required this.services});

  factory GetHallServices.fromJson(Map<String, dynamic> json) =>
      _$GetHallServicesFromJson(json);
}
