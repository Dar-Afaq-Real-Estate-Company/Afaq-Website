import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/subscription_gate_button.dart';
import '../../core/widgets/app_text_form_field.dart';
import '../../core/widgets/payment_webview_screen.dart';
import '../../core/widgets/publish_success_view.dart';
import '../../core/widgets/region_picker_sheet.dart';
import 'contracting_preview_view.dart';

/// نموذج "اضافة مقاولة" - مدفوع (نفس منطق نشر الوظيفة الشاغرة): تعبئة
/// بيانات ثم دفع مبلغ ثابت لنشر المقاولة.
/// === تعديل: منطقة + رقم تواصل مع خيار واتساب مختلف + نوع الحساب
/// (فرد/صنايعي بدون رخصة، أو شركة مقاولات برخصة تجارية إجبارية).
class AddContractingView extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const AddContractingView({super.key, this.initialData});

  @override
  State<AddContractingView> createState() => _AddContractingViewState();
}

class _AddContractingViewState extends State<AddContractingView> {
  bool get _isEditing => widget.initialData != null;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final bioController = TextEditingController();

  String? _selectedCategory;
  String? _selectedRegion;
  bool _differentWhatsapp = false;
  String _accountType = 'individual'; // individual | company
  File? _logoImage;
  PlatformFile? _licenseFile;
  final ImagePicker _picker = ImagePicker();
  bool _isFreeAccount = false;

  // TODO: سعر نشر المقاولة - عدّله حسب ما تحدد
  static const double price = 10.0;

  static const List<String> _regions = [
    'العاصمة', 'حولي', 'الفروانية', 'مبارك الكبير', 'الأحمدي', 'الجهراء',
  ];

  @override
  void initState() {
    super.initState();
    _checkUserType();
    if (widget.initialData != null) {
      _selectedCategory = widget.initialData!['category']?.toString();
      _selectedRegion = widget.initialData!['region']?.toString();
      nameController.text = widget.initialData!['name']?.toString() ?? '';
      phoneController.text = widget.initialData!['phone']?.toString() ?? '';
      final wa = widget.initialData!['whatsapp']?.toString() ?? '';
      if (wa.isNotEmpty) {
        _differentWhatsapp = true;
        whatsappController.text = wa;
      }
      _accountType = widget.initialData!['account_type']?.toString() ?? 'individual';
      licenseNumberController.text = widget.initialData!['license_number']?.toString() ?? '';
      bioController.text = widget.initialData!['bio']?.toString() ?? '';
    }
  }

