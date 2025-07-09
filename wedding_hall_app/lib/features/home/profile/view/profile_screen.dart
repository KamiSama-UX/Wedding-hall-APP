import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/config/routes/routes_path.dart';

import '../../../../config/theme/custom_text_style.dart';
import '../../../auth/view/cubit/login_cubit.dart';
import '../../../core/view/widgets/scrollable_column_expanded.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.person),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.read<LoginCubit>().user!.name,
                    style: CustomTextStyle.font16BlackSemiBold,
                  ),
                  Text(
                    context.read<LoginCubit>().user!.email,
                    style: CustomTextStyle.font12BlackRegular,
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.pushNamedAndRemoveUntil(
                RoutesPath.login,
                predicate: (route) => false,
              );
            },
            child: Text("Logout"),
          ),
        ),
      ],
    );
  }
}
