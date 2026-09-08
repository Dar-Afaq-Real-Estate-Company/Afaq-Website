import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/account_types.dart';
import '../../../../../../core/helper/spacing.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../../../../../core/widgets/app_text_form_field.dart';
import '../../../../logic/cubit_cubit.dart';

/// رفع ملف الرخصة العقارية — يظهر لحساب "مكتب عقاري" أو "شركة عقارية"
class LicenseUploadField extends StatefulWidget {
  const LicenseUploadField({super.key});

  @override
  State<LicenseUploadField> createState() => _LicenseUploadFieldState();
}

class _LicenseUploadFieldState extends State<LicenseUploadField> {
  PlatformFile? _picked;

  bool _requiresLicense(String accountType) =>
      accountType == AccountType.office || accountType == AccountType.company;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return ValueListenableBuilder<String>(
      valueListenable: cubit.accountTypeNotifier,
      builder: (context, accountType, _) {
        // يظهر للمكتب العقاري والشركة العقارية فقط
        if (!_requiresLicense(accountType)) {
          return const SizedBox.shrink();
        }
        return _buildFields(context, cubit);
      },
    );
  }

  Widget _buildFields(BuildContext context, RegisterCubit cubit) {
    final lang = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(18),
        _label(AppStrings.getString('license_number_label', lang), required: true),
        AppTextFormField(
          hintText: AppStrings.getString('license_number_hint', lang),
          keyboardType: TextInputType.text,
          controller: cubit.licenseNumberController,
          validator: (value) {
            if (_requiresLicense(cubit.accountType) &&
                (value == null || value.isEmpty)) {
              return AppStrings.getString('license_number_required', lang);
            }
            return null;
          },
        ),
        verticalSpace(18),
        _label(AppStrings.getString('license_file_label', lang), required: true),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: _picked != null
                    ? ColorManager.primary
                    : const Color(0xFFE4E7EC),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _picked != null ? Icons.check_circle : Icons.upload_file,
                  size: 21.sp,
                  color: _picked != null
                      ? ColorManager.primary
                      : const Color(0xFF667085),
                ),
                horizontalSpace(10),
                Expanded(
                  child: Text(
                    _picked?.name ?? AppStrings.getString('license_file_hint', lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight:
                          _picked != null ? FontWeight.w600 : FontWeight.w400,
                      color: _picked != null
                          ? const Color(0xFF101828)
                          : const Color(0xFF98A2B3),
                    ),
                  ),
                ),
                if (_picked != null)
                  GestureDetector(
                    onTap: () => setState(() {
                      _picked = null;
                      cubit.licenseBase64 = null;
                    }),
                    child: Icon(Icons.close,
                        size: 18.sp, color: const Color(0xFFF04438)),
                  ),
              ],
            ),
          ),
        ),
        verticalSpace(6),
        Text(
          AppStrings.getString('license_review_note', lang),
          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF98A2B3)),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final lang = context.locale.languageCode;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result == null || result.files.single.path == null) return;

    final file = result.files.single;

    // حد أقصى 5 ميجا
    if ((file.size) > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.getString('license_file_too_large', lang))),
        );
      }
      return;
    }

    final bytes = await File(file.path!).readAsBytes();
    final ext = (file.extension ?? 'pdf').toLowerCase();
    final mime = ext == 'pdf' ? 'application/pdf' : 'image/$ext';

    if (!mounted) return;
    setState(() {
      _picked = file;
      context.read<RegisterCubit>().licenseBase64 =
          'data:$mime;base64,${base64Encode(bytes)}';
    });
  }

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
