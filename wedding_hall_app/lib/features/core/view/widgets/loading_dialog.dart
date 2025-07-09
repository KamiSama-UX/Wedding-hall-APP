import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/theme/app_colors.dart';

Future<dynamic> loadingDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: Center(
        child: SpinKitSpinningLines(
          color: AppColors().primaryColor,
        ),
      ),
    ),
  );
}
