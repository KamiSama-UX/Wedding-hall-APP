import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/base_classes/base_state.dart';
import '../../data/models/sign_up_request_body.dart';
import '../../data/repo/auth_repo.dart';

class SignUpCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  SignUpCubit(this._authRepo) : super(InitialState());

  Future<void> emitSignup(SignUpRequestBody signUpRequestBody) async {
    emit(LoadingState());
    final data = await _authRepo.signup(signUpRequestBody);
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
