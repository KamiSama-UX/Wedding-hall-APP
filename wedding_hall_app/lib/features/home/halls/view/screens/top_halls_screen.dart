import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/di/di.dart';
import 'package:wedding_hall_app/features/core/domain/base_classes/base_state.dart';
import 'package:wedding_hall_app/features/home/halls/view/cubit/halls_cubit.dart';
import 'package:wedding_hall_app/features/home/halls/view/cubit/top_halls_cubit.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../core/view/screens/halls_resuable_screen.dart';
import '../../data/models/hall.dart';

class TopHallsScreen extends StatefulWidget {
  final List<Hall> topHalls;
  const TopHallsScreen({super.key, required this.topHalls});

  @override
  State<TopHallsScreen> createState() => _TopHallsScreenState();
}

class _TopHallsScreenState extends State<TopHallsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Halls")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
        child: SingleChildScrollView(
          child: HallsResuableScreen(halls: widget.topHalls),
        ),
      ),
    );
  }
}
