import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';

Padding SearchWidget(BuildContext context, {required void Function()? onTap}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: const Color(0xFF3E7CB1)),
            SizedBox(width: 10.w),
            Text(
              AppStrings.searchSectionsOrServices.tr(),
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}
