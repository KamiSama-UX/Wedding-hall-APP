import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int maxStepCount;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.maxStepCount,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double indicatorWidth = screenWidth / (maxStepCount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        maxStepCount,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOut,
              height: 4.h,
              decoration: BoxDecoration(
                color: index <= currentStep
                    ? AppColors().primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              width: indicatorWidth,
            ),
          ),
        ),
      ),
    );
  }
}
