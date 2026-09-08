import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/resources/color_manager.dart';

InputDecoration customDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      fillColor: ColorManager.lighterGray,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.white,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }