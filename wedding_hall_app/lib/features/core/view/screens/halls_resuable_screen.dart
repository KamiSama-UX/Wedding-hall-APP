import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../home/halls/data/models/hall.dart';
import '../../../home/halls/view/widgets/hall_item.dart';

class HallsResuableScreen extends StatelessWidget {
  final List<Hall> halls;
  final bool showAll;
  final String? emptyStateScreenMessage;
  const HallsResuableScreen({
    super.key,
    this.showAll = true,
    required this.halls,
    this.emptyStateScreenMessage,
  });
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: halls.isNotEmpty,
      builder: (context) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return HallItem(
              hall: halls[index],
            );
          },
          itemCount: showAll
              ? halls.length
              : listLenght(
                  halls.length,
                  showAll,
                ),
          separatorBuilder: (context, index) => Gap(8.h),
        );
      },
      fallback: (context) => Center(
        child: Text("No Halls"),
      )
    );
  }

  int listLenght(int listLenght, bool showAll) {
    if (showAll) {
      return listLenght;
    }
    return listLenght < 8 ? listLenght : 8;
  }
}
