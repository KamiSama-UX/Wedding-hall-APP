import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/base_classes/base_state.dart';
import '../../data/repo/halls_repo.dart';

class TopHallsCubit<T> extends Cubit<BaseState> {
  final HallsRepo _hallsRepo;
  TopHallsCubit(this._hallsRepo) : super(InitialState());

  void _safeEmit(BaseState state) {
    if (!isClosed) emit(state);
  }

  emitTopHalls() async {
    _safeEmit(LoadingState());
    final response = await _hallsRepo.topHalls();
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
