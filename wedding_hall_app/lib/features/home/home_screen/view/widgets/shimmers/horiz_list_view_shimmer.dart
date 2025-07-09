import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizListViewShimmer extends StatelessWidget {
  const HorizListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100.w,
                height: 22.h,
                color: Colors.white, 
              ),
              Container(
                width: 60.w,
                height: 22.h,
                color: Colors.white, 
              ),
            ],
          ),
        ),
        Gap(8.h),
        // Shimmer for the horizontal ListView
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: SizedBox(
                  height: 105.h,
                  child: Column(
                    children: [
                      // Shimmer for the CircleAvatar
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: const BoxDecoration(
                          color: Colors.white, 
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(10.h),
                      // Shimmer for the text
                      Container(
                        width: 40.w,
                        height: 12.h,
                        color: Colors.white, 
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 10, // Number of shimmer items
            separatorBuilder: (context, index) => Gap(18.h),
          ),
        ),
      ],
    );
  }
}