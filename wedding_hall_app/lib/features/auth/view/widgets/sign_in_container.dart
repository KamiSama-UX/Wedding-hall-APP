import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignInContainer extends StatefulWidget {
  final String title;
  final void Function() onTap;
  final Widget icon;

  const SignInContainer({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  State<SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<SignInContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0.r),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            Gap(10.0.w),
            Text(widget.title),
          ],
        ),
      ),
    );
  }
}
