import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wedding_hall_app/config/di/di.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../core/domain/base_classes/base_state.dart';
import '../../data/model/reservation.dart';
import '../cubit/reservation_cubit.dart';
import '../widgets/reservation_card.dart';

class UserReservationScreen extends StatefulWidget {
  const UserReservationScreen({super.key});

  @override
  State<UserReservationScreen> createState() => _UserReservationScreenState();
}

class _UserReservationScreenState extends State<UserReservationScreen> {
  ReservationCubit reservationCubit = getIt<ReservationCubit>();

  @override
  void initState() {
    reservationCubit.emitUserReservations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, BaseState>(
      bloc: reservationCubit,
      builder: (context, state) {
        if (state is LoadingState) {
          return Center(
            child: SpinKitSpinningLines(
              color: AppColors().primaryColor,
              size: 56.0.r,
            ),
          );
        }
        if (state is SuccessState<List<Reservation>>) {
          if (state.data.isEmpty) {
            return Center(child: Text("No Reservation For You"));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SizedBox(
                  width: double.infinity,
                  child: Builder(
                    builder: (context) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          cardTheme: CardTheme(
                            color: AppColors().cardBackgroundColorOrderScreen,
                          ),
                        ),
                        child: ReservationCard(
                          reservation: state.data[index],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            itemCount: state.data.length,
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
