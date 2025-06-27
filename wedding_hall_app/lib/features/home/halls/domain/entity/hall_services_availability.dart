import 'package:wedding_hall_app/features/home/halls/domain/enums/pricing_type.dart';

import '../../data/models/hall.dart';
import '../../data/models/hall_service.dart';

class HallServicesAvailability {
  final Hall hall;
  final Map<String, bool> availability;
  final List<HallService> hallServices;

  late final Map<DateTime, bool> parsedAvailability;
  late final DateTime lastDate;

  HallServicesAvailability({
    required this.hall,
    required this.availability,
    required this.hallServices,
  }) {
    lastDate = DateTime.parse(availability.keys.last);
    parsedAvailability = handleAvailability(availability);
  }

  Map<DateTime, bool> handleAvailability(Map<String, bool> map) {
    Map<DateTime, bool> result = {};
    for (var entry in map.entries) {
      try {
        DateTime date = DateTime.parse(entry.key);
        result[date] = entry.value;
      } catch (e) {
        print("Invalid date format: ${entry.key}");
      }
    }
    return result;
  }

  double calculatePrice(List<HallService> hallServices, int guestsCount) {
    double finalPrice = 0.0;
    for (HallService hallService in hallServices) {
      switch (hallService.pricingType) {
        case PricingType.static:
          finalPrice += double.parse(hallService.price);
        case PricingType.invitation_based:
          finalPrice += double.parse(hallService.price) * guestsCount;
      }
    }
    return finalPrice;
  }
}
