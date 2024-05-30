import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

export 'app_color.dart';

abstract class AppFont {
  static TextStyle get _style => GoogleFonts.cairo();


  static TextStyle get font20W700Primary => _style.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.primary,
      );

  static TextStyle get textFiled => _style.copyWith(
        fontSize: 14.sp,
        color: AppColor.primary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get font12Regular => _style.copyWith(
        fontSize: 12.sp,
      );

}
