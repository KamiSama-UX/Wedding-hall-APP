import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/di/di.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/config/routes/routes_path.dart';
import 'package:wedding_hall_app/features/core/domain/base_classes/base_state.dart';
import 'package:wedding_hall_app/features/core/view/widgets/error_dialog.dart';
import 'package:wedding_hall_app/features/core/view/widgets/loading_dialog.dart';
import 'package:wedding_hall_app/features/home/halls/domain/entity/hall_services_availability.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/make_reservation_request_body.dart';
import 'package:wedding_hall_app/features/home/reservation/view/cubit/create_reservation_cubit.dart';
import '../../../../core/view/widgets/animated_snack_bar.dart';
import '../cubit/reservation_ui_cubit.dart';
import '../widgets/my_order_stepper.dart';
import 'reservation_details_screen.dart';
import 'services_screen.dart';

class ReservationLayout extends StatefulWidget {
  final HallServicesAvailability hallServicesAvailability;
  const ReservationLayout({super.key, required this.hallServicesAvailability});

  @override
  State<ReservationLayout> createState() => _ReservationLayoutState();
}

class _ReservationLayoutState extends State<ReservationLayout> {
  ValueNotifier<int> indicatorIndexNotifier = ValueNotifier<int>(0);
  List<Widget> screens = [];
  final CreateReservationCubit createReservationCubit =
      getIt<CreateReservationCubit>();
  @override
  void initState() {
    screens = [
      ServicesScreen(hallServicesAvailability: widget.hallServicesAvailability),
      ReservationDetailsScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation Detials"),
        leading: BackButton(
          onPressed: () {
            if (context.read<ReservationUiCubit>().currentIndex > 0) {
              context.read<ReservationUiCubit>().pageController.previousPage(
                duration: Duration(milliseconds: 100),
                curve: Easing.linear,
              );
              context.read<ReservationUiCubit>().currentIndex--;
              setState(() {});
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              builder:
                  (context, value, child) => StepIndicator(
                    maxStepCount: screens.length,
                    currentStep: indicatorIndexNotifier.value,
                  ),
              valueListenable: indicatorIndexNotifier,
            ),
            Gap(4.h),
            Flexible(
              child: PageView(
                controller: context.read<ReservationUiCubit>().pageController,
                physics: NeverScrollableScrollPhysics(),
                children: screens,
                onPageChanged: (value) {
                  indicatorIndexNotifier.value = value;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MakeReservationRequestBody? makeReservationRequestBody =
              context.read<ReservationUiCubit>().onNextTap();
          if (makeReservationRequestBody != null) {
            createReservationCubit.emitMakeReservation(
              makeReservationRequestBody,
            );
          }
          setState(() {});
        },
        label: Row(
          children: [
            BlocListener<CreateReservationCubit, BaseState>(
              bloc: createReservationCubit,
              listener: (context, state) {
                if (state is LoadingState) {
                  loadingDialog(context);
                }
                if (state is ErrorState) {
                  context.pop();
                  errorDialog(
                    context,
                    message: state.apiErrorModel.error ?? "",
                  );
                }

                if (state is SuccessState) {
                  showSnackBar(
                    context: context,
                    title: "Success",
                    description: 'Hall Reservation Completed Successfuly',
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                  );
                  context.pushNamedAndRemoveUntil(
                    RoutesPath.homeLayout,
                    predicate: (route) => false,
                  );
                }
              },
              child: SizedBox.shrink(),
            ),
            Text(
              context.read<ReservationUiCubit>().currentIndex == 1
                  ? "Confrim Reservation"
                  : "Next",
            ),
            Gap(5.0.w),
            context.read<ReservationUiCubit>().currentIndex == 0
                ? const Icon(Icons.arrow_right_alt_outlined)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
