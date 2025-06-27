import 'package:wedding_hall_app/features/home/halls/data/models/hall_availability_request_body.dart';
import 'package:wedding_hall_app/features/home/halls/domain/entity/hall_services_availability.dart';

import '../../../../../config/networking/api_error_handler.dart';
import '../../../../../config/networking/api_result.dart';
import '../../../../../config/networking/api_service.dart';
import '../models/hall.dart';

class HallsRepo {
  final ApiService _apiService;

  HallsRepo(this._apiService);

  Future<Result<List<Hall>>> allHalls() async {
    try {
      final response = await _apiService.allHalls();
      return Success(response);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<List<Hall>>> trendHalls() async {
    try {
      final response = await _apiService.trendingHalls();
      return Success(response);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<List<Hall>>> topHalls() async {
    try {
      final response = await _apiService.topHalls();
      return Success(response);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<HallServicesAvailability>> hallReservationRequriments(Hall hall) async {
    try {
      final hallServices = await _apiService.hallService(hall.id);
      final hallAvailability = await _apiService.hallAvailability(
        HallAvailabilityRequestBody(hallId: hall.id),
      );
      return Success(
        HallServicesAvailability(
          availability: hallAvailability,
          hall: hall,
          hallServices: hallServices.services,
        ),
      );
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
