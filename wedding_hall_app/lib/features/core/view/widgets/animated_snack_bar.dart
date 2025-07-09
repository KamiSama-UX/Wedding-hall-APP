import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// TODO : stop animation while popping
class AnimatedSnackBar extends StatefulWidget {
  final String title;
  final String description;
  final Icon icon;
  final Duration exitAnimationDelay;

  const AnimatedSnackBar({
    super.key,
    required this.exitAnimationDelay,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start entrance animation
    _controller.forward();

    // Schedule exit animation after the specified delay
    Future.delayed(widget.exitAnimationDelay, () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _opacityAnimation.value) * 20),
            child: SuccessMessage(
              description: widget.description,
              icon: widget.icon,
              title: widget.title,
            ),
          ),
        );
      },
    );
  }
}

class SuccessMessage extends StatelessWidget {
  final String title;
  final String description;
  final Icon icon;

  const SuccessMessage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Gap(12.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ConditionalBuilder(
                  condition: description.isNotEmpty,
                  builder: (context) => Column(
                    children: [
                      Gap(4.0.h),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  fallback: (context) {
                    return const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required String title,
  required String description,
  required Icon icon,
}) {
  const exitAnimationDelay = Duration(seconds: 2);
  const exitAnimationDuration = Duration(milliseconds: 500);
  final totalDuration = exitAnimationDelay + exitAnimationDuration;

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: totalDuration,
    padding: EdgeInsets.zero,
    content: AnimatedSnackBar(
      title: title,
      description: description,
      icon: icon,
      exitAnimationDelay: exitAnimationDelay,
    ),
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
