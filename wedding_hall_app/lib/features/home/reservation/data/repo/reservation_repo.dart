
import '../../../../../config/networking/api_error_handler.dart';
import '../../../../../config/networking/api_result.dart';
import '../../../../../config/networking/api_service.dart';
import '../model/make_reservation_request_body.dart';
import '../model/reservation.dart';

class ReservationRepo {
  final ApiService _apiService;

  ReservationRepo(this._apiService);

  Future<Result<List<Reservation>>> userReservation() async {
    try {
      final data = await _apiService.userReservations();
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
  
  Future<Result> makeReservation(MakeReservationRequestBody makeReservationRequestBody) async {
    try {
      final data = await _apiService.makeReservation(makeReservationRequestBody);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
