import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/view/cubit/login_cubit.dart';
import '../../features/auth/view/cubit/email_for_pass_cubit.dart';
import '../../features/auth/view/cubit/enter_verification_code_cubit.dart';
import '../../features/auth/view/cubit/reset_password_cubit.dart';
import '../../features/auth/view/cubit/sign_up_cubit.dart';
import '../../features/home/halls/view/cubit/hall_services_availability_cubit.dart';
import '../../features/home/halls/view/cubit/top_halls_cubit.dart';
import '../../features/home/halls/view/cubit/trend_hall_cubit.dart';
import '../../features/home/reservation/data/repo/reservation_repo.dart';
import '../../features/home/halls/data/repo/halls_repo.dart';
import '../../features/home/halls/view/cubit/halls_cubit.dart';
import '../../features/home/reservation/view/cubit/create_reservation_cubit.dart';
import '../../features/home/reservation/view/cubit/reservation_cubit.dart';
import '../../features/home/reservation/view/cubit/reservation_ui_cubit.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import 'package:dio/dio.dart';
import '../../features/chat_ai/data/repo/chat_ai_repository_impl.dart';
import '../../features/chat_ai/domain/usecases/send_message.dart';
import '../../features/chat_ai/view/cubit/chat_ai_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiService
  Dio dio = DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton(() => AuthRepo(getIt()));

  getIt.registerSingleton(LoginCubit(getIt()));
  getIt.registerFactory(() => EmailForPassCubit(getIt()));
  getIt.registerFactory(() => SignUpCubit(getIt()));
  getIt.registerFactory(() => EnterVerificationCodeCubit(getIt()));
  getIt.registerFactory(() => ResetPasswordCubit(getIt()));

  getIt.registerLazySingleton(() => HallsRepo(getIt()));
  getIt.registerFactory(() => HallsCubit(getIt()));
  getIt.registerFactory(() => TopHallsCubit(getIt()));
  getIt.registerFactory(() => TrendHallCubit(getIt()));
  getIt.registerFactory(() => HallServicesAvailabilityCubit(getIt()));

  getIt.registerLazySingleton(() => ReservationRepo(getIt()));
  getIt.registerFactory(() => ReservationCubit(getIt()));
  getIt.registerFactory(() => CreateReservationCubit(getIt()));
  
}
final dio = Dio();

final chatRepository = ChatAiRepositoryImpl(dio);
final sendMessageUseCase = SendMessage(chatRepository);
final chatAiCubit = ChatAiCubit(sendMessageUseCase);