import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wedding_hall_app/config/theme/custom_text_style.dart';
import 'package:wedding_hall_app/features/home/halls/domain/enums/pricing_type.dart';

import '../../../halls/domain/entity/hall_services_availability.dart';
import '../cubit/reservation_ui_cubit.dart';

class ServicesScreen extends StatefulWidget {
  final HallServicesAvailability hallServicesAvailability;
  const ServicesScreen({super.key, required this.hallServicesAvailability});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ReservationUiCubit>().key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select number of guests",
            style: CustomTextStyle.font16BlackSemiBold,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Guest Count")),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller:
                            context.read<ReservationUiCubit>().guestController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Number of guest is requierd";
                          }
                          if (int.parse(value) >
                              widget.hallServicesAvailability.hall.capacity) {
                            return "Number of guest is nigger than the capacity";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "XX",
                          enabledBorder: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      "${widget.hallServicesAvailability.hall.capacity} max guests",
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(4.h),
          Divider(),
          Text("Select Date", style: CustomTextStyle.font16BlackSemiBold),
          Gap(8.h),
          TextFormField(
            controller: context.read<ReservationUiCubit>().dateController,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                initialDate: DateTime.now(),
                context: context,
                firstDate: DateTime.now(),
                selectableDayPredicate: (day) {
                  return widget
                          .hallServicesAvailability
                          .parsedAvailability[day] ==
                      true;
                },
                lastDate: widget.hallServicesAvailability.lastDate,
              );

              if (selectedDate != null && context.mounted) {
                String formmatedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate);
                context.read<ReservationUiCubit>().dateController.text =
                    formmatedDate;
              }
            },
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Pick a date",
              prefixIcon: Icon(Icons.date_range),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Date is required";
              }
              return null;
            },
          ),
          Gap(8.h),
          Divider(),
          Text("Select Services", style: CustomTextStyle.font16BlackSemiBold),
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Checkbox(
                      value:
                          index == 0
                              ? true
                              : context
                                      .read<ReservationUiCubit>()
                                      .selectedServices[widget
                                      .hallServicesAvailability
                                      .hallServices[index]] ==
                                  true,
                      onChanged:
                          index == 0
                              ? null
                              : (value) {
                                if (value!) {
                                  context
                                      .read<ReservationUiCubit>()
                                      .selectedServices
                                      .addAll({
                                        widget
                                                .hallServicesAvailability
                                                .hallServices[index]:
                                            true,
                                      });
                                } else {
                                  context
                                          .read<ReservationUiCubit>()
                                          .selectedServices[widget
                                          .hallServicesAvailability
                                          .hallServices[index]] =
                                      false;
                                }
                                setState(() {});
                              },
                    ),
                    ConditionalBuilder(
                      condition:
                          widget
                              .hallServicesAvailability
                              .hallServices[index]
                              .pricingType ==
                          PricingType.invitation_based,
                      builder: (context) {
                        return Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget
                                    .hallServicesAvailability
                                    .hallServices[index]
                                    .name,
                                style: CustomTextStyle.font14BlackSemiBold,
                              ),
                              Text(
                                "${widget.hallServicesAvailability.hallServices[index].price}\$ per person",
                                style: CustomTextStyle.font12BlackRegular,
                              ),
                            ],
                          ),
                        );
                      },
                      fallback: (context) {
                        return Text(
                          widget
                              .hallServicesAvailability
                              .hallServices[index]
                              .name,
                          style: CustomTextStyle.font14BlackSemiBold,
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      "${widget.hallServicesAvailability.hallServices[index].price}\$",
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Gap(4.h);
              },
              itemCount: widget.hallServicesAvailability.hallServices.length,
            ),
          ),
          Divider(),
          Text("Notes", style: CustomTextStyle.font16BlackSemiBold),
          Gap(8.h),
          TextFormField(
            minLines: 1,
            maxLines: 4,
            controller: context.read<ReservationUiCubit>().noteController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Any notes you want",
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
