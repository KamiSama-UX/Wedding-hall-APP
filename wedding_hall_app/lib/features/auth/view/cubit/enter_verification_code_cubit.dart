
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/base_classes/base_state.dart';
import '../../data/models/verify_email_request_body.dart';
import '../../data/repo/auth_repo.dart';

class EnterVerificationCodeCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  EnterVerificationCodeCubit(this._authRepo) : super(InitialState());

  Future<void> emitVerify(VerifyEmailRequestBody verifyEmailRequestBody) async {
    emit(LoadingState());
    final data = await _authRepo.verify(verifyEmailRequestBody);
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

