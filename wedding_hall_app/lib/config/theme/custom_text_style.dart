import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class CustomTextStyle {
  static const fontFamily = "Montserrat";
  static final AppColors _appColors = AppColors();

  static TextStyle font20BlackSemiBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font16Blacklight = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle font20BlackRegular = TextStyle(
    fontSize: 20.sp,
  );

  static TextStyle font16BlackSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font18BlackSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font10BlackLight = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle font13BlackRegular = TextStyle(
    fontSize: 13.sp,
  );

  static TextStyle font13PrimaryColorBold = TextStyle(
    fontSize: 13.sp,
    color: _appColors.primaryColor,
  );
  static TextStyle font12PrimaryColorBoldUnderline = TextStyle(
    fontSize: 12.sp,
    color: _appColors.primaryColor,
    decoration: TextDecoration.underline,
    decorationColor: _appColors.primaryColor
  );

  static TextStyle font14BlackRegular = TextStyle(
    fontSize: 14.sp,
    color: Colors.black,
  );

  static TextStyle font14BlackSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle font12BlackRegular = TextStyle(
    fontSize: 12.sp,
    color: Colors.black,
  );

  static TextStyle font16BlackRegular = TextStyle(
    fontSize: 16.sp,
    color: Colors.black,
  );

  static TextStyle font22BlackSemiBold = TextStyle(
    fontSize: 22.0.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle font14PrimaryColorSemiBold = TextStyle(
    fontSize: 14.0.sp,
    fontWeight: FontWeight.w600,
    color: _appColors.primaryColor,
  );
}
