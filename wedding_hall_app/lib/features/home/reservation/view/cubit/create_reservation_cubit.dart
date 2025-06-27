import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/make_reservation_request_body.dart';
import 'package:wedding_hall_app/features/home/reservation/data/repo/reservation_repo.dart';

import '../../../../core/domain/base_classes/base_state.dart';

class CreateReservationCubit extends Cubit<BaseState> {
  final ReservationRepo _reservationRepo;
  CreateReservationCubit(this._reservationRepo) : super(InitialState());

  Future<void> emitMakeReservation(MakeReservationRequestBody makeReservationRequestBody) async {
    emit(LoadingState());
    final data = await _reservationRepo.makeReservation(makeReservationRequestBody);
    data.when(
      success: (data) {
        emit(SuccessState(data));
      },
      failure: (error) {
        emit(ErrorState(error.apiErrorModel));
      },
    );
  }
}
