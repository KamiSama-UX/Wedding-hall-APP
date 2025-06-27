import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_service.dart';
import 'package:wedding_hall_app/features/home/reservation/data/model/reservation.dart';
import 'package:wedding_hall_app/features/home/reservation/domain/enums/reservation_status.dart';

import '../../../../../config/helpers/hex_color.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';
import '../screens/reservation_details_screen.dart';
import '../shared/banner_color.dart';

class ReservationCard extends StatefulWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  int reservationItemCount = 5;
  double reservationImageSize = 32.h;
  double reservationItemGap = 8.h;

  late String formmatedDate;

  @override
  void initState() {
    formmatedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(widget.reservation.eventDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${S.of(context).orderId}: ${widget.reservation.id}",
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            widget.reservation.status ==
                                    ReservationStatus.pending
                                ? Colors.white
                                : bannerColor(widget.reservation.status),
                        borderRadius: BorderRadius.circular(10.0.r),
                        border: Border.all(
                          width: 1,
                          color: bannerColor(widget.reservation.status),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.reservation.status.name
                              .toUpperCase()
                              .toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(8.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hall Name: ${widget.reservation.hallName}",
                    ),
                  ],
                ),
              ),
            ),
            Gap(8.0.h),
    
            ConditionalBuilder(
              condition: widget.reservation.status == ReservationStatus.declined,
              builder:
                  (context) => Column(
                    children: [
                      Gap(8.0.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reservation can't be done",
                                      style:
                                          CustomTextStyle.font14BlackSemiBold,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              fallback: (context) => const SizedBox.shrink(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height:
                          widget.reservation.services.length *
                              reservationImageSize +
                          widget.reservation.services.length *
                              reservationItemGap,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0.r),
                        color: bannerColor(widget.reservation.status),
                      ),
                    ),
                    Gap(10.w),
                    Flexible(
                      child: ListView.separated(
                        itemCount: widget.reservation.services.length,
                        separatorBuilder: (context, index) => Gap(8.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.reservation.services[index].name,
                              ),
                              Text(
                                "${widget.reservation.services[index].servicePrice}\$",
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(8.h),
            Container(
              width: double.infinity,
              height: 1,
              color: HexColor("#CAC4D0"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formmatedDate,
                    style: CustomTextStyle.font14BlackRegular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
