import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/di/di.dart';
import 'package:wedding_hall_app/features/core/domain/base_classes/base_state.dart';
import 'package:wedding_hall_app/features/home/halls/view/cubit/halls_cubit.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../core/view/screens/halls_resuable_screen.dart';
import '../../data/models/hall.dart';

class HallsScreen extends StatefulWidget {
  const HallsScreen({super.key});

  @override
  State<HallsScreen> createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  final hallsCubit = getIt<HallsCubit>();
  @override
  void initState() {
    hallsCubit.emitAllHalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HallsCubit, BaseState>(
      bloc: hallsCubit,
      builder: (context, state) {
        if (state is SuccessState<List<Hall>>) {
          return SingleChildScrollView(child: HallsResuableScreen(halls: state.data));
        }
        if (state is LoadingState) {
          return Center(
            child: SpinKitSpinningLines(
              color: AppColors().primaryColor,
              size: 56.0.r,
            ),
          );
        }
        if (state is ErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error Ouccred"),
                Gap(8.h),
                Text(state.apiErrorModel.error ?? ""),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
