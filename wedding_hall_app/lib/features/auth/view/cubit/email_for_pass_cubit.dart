import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/base_classes/base_state.dart';
import '../../data/models/email_otp_reset_password.dart';
import '../../data/repo/auth_repo.dart';

class EmailForPassCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  EmailForPassCubit(this._authRepo) : super(InitialState());

    Future<void> emitEmailForPass(EmailOtpResetPassword emailOtpResetPassword) async {
    emit(LoadingState());
    final data = await _authRepo.sendOtpEmailResetPassword(emailOtpResetPassword);
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
