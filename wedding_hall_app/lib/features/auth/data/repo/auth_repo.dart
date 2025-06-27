import '../../../../config/networking/api_error_handler.dart';
import '../../../../config/networking/api_result.dart';
import '../../../../config/networking/api_service.dart';
import '../../../core/data/models/success_response.dart';
import '../models/email_otp_reset_password.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';
import '../models/reset_password_request_body.dart';
import '../models/sign_up_request_body.dart';
import '../models/verify_email_request_body.dart';

class AuthRepo {
  final ApiService _apiService;

  AuthRepo(this._apiService);

  Future<Result<SuccessResponse>> signup(
    SignUpRequestBody signUpRequestBody,
  ) async {
    try {
      final data = await _apiService.signup(signUpRequestBody);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<SuccessResponse>> sendOtpEmailResetPassword(EmailOtpResetPassword emailOtpResetPassword) async {
    try {
      final data = await _apiService.sendOtpEmailResetPassword(emailOtpResetPassword);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<SuccessResponse>> verify(
    VerifyEmailRequestBody verifyEmailRequestBody,
  ) async {
    try {
      final data = await _apiService.verify(verifyEmailRequestBody);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<LoginResponse>> login(LoginRequestBody loginReqeustBody) async {
    try {
      final data = await _apiService.login(loginReqeustBody);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<Result<SuccessResponse>> resetPassword(
    ResetPasswordRequestBody resetPasswordRequestBody,
  ) async {
    try {
      final data = await _apiService.resetPassword(resetPasswordRequestBody);
      return Success(data);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
