import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/helper/constants.dart';
import '../../core/helper/shared_pref.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/color_manager.dart';
import '../../core/widgets/app_text_button.dart';
import '../../core/widgets/subscription_gate_button.dart';
import '../../core/widgets/app_text_form_field.dart';
import '../../core/widgets/payment_webview_screen.dart';

/// نموذج "اضافة مكتب هندسي" - نفس منطق "اضافة مقاولة" بالضبط: تعبئة بيانات
/// ثم دفع مبلغ ثابت لنشر المكتب. حسابات user_type = 2 تنشر مجانًا مباشرة
/// (التحقق الفعلي من الباك اند، مو من التطبيق).
class AddEngineeringOfficeView extends StatefulWidget {
  const AddEngineeringOfficeView({super.key});

  @override
  State<AddEngineeringOfficeView> createState() => _AddEngineeringOfficeViewState();
}

class _AddEngineeringOfficeViewState extends State<AddEngineeringOfficeView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mottoController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  String? _selectedSpecialty;
  File? _logoImage;
  int _logoVersion = 0;
  final ImagePicker _picker = ImagePicker();
  bool _isFreeAccount = false;
  bool _isSubmitting = false;

  // TODO: سعر نشر المكتب - عدّله حسب ما تحدد
  static const double price = 15.0;

  static const List<String> _specialties = [
    'هندسة معمارية',
    'هندسة إنشائية',
    'هندسة كهروميكانيكية',
    'إشراف هندسي',
    'تصميم داخلي',
    'استشارات هندسية',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final type = await SharedPrefHelper.getUserType();
    if (mounted) setState(() => _isFreeAccount = type == '2');
  }

  @override
  void dispose() {
    nameController.dispose();
    mottoController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final newFile = File(image.path);
      // === مهم: image_picker بأندرويد أحيانًا يعيد نفس مسار الملف
      // المؤقت، وFileImage يخزّن بالكاش حسب المسار بس - نلغي الكاش
      // القديم + نزيد عداد نسخة (Key) عشان نضمن 100% إن الويدجت
      // يتحدث ويعرض الصورة الجديدة فورًا
      if (mounted) {
        await FileImage(newFile).evict();
      }
      setState(() {
        _logoImage = newFile;
        _logoVersion++;
      });
    }
  }

  Future<void> _onSubmitPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedSpecialty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تخصص المكتب')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      final dio = Dio(BaseOptions(
        baseUrl: 'https://api.afaq.group/api/',
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'AfaqApp/1.0 (Flutter)',
        },
      ));

      // === تعديل: نرسل الشعار كـ Base64 داخل JSON عادي بدل رفع ملف
      // (multipart) - نفس طريقة نظام الإعلانات القديم عندكم بالضبط،
      // لأن جدار حماية السيرفر يحجب رفع الملفات المباشر (406) لكنه
      // ما يحجب نص Base64 عادي
      String? logoBase64;
      if (_logoImage != null) {
        final bytes = await _logoImage!.readAsBytes();
        logoBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      final response = await dio.post('engineering-offices', data: {
        'user_id': userId,
        'name': nameController.text,
        'motto': mottoController.text,
        'specialty': _selectedSpecialty,
        'phone': phoneController.text,
        'description': descriptionController.text,
        'logo_base64': logoBase64,
      });
      final bool isPublished = response.data['data']?['status'] == 1;

      if (!mounted) return;

      if (isPublished) {
        // === الباك اند تأكد إن الحساب type=2 ونشر مباشرة بدون دفع
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم نشر المكتب بنجاح')),
        );
        Navigator.pop(context, true);
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
      // === مؤقت للتشخيص: نطلع تفاصيل الخطأ الحقيقي بدل رسالة عامة
      String details = e.toString();
      if (e is DioException) {
        details = 'كود: ${e.response?.statusCode} - ${e.response?.data ?? e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $details'), duration: const Duration(seconds: 8)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('اضافة مكتب هندسي'),
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
                    key: ValueKey(_logoVersion),
                    width: 80.w,
                    height: 80.w,
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
                            color: ColorManager.grey, size: 26.sp)
                        : null,
                  ),
                ),
              ),
              verticalSpace(6),
              Text(
                'شعار المكتب (اختياري)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.sp, color: ColorManager.grey),
              ),
              verticalSpace(20),

              Text('اسم المكتب *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              AppTextFormField(
                controller: nameController,
                hintText: 'مثال: مكتب آفاق الهندسي',
                keyboardType: TextInputType.text,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'الرجاء ادخال اسم المكتب' : null,
              ),
              verticalSpace(14),

              Text('الشعار (Motto)',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              AppTextFormField(
                controller: mottoController,
                hintText: 'مثال: نبني وطن أجمل',
                keyboardType: TextInputType.text,
                validator: (_) => null,
              ),
              verticalSpace(14),

              Text('تخصص المكتب *',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                decoration: InputDecoration(
                  hintText: 'اختر تخصص المكتب',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: _specialties
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSpecialty = v),
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
              verticalSpace(14),

              Text('شرح للمكتب / نبذة عنه',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              verticalSpace(6),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'اكتب نبذة عن المكتب وتخصصه...',
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
                    : (_isFreeAccount
                        ? 'نشر مباشر'
                        : 'ادفع ${price.toStringAsFixed(0)} د.ك وانشر'),
                backgroundColor: ColorManager.black,
                buttonHeight: 52.h,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onPublish: _onSubmitPressed,
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
