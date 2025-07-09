import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/features/home/halls/domain/entity/hall_services_availability.dart';
import 'package:wedding_hall_app/features/home/halls/view/screens/top_halls_screen.dart';
import 'package:wedding_hall_app/features/home/reservation/view/cubit/reservation_ui_cubit.dart';
import 'package:wedding_hall_app/features/home/reservation/view/screens/reservation_layout.dart';

import '../../features/auth/view/cubit/email_for_pass_cubit.dart';
import '../../features/auth/view/cubit/enter_verification_code_cubit.dart';
import '../../features/auth/view/cubit/reset_password_cubit.dart';
import '../../features/auth/view/cubit/sign_up_cubit.dart';
import '../../features/auth/view/screens/reset_password_screen.dart';
import '../../features/auth/view/screens/login_screen.dart';
import '../../features/auth/view/screens/enter_email.dart';
import '../../features/auth/view/screens/enter_verification_code.dart';
import '../../features/auth/view/screens/signup_screen.dart';
import '../../features/home/halls/data/models/hall.dart';
import '../../features/home/halls/view/screens/hall_details_screen.dart';
import '../../features/home/layout/view/screens/home_layout.dart';
import '../../features/home/halls/view/screens/trend_hall_screen.dart';
import '../../features/home/reservation/view/screens/user_reservation_screen.dart';
import '../di/di.dart';
import 'routes_path.dart';

class AppRouter {
  static String initialRoute = RoutesPath.login;
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPath.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: const RouteSettings(name: RoutesPath.login),
        );

      case RoutesPath.reservations:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RoutesPath.reservations),
          builder: (_) => const UserReservationScreen(),
        );
      case RoutesPath.trendHall:
        {
          final Hall hall = settings.arguments as Hall;
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.trendHall),
            builder: (_) => TrendHallDetailsScreen(hall: hall),
          );
        }
      case RoutesPath.userReservation:
        {
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.userReservation),
            builder: (_) => UserReservationScreen(),
          );
        }
      case RoutesPath.hallDetails:
        {
          final Hall hall = settings.arguments as Hall;
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.hallDetails),
            builder: (_) => HallDetailsScreen(hall: hall),
          );
        }
      case RoutesPath.signUp:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RoutesPath.signUp),
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<SignUpCubit>(),
                child: const SignupScreen(),
              ),
        );
      case RoutesPath.enterEmail:
        return MaterialPageRoute(
          settings: const RouteSettings(name: RoutesPath.enterEmail),
          builder:
              (_) => BlocProvider<EmailForPassCubit>(
                create: (context) => getIt<EmailForPassCubit>(),
                child: const EnterEmail(),
              ),
        );
      case RoutesPath.resetPassword:
        {
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.resetPassword),
            builder:
                (_) => BlocProvider(
                  create: (context) => getIt<ResetPasswordCubit>(),
                  child: ResetPasswordScreen(email: email),
                ),
          );
        }

      case RoutesPath.homeLayout:
        {
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.homeLayout),
            builder: (_) => const HomeLayout(),
          );
        }
      case RoutesPath.topHalls:
        {
          final List<Hall> topHalls = settings.arguments as List<Hall>;
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.homeLayout),
            builder: (_) => TopHallsScreen(topHalls: topHalls),
          );
        }

      case RoutesPath.resertvationLayout:
        {
          final HallServicesAvailability hallServicesAvailability = settings.arguments as HallServicesAvailability;
          return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesPath.homeLayout),
            builder: (_) {
              return BlocProvider<ReservationUiCubit>(
                create: (context) => ReservationUiCubit(hallServicesAvailability),
                child: ReservationLayout(
                  hallServicesAvailability: hallServicesAvailability,
                ),
              );
            },
          );
        }

      case RoutesPath.enterVerificationCode:
        {
          final (String email, bool isSignUp) record =
              settings.arguments as (String email, bool isSignUp);
          return MaterialPageRoute(
            settings: const RouteSettings(
              name: RoutesPath.enterVerificationCode,
            ),
            builder:
                (_) => BlocProvider(
                  create: (context) => getIt<EnterVerificationCodeCubit>(),
                  child: EnterVerificationCode(record: record),
                ),
          );
        }
      default:
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
