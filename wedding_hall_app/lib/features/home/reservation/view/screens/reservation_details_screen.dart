import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wedding_hall_app/config/di/di.dart';
import 'package:wedding_hall_app/features/auth/view/cubit/login_cubit.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_service.dart';
import 'package:wedding_hall_app/features/home/halls/domain/enums/pricing_type.dart';
import 'package:wedding_hall_app/features/home/reservation/view/cubit/reservation_cubit.dart';
import 'package:wedding_hall_app/features/home/reservation/view/cubit/reservation_ui_cubit.dart';

import '../../../../../config/theme/custom_text_style.dart';

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key});

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  @override
  void initState() {
    print("hello");
    super.initState();
  }

  final ReservationCubit reservationCubit = getIt<ReservationCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Booking Info", style: CustomTextStyle.font16BlackSemiBold),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Name:", style: CustomTextStyle.font14BlackRegular),
                      Text(getIt<LoginCubit>().user!.name),
                    ],
                  ),
                  Gap(4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hall:", style: CustomTextStyle.font14BlackRegular),
                      Text(
                        context
                            .read<ReservationUiCubit>()
                            .hallServicesAvailability
                            .hall
                            .name,
                      ),
                    ],
                  ),
                  Gap(4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date:", style: CustomTextStyle.font14BlackRegular),
                      Text(
                        context.read<ReservationUiCubit>().dateController.text,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Guest Count:",
                  style: CustomTextStyle.font16BlackSemiBold,
                ),
                Text(context.read<ReservationUiCubit>().guestController.text),
              ],
            ),
            Divider(),
            Text("Services List:", style: CustomTextStyle.font16BlackSemiBold),
            Padding(
              padding: EdgeInsets.all(8.0.h),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  HallService hallService =
                      context
                          .read<ReservationUiCubit>()
                          .selectedServices
                          .keys
                          .toList()[index];
                  if (!context
                      .read<ReservationUiCubit>()
                      .selectedServices[hallService]!) {
                    return SizedBox.shrink();
                  }
                  double priceForEachHallService = 0; // initial
                  if (hallService.pricingType == PricingType.invitation_based) {
                    priceForEachHallService =
                        double.parse(hallService.price) *
                        int.parse(
                          context
                              .read<ReservationUiCubit>()
                              .guestController
                              .text,
                        );
                  } else {
                    priceForEachHallService = double.parse(hallService.price);
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hallService.name,
                            style: CustomTextStyle.font14BlackRegular,
                          ),
                          ConditionalBuilder(
                            condition:
                                hallService.pricingType == PricingType.static,
                            builder: (context) {
                              return SizedBox.shrink();
                            },
                            fallback: (context) {
                              return Text("${hallService.price}\$ per person");
                            },
                          ),
                        ],
                      ),
                      Text("${priceForEachHallService.toString()}\$"),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Gap(8.h);
                },
                itemCount:
                    context.read<ReservationUiCubit>().selectedServices.length,
              ),
            ),
            ConditionalBuilder(
              condition:
                  context
                      .read<ReservationUiCubit>()
                      .noteController
                      .text
                      .isNotEmpty,
              fallback: (context) => SizedBox.shrink(),
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),

                    Text("Note:", style: CustomTextStyle.font16BlackSemiBold),
                    Gap(8.h),
                    Text(
                      context.read<ReservationUiCubit>().noteController.text,
                    ),
                  ],
                );
              },
            ),
            Divider(),
            Text("Total Price:", style: CustomTextStyle.font16BlackSemiBold),
            Gap(8.h),
            Text(
              "${context.read<ReservationUiCubit>().hallServicesAvailability.calculatePrice(context.read<ReservationUiCubit>().selectedServices.keys.where((value) {
                return context.read<ReservationUiCubit>().selectedServices[value]!;
              }).toList(), int.parse(context.read<ReservationUiCubit>().guestController.text)).toString()}\$",
              style: CustomTextStyle.font18BlackSemiBold,
            ),
          ],
        ),
      ),
    );
  }

  Text textSpanComponent({required String header, required String value}) {
    {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: header, style: CustomTextStyle.font16BlackRegular),
            TextSpan(text: value, style: CustomTextStyle.font14BlackRegular),
          ],
        ),
      );
    }
  }
}
