import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../auth/data/models/response/response.dart';
import '../../../auth/logic/cubit_cubit.dart';
import '../../../auth/logic/cubit_state.dart';

class EditProfileView extends StatefulWidget {
  final UserInfoResponse? userData;

  const EditProfileView({super.key, this.userData});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _licenseNumberCtrl;
  late String _accountType;
  late final String _initialAccountType;
  String? _gender;
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  String? _pickedImageBase64;
  PlatformFile? _pickedLicenseFile;
  String? _pickedLicenseBase64;
  bool _nameLocked = true;
  bool _phoneLocked = true;
  bool _emailLocked = true;

  static const List<String> _licenseTypes = ['company', 'office'];

  static const Map<String, IconData> _typeIcons = {
    'seeker': Icons.person_outline,
    'company': Icons.business_outlined,
    'office': Icons.apartment_outlined,
    'broker': Icons.handshake_outlined,
  };

  String _typeLabel(BuildContext context, String key) {
    switch (key) {
      case 'seeker':
        return AppStrings.getString('acc_type_seeker_title', context.locale.languageCode);
      case 'company':
        return AppStrings.getString('acc_type_company_title', context.locale.languageCode);
      case 'office':
        return AppStrings.getString('acc_type_office_title', context.locale.languageCode);
      case 'broker':
        return AppStrings.getString('acc_type_broker_title', context.locale.languageCode);
      default:
        return key;
    }
  }

