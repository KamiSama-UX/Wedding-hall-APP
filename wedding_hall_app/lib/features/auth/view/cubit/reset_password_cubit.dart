import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/base_classes/base_state.dart';
import '../../data/models/reset_password_request_body.dart';
import '../../data/repo/auth_repo.dart';

class ResetPasswordCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  ResetPasswordCubit(this._authRepo) : super(InitialState());

  Future<void> emitResetPassword(ResetPasswordRequestBody resetPasswordRequestBody) async {
    emit(LoadingState());
    final data = await _authRepo.resetPassword(resetPasswordRequestBody);
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
