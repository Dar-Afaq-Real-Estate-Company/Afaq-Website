import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/styles_manager.dart';

Widget buildDropdown({
  required String hint,
  required List<String> items,
  required void Function(String?)? onChanged,
  String? value,
  String? Function(String?)? validator,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      hintText: hint,
      hintStyle: StylesManager.font12GrayRegular,
      fillColor: ColorManager.lighterGray,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ColorManager.lighterGray,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primary,
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
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    icon: Icon(Icons.keyboard_arrow_down, color: ColorManager.grey),
    style: StylesManager.font12GrayRegular,
    hint: Text(hint, style: StylesManager.font12GrayRegular),
    items: items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList(),
    onChanged: onChanged,
    validator: validator ??
        (value) {
          return null;
        },
  );
}
