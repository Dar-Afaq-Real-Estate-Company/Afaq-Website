import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/account_types.dart';
import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../logic/cubit_cubit.dart';

/// حقل "تحديد نوع الحساب*" أعلى نموذج إنشاء الحساب — يفتح شيت الاختيار
class AccountTypeField extends StatefulWidget {
  const AccountTypeField({super.key});

  @override
  State<AccountTypeField> createState() => _AccountTypeFieldState();
}

class _AccountTypeFieldState extends State<AccountTypeField> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return ValueListenableBuilder<String>(
      valueListenable: cubit.accountTypeNotifier,
      builder: (context, current, _) => _build(context, AccountType.of(current)),
    );
  }

  Widget _build(BuildContext context, AccountTypeOption selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: AppStrings.getString('account_type_label', context.locale.languageCode),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF344054),
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ],
          ),
        ),
        verticalSpace(8),
        GestureDetector(
          onTap: _openSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE4E7EC)),
            ),
            child: Row(
              children: [
                Icon(Icons.keyboard_arrow_down,
                    size: 22.sp, color: const Color(0xFF667085)),
                const Spacer(),
                Text(
                  selected.title(context.locale.languageCode),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF101828),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openSheet() {
    final cubit = context.read<RegisterCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (sheetContext) {
        String temp = cubit.accountType;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 45.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    verticalSpace(16),
                    Text(
                      AppStrings.getString('select_user_type', context.locale.languageCode),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101828),
                      ),
                    ),
                    verticalSpace(14),
                    ...AccountType.options.map((option) {
                      final isSelected = temp == option.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: GestureDetector(
                          onTap: () {
                            setSheetState(() => temp = option.value);
                            cubit.accountType = option.value;
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 13.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFEF3F2)
                                  : const Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFF04438)
                                    : Colors.transparent,
                                width: 1.4,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 21.w,
                                  height: 21.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFF04438)
                                          : const Color(0xFFD0D5DD),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 11.w,
                                            height: 11.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFF04438),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                horizontalSpace(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        option.title(context.locale.languageCode),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF101828),
                                        ),
                                      ),
                                      verticalSpace(3),
                                      Text(
                                        option.subtitle(context.locale.languageCode),
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          color: const Color(0xFF98A2B3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                horizontalSpace(12),
                                Container(
                                  width: 38.w,
                                  height: 38.w,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFEE4E2)
                                        : const Color(0xFFEDEFF3),
                                    borderRadius: BorderRadius.circular(11.r),
                                  ),
                                  child: Icon(
                                    option.icon,
                                    size: 19.sp,
                                    color: isSelected
                                        ? const Color(0xFFF04438)
                                        : ColorManager.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
