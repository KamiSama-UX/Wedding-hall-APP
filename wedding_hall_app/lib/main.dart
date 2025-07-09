import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/di/di.dart';
import 'config/helpers/bloc_observer.dart';
import 'config/helpers/hive_constants.dart';
import 'config/helpers/hive_local_storge.dart';
import 'config/networking/dio_factory.dart';
import 'config/routes/app_router.dart';
import 'config/routes/routes_path.dart';
import 'config/theme/light_theme.dart';
import 'features/auth/view/cubit/login_cubit.dart';
import 'features/core/view/cubit/language_cubit.dart';
import 'generated/l10n.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await _setupHive();
  await setupGetIt();
  await _setInitialRoute();
  runApp(const WeddingHallApp());
}

Future<void> _setupHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await HiveLocalStorge.setupMainBoxHive();
}

Future<void> _setInitialRoute() async {
  final String? token = await HiveLocalStorge.get(
    boxName: HiveConstants.mainBox,
    key: HiveConstants.tokenKey,
  );
  if (token != null) {
    AppRouter.initialRoute = RoutesPath.login;

  } else {
    AppRouter.initialRoute = RoutesPath.login;
  }
}

class WeddingHallApp extends StatefulWidget {
  const WeddingHallApp({super.key});

  @override
  State<WeddingHallApp> createState() => _WeddingHallAppState();
}

class _WeddingHallAppState extends State<WeddingHallApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginCubit>(create: (_) => getIt<LoginCubit>()),
            BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
          ],
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, state) {
              return MaterialApp(
                navigatorObservers: [AppRouter.routeObserver],
                initialRoute: AppRouter.initialRoute,
                onGenerateRoute: AppRouter.generateRoute,
                locale: state,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  ...PhoneFieldLocalization.delegates,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                theme: KTheme().getLightTheme(),
              );
            },
          ),
        );
      },
    );
  }
}