  Future<void> _checkUserType() async {
    final type = await SharedPrefHelper.getUserType();
    if (mounted) setState(() => _isFreeAccount = type == '2');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    licenseNumberController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final newFile = File(image.path);
      if (mounted) {
        await FileImage(newFile).evict();
      }
      setState(() => _logoImage = newFile);
    }
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
    setState(() => _licenseFile = file);
  }

  Future<void> _openRegionPicker() async {
    final result = await showRegionPickerSheet(
      context,
      regions: _regions,
      current: _selectedRegion,
    );
    if (result != null) setState(() => _selectedRegion = result);
  }

  bool _isSubmitting = false;

  Future<void> _onPayPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع المقاولة')),
      );
      return;
    }
    if (_selectedRegion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار المنطقة')),
      );
      return;
    }
    if (_accountType == 'company' &&
        (licenseNumberController.text.trim().isEmpty ||
            (_licenseFile == null && !_isEditing))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم الرخصة ورفع ملفها')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));

      final formData = FormData.fromMap({
        'user_id': userId,
        'category': _selectedCategory,
        'region': _selectedRegion,
        'name': nameController.text,
        'phone': phoneController.text,
        if (_differentWhatsapp) 'whatsapp': whatsappController.text,
        'account_type': _accountType,
        if (_accountType == 'company') 'license_number': licenseNumberController.text,
        'bio': bioController.text,
        if (_logoImage != null)
          'logo': await MultipartFile.fromFile(_logoImage!.path),
        if (_licenseFile != null)
          'license_file': await MultipartFile.fromFile(_licenseFile!.path!),
      });

      final response = _isEditing
          ? await dio.post('contracting-listings/${widget.initialData!['id']}', data: formData, queryParameters: {'_method': 'PUT'})
          : await dio.post('contracting-listings', data: formData);
      final bool skipPayment = _isEditing ? true : response.data['skip_payment'] == true;
      final String? newId = response.data['data']?['id']?.toString();

      if (!mounted) return;

      if (skipPayment) {
        showPublishSuccessThenGoToMyAds(context, referenceNo: newId, title: _isEditing ? 'تم تحديث الإعلان، بانتظار المراجعة' : 'تم إرسال الطلب، بانتظار مراجعة الإدارة');
        return;
      }

      // TODO: مبلغ الدفع لسا رابط تجريبي ريثما يتحدد مزود الدفع (KNET)
      final paymentUrl = 'https://example-payment-gateway.com/pay'
          '?amount=$price&currency=KWD'
          '&name=${Uri.encodeComponent(nameController.text)}'
          '&phone=${Uri.encodeComponent(phoneController.text)}';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(
            url: paymentUrl,
            title: 'الدفع الإلكتروني',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const categories = [
      'الأقفال', 'مقاول صحي', 'تسليك مجاري', 'مكافحة الحشرات',
      'صيانة أجهزة منزلية', 'أعمال الديكور', 'أصباغ', 'التكييف',
      'نجار', 'حدادة', 'مقاول كهرباء', 'مشاتل وحدائق', 'فني زجاج',
      'عازل', 'ألمنيوم', 'كاشي وسيراميك', 'أعمال التهوية', 'مصاعد',
      'الأبواب', 'مقاولات بناء', 'مواد بناء', 'منتجات زراعية',
      'خزانات مياه', 'أخرى',
    ];

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(_isEditing ? 'تعديل المقاولة' : 'اضافة مقاولة'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickLogo,
                  child: Container(
                    width: 76.w,
                    height: 76.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade300),
                      image: _logoImage != null
                          ? DecorationImage(
                              image: FileImage(_logoImage!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _logoImage == null
                        ? Icon(Icons.add_a_photo_outlined,
                            color: ColorManager.grey, size: 24.sp)
                        : null,
                  ),
                ),
              ),
              verticalSpace(6),
              Text(
                'إضافة شعار (اختياري)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.sp, color: ColorManager.grey),
              ),
              verticalSpace(20),

              Text('نوع المقاولة *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  hintText: 'اختر نوع المقاولة',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
              verticalSpace(14),

              Text('المنطقة *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              GestureDetector(
                onTap: _openRegionPicker,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedRegion ?? 'اختر المنطقة',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _selectedRegion == null ? ColorManager.grey : Colors.black87,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              verticalSpace(14),

              Text('اسمك / اسم المؤسسة *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              AppTextFormField(
                controller: nameController,
                hintText: 'مثال: أبو محمد للنجارة',
                keyboardType: TextInputType.text,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'الرجاء ادخال الاسم' : null,
              ),
              verticalSpace(14),

              Text('رقم التواصل *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              AppTextFormField(
                controller: phoneController,
                hintText: '965xxxxxxxx',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'الرجاء ادخال رقم التواصل' : null,
              ),
              verticalSpace(10),
              InkWell(
                onTap: () => setState(() => _differentWhatsapp = !_differentWhatsapp),
                child: Row(
                  children: [
                    Icon(
                      _differentWhatsapp ? Icons.check_box : Icons.check_box_outline_blank,
                      color: _differentWhatsapp ? ColorManager.primary : ColorManager.grey,
                      size: 20.sp,
                    ),
                    horizontalSpace(8),
                    Expanded(
                      child: Text('رقم الواتساب مختلف عن رقم الاتصال',
                          style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF344054))),
                    ),
                  ],
                ),
              ),
              if (_differentWhatsapp) ...[
                verticalSpace(10),
                AppTextFormField(
                  controller: whatsappController,
                  hintText: 'رقم الواتساب',
                  keyboardType: TextInputType.phone,
                  validator: (v) => (_differentWhatsapp && (v == null || v.isEmpty))
                      ? 'الرجاء ادخال رقم الواتساب'
                      : null,
                ),
              ],
              verticalSpace(14),

              Text('نوع الحساب *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(8),
              Row(
                children: [
                  Expanded(child: _accountTypeChip('individual', 'فرد / صنايعي')),
                  horizontalSpace(8),
                  Expanded(child: _accountTypeChip('company', 'شركة مقاولات')),
                ],
              ),
              verticalSpace(14),

              if (_accountType == 'company') ...[
                Text('رقم الرخصة التجارية *',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                verticalSpace(6),
                AppTextFormField(
                  controller: licenseNumberController,
                  hintText: 'رقم الرخصة',
                  keyboardType: TextInputType.text,
                  validator: (v) => (_accountType == 'company' && (v == null || v.isEmpty))
                      ? 'الرجاء ادخال رقم الرخصة'
                      : null,
                ),
                verticalSpace(14),
                Text('ملف الرخصة التجارية *',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                verticalSpace(6),
                GestureDetector(
                  onTap: _pickLicenseFile,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: _licenseFile != null ? ColorManager.primary : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _licenseFile != null ? Icons.check_circle : Icons.upload_file,
                          size: 20.sp,
                          color: _licenseFile != null ? ColorManager.primary : ColorManager.grey,
                        ),
                        horizontalSpace(8),
                        Expanded(
                          child: Text(
                            _licenseFile?.name ?? 'اضغط لرفع ملف الرخصة (صورة أو PDF)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(14),
              ] else
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9F9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'لا حاجة لرقم رخصة أو ملف — ينشر مباشرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, color: ColorManager.grey),
                  ),
                ),
              verticalSpace(14),

              Text('نبذة عن أعمالك السابقة',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'اكتب عن خبرتك ونوع الأعمال اللي سويتها من قبل...',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              verticalSpace(28),

              SubscriptionGateButton(
                buttonText: _isSubmitting
                    ? 'جاري الإرسال...'
                    : (_isEditing
                        ? 'حفظ التعديل'
                        : (_isFreeAccount
                            ? 'إرسال بدون دفع'
                            : 'ادفع ${price.toStringAsFixed(0)} د.ك وانشر')),
                backgroundColor: ColorManager.black,
                buttonHeight: 52.h,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onPublish: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار نوع المقاولة')),
                    );
                    return;
                  }
                  if (_selectedRegion == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى اختيار المنطقة')),
                    );
                    return;
                  }
                  if (_accountType == 'company' &&
                      (licenseNumberController.text.trim().isEmpty ||
                          (_licenseFile == null && !_isEditing))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى إدخال رقم الرخصة ورفع ملفها')),
                    );
                    return;
                  }
                  if (_isEditing) {
                    _onPayPressed();
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContractingPreviewView(
                        logoPath: _logoImage?.path,
                        category: _selectedCategory!,
                        region: _selectedRegion!,
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                        onPublish: _onPayPressed,
                      ),
                    ),
                  );
                },
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountTypeChip(String value, String label) {
    final selected = _accountType == value;
    return GestureDetector(
      onTap: () => setState(() => _accountType = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ColorManager.primary : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: selected ? ColorManager.primary : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF667085),
            )),
      ),
    );
  }
}
