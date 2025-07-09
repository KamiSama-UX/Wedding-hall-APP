
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wedding_hall_app/features/auth/data/models/reset_password_request_body.dart';
import 'package:wedding_hall_app/features/auth/view/cubit/reset_password_cubit.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/make_reservation_request_body.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/reservation.dart';
import '../../features/auth/data/models/email_otp_reset_password.dart';
import '../../features/auth/data/models/login_request_body.dart';
import '../../features/auth/data/models/login_response.dart';
import '../../features/auth/data/models/sign_up_request_body.dart';
import '../../features/auth/data/models/verify_email_request_body.dart';
import '../../features/core/data/models/success_response.dart';
import '../../features/home/halls/data/models/get_hall_services.dart';
import '../../features/home/halls/data/models/hall.dart';
import '../../features/home/halls/data/models/hall_availability_request_body.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrlApi)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.register)
  Future<SuccessResponse> signup(
    @Body() SignUpRequestBody signUpRequestBody,
  );

  @POST(ApiConstants.verifyRegister)
  Future<SuccessResponse> verify(
    @Body() VerifyEmailRequestBody verifyEmailRequestBody,
  );

  @POST(ApiConstants.login)
  Future<LoginResponse> login(
    @Body() LoginRequestBody loginRequestBody,
  );
  @POST(ApiConstants.sendOtpEmailResetPasword)
  Future<SuccessResponse> sendOtpEmailResetPassword(
    @Body() EmailOtpResetPassword email,
  );

  @POST(ApiConstants.verifyOtpResetPassword) 
  Future<SuccessResponse> verifyOtpEmailResetPassword(
    @Body() VerifyEmailRequestBody verifyEmailRequestBody,
  );

  @POST(ApiConstants.resetPassword)
  Future<SuccessResponse> resetPassword(
    @Body() ResetPasswordRequestBody resetPasswordRequestBody,
  );

  @POST(ApiConstants.makeReservations)
  Future makeReservation(
    @Body() MakeReservationRequestBody makeReservationRequestBody,
  );

  
  @GET(ApiConstants.userReservations)
  Future<List<Reservation>> userReservations();

  @GET(ApiConstants.allHalls)
  Future<List<Hall>> allHalls();

  @GET(ApiConstants.trendingHalls)
  Future<List<Hall>> trendingHalls();

  @GET(ApiConstants.topHalls)
  Future<List<Hall>> topHalls();

  @GET(ApiConstants.getHallService)
  Future<GetHallServices> hallService(
    @Path("id") int hallId
  );

  @POST(ApiConstants.hallAva)


  Future<Map<String, bool>> hallAvailability(
    @Body() HallAvailabilityRequestBody hallAvailabilityRequestBody
  );
}
