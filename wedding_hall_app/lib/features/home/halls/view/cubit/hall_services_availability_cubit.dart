import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall.dart';

import '../../../../core/domain/base_classes/base_state.dart';
import '../../data/repo/halls_repo.dart';

class HallServicesAvailabilityCubit<T> extends Cubit<BaseState> {
  final HallsRepo _hallsRepo;
  HallServicesAvailabilityCubit(this._hallsRepo) : super(InitialState());

  void _safeEmit(BaseState state) {
    if (!isClosed) emit(state);
  }

  emitHallServicesaAvailability(Hall hall) async {
    _safeEmit(LoadingState());
    final response = await _hallsRepo.hallReservationRequriments(hall);
    response.when(
      success: (data) {
        _safeEmit(SuccessState(data));
      },
      failure: (error) {
        _safeEmit(ErrorState(error.apiErrorModel));
      },
    );
  }
}
