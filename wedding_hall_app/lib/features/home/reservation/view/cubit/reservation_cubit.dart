import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/features/home/reservation/data/repo/reservation_repo.dart';

import '../../../../core/domain/base_classes/base_state.dart';

class ReservationCubit extends Cubit<BaseState> {
  final ReservationRepo _reservationRepo;
  ReservationCubit(this._reservationRepo) : super(InitialState());

  Future<void> emitUserReservations() async {
    emit(LoadingState());
    final data = await _reservationRepo.userReservation();
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
