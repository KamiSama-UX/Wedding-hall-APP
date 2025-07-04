
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall.dart';
import 'package:wedding_hall_app/features/home/halls/view/cubit/top_halls_cubit.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/routes/routes_path.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/domain/base_classes/base_state.dart';
import '../../../../core/view/screens/halls_resuable_screen.dart';
import '../../../../core/view/widgets/reusable_bloc_builder.dart';

import '../../../halls/view/screens/top_halls_screen.dart';
import '../widgets/trend_hall_slidder.dart';
import '../widgets/shimmers/hot_gifts_shimmer.dart';
import '../widgets/view_all_button.dart';

import 'package:dio/dio.dart';
import '../../../../chat_ai/view/screens/chat_ai_screen.dart';
import '../../../../chat_ai/data/repo/chat_ai_repository_impl.dart';
import '../../../../chat_ai/domain/usecases/send_message.dart';
import '../../../../chat_ai/view/cubit/chat_ai_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double carouselImageHeight = 160.0.h;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final dio = Dio();
          final repo = ChatAiRepositoryImpl(dio);
          final useCase = SendMessage(repo);
          final cubit = ChatAiCubit(useCase);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => cubit,
                child: ChatAiScreen(),
              ),
            ),
          );
        },
        child: Icon(Icons.chat_bubble_outline),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trending",
              textAlign: TextAlign.end,
              style: CustomTextStyle.font22BlackSemiBold,
            ),
            Gap(8.h),
            TrendHallSlidder(carouselImageHeight: carouselImageHeight),
            Gap(16.0.h),
            ReusableBlocBuilder<TopHallsCubit>(
              createCubit: () => getIt<TopHallsCubit>(),
              onBuild: (cubit) {
                cubit.emitTopHalls();
              },
              builder: (context, state) {
                if (state is SuccessState<List<Hall>>) {
                  final topHalls = state.data;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).hotGifts,
                            style: CustomTextStyle.font22BlackSemiBold,
                          ),
                          ViewAllButton(
                            onPress: () {
                              context.pushNamed(RoutesPath.topHalls, arguments: topHalls);
                            },
                          ),
                        ],
                      ),
                      Gap(8.0.h),
                      HallsResuableScreen(
                        halls: topHalls,
                        showAll: false,
                        emptyStateScreenMessage: S.of(context).noHotGiftsFound,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              shimmerBuilder: () => const HotGiftsShimmer(),
            ),
          ],
        ),
      ),
    );
  }
}
