
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/helpers/hive_constants.dart';
import '../../../../config/helpers/hive_local_storge.dart';
import '../../../../config/networking/dio_factory.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../data/models/login_request_body.dart';
import '../../data/models/login_response.dart';

import '../../data/repo/auth_repo.dart';

class LoginCubit extends Cubit<BaseState> {
  final AuthRepo _authRepo;
  LoginCubit(this._authRepo) : super(InitialState());

  UserData? user;
  

  Future<void> emitLogin(LoginRequestBody loginRequestBody) async {
    emit(LoadingState());
    final data = await _authRepo.login(loginRequestBody);
    data.when(
      success: (data) async {
        emit(SuccessState(data));
        await HiveLocalStorge.put(
          boxName: HiveConstants.mainBox,
          key: HiveConstants.isLoggedWithGoogle,
          value: false,
        );
        await HiveLocalStorge.put(
          boxName: HiveConstants.mainBox,
          key: HiveConstants.tokenKey,
          value: data.token,
        );
        DioFactory.setTokenIntoHeader(data.token);
        user = data.userData;
      },
      failure: (error) {
        emit(ErrorState(error.apiErrorModel));
      },
    );
  }
}
