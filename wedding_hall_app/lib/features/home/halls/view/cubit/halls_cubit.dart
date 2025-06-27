import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/base_classes/base_state.dart';
import '../../data/repo/halls_repo.dart';

class HallsCubit<T> extends Cubit<BaseState> {
  final HallsRepo _hallsRepo;
  HallsCubit(this._hallsRepo) : super(InitialState());

  void _safeEmit(BaseState state) {
    if (!isClosed) emit(state);
  }

  emitAllHalls() async {
    _safeEmit(LoadingState());
    final response = await _hallsRepo.allHalls();
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
