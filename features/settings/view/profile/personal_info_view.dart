import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/account_types.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../auth/data/models/response/response.dart';

/// صفحة "المعلومات الشخصية" - عرض فقط، تُفتح من زر ✎ أعلى البروفايل.
/// فيها زر "تعديل المعلومات" بالأسفل يفتح شاشة التعديل الفعلية.
class PersonalInfoView extends StatelessWidget {
  final Map<String, dynamic> user;

  const PersonalInfoView({super.key, required this.user});

  String get _name => (user['name'] ?? '').toString();
  String get _gender => (user['Gender'] ?? user['gender'] ?? '').toString();
  bool get _verified => (user['email_verified_at'] ?? '').toString().isNotEmpty;
  String get _accountType => (user['account_type'] ?? AccountType.seeker).toString();

  Map<String, String> _typeLabels(BuildContext context) => {
        for (final o in AccountType.options) o.value: o.title(context.locale.languageCode),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 46.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26.r)),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 22.sp),
                  ),
                  const Spacer(),
                  Text(AppStrings.getString('personal_info_title', context.locale.languageCode),
                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  SizedBox(width: 22.sp),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -34.h),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 112.w,
                      height: 112.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1F1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (user['logo'] ?? '').toString().isNotEmpty
                          ? CachedNetworkImage(imageUrl: user['logo'].toString(), fit: BoxFit.cover)
                          : Center(
                              child: Text(
                                _name.trim().isEmpty ? '؟' : _name.trim()[0],
                                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w900, color: ColorManager.primary),
                              ),
                            ),
                    ),
                    if (_gender == 'male' || _gender == 'female')
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _gender == 'male' ? const Color(0xFF4F8FE0) : const Color(0xFFE8639A),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Text(_gender == 'male' ? '♂' : '♀',
                              style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
                verticalSpace(10),
                Text(_name.isEmpty ? 'مستخدم' : _name,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939))),
                verticalSpace(6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _verified ? const Color(0xFFEAF7EF) : const Color(0xFFFEF3F2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_verified ? Icons.check_circle : Icons.error_outline,
                        size: 12.sp, color: _verified ? const Color(0xFF12B76A) : const Color(0xFFF04438)),
                    SizedBox(width: 4.w),
                    Text(_verified
                            ? AppStrings.getString('email_verified_badge', context.locale.languageCode)
                            : AppStrings.getString('email_not_verified_badge', context.locale.languageCode),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: _verified ? const Color(0xFF12B76A) : const Color(0xFFF04438),
                        )),
                  ]),
                ),
                verticalSpace(20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        _infoRow(Icons.phone_outlined, AppStrings.getString('mobile_number_label', context.locale.languageCode), (user['phone'] ?? '').toString()),
                        _divider(),
                        _infoRow(Icons.email_outlined, AppStrings.getString('email_label_field', context.locale.languageCode), (user['email'] ?? '').toString()),
                        _divider(),
                        _infoRow(Icons.badge_outlined, AppStrings.getString('account_type_label', context.locale.languageCode), _typeLabels(context)[_accountType] ?? 'فرد'),
                      ],
                    ),
                  ),
                ),
                verticalSpace(20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: GestureDetector(
                    onTap: () async {
                      final userResponse = UserResponse(
                        id: int.tryParse('${user['id'] ?? ''}'),
                        name: _name,
                        phone: (user['phone'] ?? '').toString(),
                        email: (user['email'] ?? '').toString(),
                        logo: (user['logo'] ?? '').toString(),
                        accountType: _accountType,
                        gender: _gender.isEmpty ? null : _gender,
                      );
                      final didUpdate = await Navigator.pushNamed(
                        context,
                        Routes.editProfileRoute,
                        arguments: EditProfileArgs(userData: UserInfoResponse(user: userResponse)),
                      );
                      if (didUpdate == true && context.mounted) Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)]),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      alignment: Alignment.center,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.edit_outlined, size: 16.sp, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(AppStrings.getString('edit_info_button', context.locale.languageCode),
                            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Divider(height: 1, color: const Color(0xFFF0F2F1)),
      );

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, size: 16.sp, color: ColorManager.primary),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.sp, color: const Color(0xFF98A2B3))),
              SizedBox(height: 2.h),
              Text(value.isEmpty ? '—' : value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1D2939))),
            ],
          ),
        ],
      ),
    );
  }
}