  bool get _isLicenseType => _licenseTypes.contains(_accountType);
  bool get _hasExistingLicense => (widget.userData?.user?.licenseFile ?? '').toString().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final user = widget.userData?.user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _licenseNumberCtrl = TextEditingController(text: user?.licenseNumber ?? '');
    final rawType = (user?.accountType ?? '').trim().toLowerCase();
    _accountType = _typeIcons.containsKey(rawType) ? rawType : 'seeker';
    _initialAccountType = _accountType;
    _gender = (user?.gender ?? '').trim().toLowerCase().isEmpty ? null : user!.gender!.trim().toLowerCase();
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image == null) return;
    final file = File(image.path);
    final bytes = await file.readAsBytes();
    setState(() {
      _pickedImage = file;
      _pickedImageBase64 = base64Encode(bytes);
    });
  }

  Future<void> _pickLicenseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result == null || result.files.single.path == null) return;
    final file = result.files.single;

    if (file.size > 5 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حجم الملف كبير، الحد الأقصى 5 ميجا')),
        );
      }
      return;
    }

    final bytes = await File(file.path!).readAsBytes();
    final ext = (file.extension ?? 'pdf').toLowerCase();
    final mime = ext == 'pdf' ? 'application/pdf' : 'image/$ext';

    setState(() {
      _pickedLicenseFile = file;
      _pickedLicenseBase64 = 'data:$mime;base64,${base64Encode(bytes)}';
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _licenseNumberCtrl.dispose();
    super.dispose();
  }

  void _openTypePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22.r))),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.75),
              child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(color: ColorManager.lighterGray, borderRadius: BorderRadius.circular(10.r)),
                ),
                verticalSpace(16),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(AppStrings.getString('account_type_label', context.locale.languageCode), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
                ),
                verticalSpace(10),
                ..._typeIcons.entries.map((e) {
                  final selected = e.key == _accountType;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        setState(() => _accountType = e.key);
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                        decoration: BoxDecoration(
                          color: selected ? ColorManager.primary.withOpacity(0.08) : const Color(0xFFF7F8F9),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: selected ? ColorManager.primary : Colors.transparent, width: 1.4),
                        ),
                        child: Row(
                          children: [
                            Icon(e.value,
                                size: 20.sp, color: selected ? ColorManager.primary : const Color(0xFF667085)),
                            horizontalSpace(12),
                            Expanded(
                              child: Text(_typeLabel(context, e.key),
                                  style: TextStyle(
                                      fontSize: 14.5.sp,
                                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                      color: selected ? ColorManager.primary : const Color(0xFF344054))),
                            ),
                            if (selected) Icon(Icons.check_circle_rounded, size: 20.sp, color: ColorManager.primary),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                verticalSpace(6),
              ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      body: BlocConsumer<UpdateUserInfoCubit, UpdateUserInfoState>(
        listener: (context, state) {
          state.maybeWhen(
            updateSuccess: (response) {
              final userId = widget.userData?.user?.id;
              if (userId != null) {
                try {
                  context.read<UserInfoCubit>().emitGetUserInfo(userId);
                } catch (e) {}
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  content: Text(AppStrings.profileUpdatedSuccess.tr()),
                ),
              );
              Navigator.pop(context, true);
            },
            updateInfoError: (apiErrorModel) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  content: Text(apiErrorModel.message ?? AppStrings.errorOccurred.tr()),
                  backgroundColor: Colors.red,
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final currentLogo = widget.userData?.user?.logo ?? '';
          final isLoading = state.maybeWhen(updateLoading: () => true, orElse: () => false);

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // === الهيدر: خلفية منحنية بلون الهوية + الصورة عائمة فوقها
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.78)],
                              ),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
                            ),
                            child: SafeArea(
                              bottom: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    ),
                                    Expanded(
                                      child: Text(
                                        AppStrings.editProfileTitle.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 16.5.sp, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    SizedBox(width: 48.w),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -46.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100.r,
                                      height: 100.r,
                                      padding: EdgeInsets.all(4.r),
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                      child: Container(
                                        decoration: BoxDecoration(color: ColorManager.lighterGray, shape: BoxShape.circle),
                                        clipBehavior: Clip.antiAlias,
                                        child: _pickedImage != null
                                            ? Image.file(_pickedImage!, fit: BoxFit.cover, width: 92.r, height: 92.r)
                                            : (currentLogo.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: currentLogo,
                                                    width: 92.r,
                                                    height: 92.r,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (_, __, ___) =>
                                                        Icon(Icons.person, size: 42.sp, color: ColorManager.grey),
                                                  )
                                                : Icon(Icons.person, size: 42.sp, color: ColorManager.grey)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2.h,
                                      right: 2.w,
                                      child: Container(
                                        padding: EdgeInsets.all(7.r),
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.5),
                                        ),
                                        child: Icon(Icons.camera_alt_rounded, size: 15.sp, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                      if ((_nameCtrl.text).isNotEmpty)
                        Center(
                          child: Text(_nameCtrl.text,
                              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939))),
                        ),
                      verticalSpace(28),

                      // === بطاقة الحقول
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 6)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.getString('personal_data_title', context.locale.languageCode),
                                  style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D2939))),
                              verticalSpace(16),
                              _field(
                                label: AppStrings.fullName.tr(),
                                icon: Icons.badge_outlined,
                                iconColor: const Color(0xFF7C3AED),
                                controller: _nameCtrl,
                                keyboardType: TextInputType.name,
                                locked: _nameLocked,
                                onToggleLock: () => setState(() => _nameLocked = !_nameLocked),
                                onLock: () => setState(() => _nameLocked = true),
                                onChanged: (_) => setState(() {}),
                                validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.nameRequired.tr() : null,
                              ),
                              verticalSpace(14),
                              _field(
                                label: AppStrings.phoneNumber.tr(),
                                icon: Icons.phone_outlined,
                                iconColor: const Color(0xFF12B76A),
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                locked: _phoneLocked,
                                onToggleLock: () => setState(() => _phoneLocked = !_phoneLocked),
                                onLock: () => setState(() => _phoneLocked = true),
                                validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.phoneRequired.tr() : null,
                              ),
                              verticalSpace(14),
                              _field(
                                label: AppStrings.email.tr(),
                                icon: Icons.email_outlined,
                                iconColor: const Color(0xFFE07A1F),
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                locked: _emailLocked,
                                onToggleLock: () => setState(() => _emailLocked = !_emailLocked),
                                onLock: () => setState(() => _emailLocked = true),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'البريد مطلوب';
                                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(v.trim())) return AppStrings.emailRequired.tr();
                                  return null;
                                },
                              ),
                              verticalSpace(14),
                              Row(
                                children: [
                                  Text(AppStrings.getString('gender_label', context.locale.languageCode),
                                      style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w600)),
                                ],
                              ),
                              verticalSpace(8),
                              Row(
                                children: [
                                  Expanded(child: _genderOption('male', AppStrings.getString('gender_male_short', context.locale.languageCode), Icons.male_rounded, const Color(0xFF1570CD))),
                                  horizontalSpace(10),
                                  Expanded(child: _genderOption('female', AppStrings.getString('gender_female_short', context.locale.languageCode), Icons.female_rounded, const Color(0xFFD6409F))),
                                ],
                              ),
                              verticalSpace(14),
                              Text(AppStrings.getString('account_type_label', context.locale.languageCode),
                                  style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w600)),
                              verticalSpace(8),
                              InkWell(
                                borderRadius: BorderRadius.circular(14.r),
                                onTap: _openTypePicker,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8F9),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(color: const Color(0xFFE4E7EC)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(_typeIcons[_accountType]!,
                                          size: 19.sp, color: ColorManager.primary),
                                      horizontalSpace(10),
                                      Expanded(
                                        child: Text(_typeLabel(context, _accountType),
                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1D2939))),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF98A2B3)),
                                    ],
                                  ),
                                ),
                              ),
                              // === خيار الرخصة العقارية: يظهر فقط لشركة/مكتب
                              if (_isLicenseType) ...[
                                verticalSpace(14),
                                Text(AppStrings.getString('license_number_label', context.locale.languageCode),
                                    style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w600)),
                                verticalSpace(8),
                                TextFormField(
                                  controller: _licenseNumberCtrl,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    hintText: AppStrings.getString('license_number_hint', context.locale.languageCode),
                                    filled: true,
                                    fillColor: const Color(0xFFF7F8F9),
                                    contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                      borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                      borderSide: BorderSide(color: ColorManager.primary, width: 1.6),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (_isLicenseType && (v == null || v.trim().isEmpty)) {
                                      return AppStrings.getString('license_number_required', context.locale.languageCode);
                                    }
                                    return null;
                                  },
                                ),
                                verticalSpace(14),
                                Text(AppStrings.getString('license_file_label', context.locale.languageCode),
                                    style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w600)),
                                verticalSpace(8),
                                GestureDetector(
                                  onTap: _pickLicenseFile,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F8F9),
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: (_pickedLicenseFile != null || _hasExistingLicense)
                                            ? ColorManager.primary
                                            : const Color(0xFFE4E7EC),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _pickedLicenseFile != null ? Icons.check_circle : Icons.upload_file,
                                          size: 20.sp,
                                          color: (_pickedLicenseFile != null || _hasExistingLicense)
                                              ? ColorManager.primary
                                              : const Color(0xFF98A2B3),
                                        ),
                                        horizontalSpace(10),
                                        Expanded(
                                          child: Text(
                                            _pickedLicenseFile?.name ??
                                                (_hasExistingLicense
                                                    ? AppStrings.getString('license_replace_hint', context.locale.languageCode)
                                                    : AppStrings.getString('license_file_hint', context.locale.languageCode)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF667085)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!_hasExistingLicense && _pickedLicenseFile == null) ...[
                                  verticalSpace(6),
                                  Text(AppStrings.getString('license_required_note', context.locale.languageCode),
                                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFFF04438))),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(24),
                    ],
                  ),
                ),

                // === زر الحفظ ثابت أسفل الشاشة
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -4))],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _validateAndSave(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
                              )
                            : Text('update_data_button'.tr(),
                                style: TextStyle(color: Colors.white, fontSize: 15.5.sp, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _genderOption(String value, String label, IconData icon, Color color) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: selected ? color : const Color(0xFFE4E7EC), width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19.sp, color: selected ? color : const Color(0xFF98A2B3)),
            horizontalSpace(8),
            Text(label, style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, color: selected ? color : const Color(0xFF667085))),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    Color? iconColor,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    required bool locked,
    required VoidCallback onToggleLock,
    required VoidCallback onLock,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF667085), fontWeight: FontWeight.w600)),
        verticalSpace(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                onChanged: onChanged,
                enabled: !locked,
                onTapOutside: (_) {
                  if (!locked) onLock();
                },
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: locked ? const Color(0xFF667085) : const Color(0xFF1D2939),
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, size: 20.sp, color: locked ? const Color(0xFF98A2B3) : (iconColor ?? const Color(0xFF98A2B3))),
                  filled: true,
                  fillColor: locked ? const Color(0xFFF7F8F9) : Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: ColorManager.primary, width: 1.6),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            horizontalSpace(8),
            GestureDetector(
              onTap: onToggleLock,
              child: Container(
                width: 36.w,
                height: 42.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: locked ? const Color(0xFFEAF1F1) : const Color(0xFFEAF7EF),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  locked ? Icons.edit_outlined : Icons.lock_open_rounded,
                  size: 15.sp,
                  color: locked ? ColorManager.primary : const Color(0xFF12B76A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _validateAndSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_isLicenseType && !_hasExistingLicense && _pickedLicenseFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.getString('license_required_note', context.locale.languageCode))),
        );
        return;
      }
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text('تأكيد التحديث', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp)),
          content: Text('هل أنت متأكد من البيانات المحدثة؟', style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('لا', style: TextStyle(color: const Color(0xFF667085))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<UpdateUserInfoCubit>().emitUpdateUserInfo(
                      fullName: _nameCtrl.text.trim(),
                      email: _emailCtrl.text.trim(),
                      phone: _phoneCtrl.text.trim(),
                      accountType: _accountType,
                      gender: _gender,
                      logoBase64: _pickedImageBase64,
                      licenseNumber: _isLicenseType ? _licenseNumberCtrl.text.trim() : null,
                      licenseFile: _pickedLicenseBase64,
                    );
              },
              child: Text('نعم', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }
}
