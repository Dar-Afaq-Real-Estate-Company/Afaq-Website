import 'dart:convert';
import 'dart:io';
import 'package:afaq_real_estate/core/resources/color_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/region_picker_sheet.dart';
import '../../../dashboard/data/response/response.dart';
import '../../../dashboard/logic/home_cubit.dart';
import '../../../dashboard/logic/home_state.dart';
import '../../../dashboard/ui/view/advertisements/widgets/add_ads/custom_decoration.dart';

/// صفحة تعديل الإعلان - صارت مطابقة تمامًا لحقول صفحة إضافة الإعلان
/// (عنوان، نوع، منطقة، غرف، حمامات، صالات، مطابخ، مساحة، عنوان تفصيلي،
/// سعر، وصف، صورة) بدل النسخة القديمة اللي كانت 4 حقول فقط.
class EditAdvertisementView extends StatefulWidget {
  final ShowUserAdvertisementData adData;
  const EditAdvertisementView({super.key, required this.adData});

  @override
  State<EditAdvertisementView> createState() => _EditAdvertisementViewState();
}

class _EditAdvertisementViewState extends State<EditAdvertisementView> {
  late UpdateAdCubit updateCubit;
  File? selectedImageFile;
  String? base64Image;
  Uint8List? imageRawBytes;

  // === تصنيفات العقار وأنواعه - نفس المصدر المستخدم بالإضافة والفلترة
  static const List<Map<String, dynamic>> _propertyCategories = [
    {
      'name': 'سكني',
      'types': [
        'شقة', 'بيت', 'دور', 'فيلا', 'عمارة', 'دوبلكس',
        'استوديو', 'أرض', 'بيت حكومي', 'سكن عمال', 'سرداب',
      ],
    },
    {
      'name': 'تجاري',
      'types': [
        'مكتب', 'محل', 'معرض', 'مخزن', 'مستودع', 'أرض تجارية',
        'شقة تجارية', 'دور تجاري', 'مجمع', 'مبنى تجاري', 'سرداب',
      ],
    },
    {
      'name': 'استثماري',
      'types': ['شقق استثمارية', 'عمارة استثمارية', 'أرض استثمارية', 'مجمع استثماري'],
    },
    {
      'name': 'صناعي',
      'types': ['مصنع', 'أرض صناعية', 'مستودع صناعي', 'ورشة'],
    },
  ];

  List<String> get _allTypes =>
      _propertyCategories.expand((c) => (c['types'] as List).cast<String>()).toList();

  String? _selectedType;
  String? _selectedRegion;

  bool get _isExchange =>
      (widget.adData.transactionType ?? '').contains('بدل');

  // === أنواع فيها أدوار (نفس منطق صفحة الإضافة)
  bool get _hasFloors {
    const withFloors = ['عمارة', 'بيت', 'فيلا', 'مبنى تجاري', 'مجمع', 'عمارة استثمارية'];
    return withFloors.contains(_selectedType);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        if (mounted) {
          setState(() {
            imageRawBytes = bytes;
            selectedImageFile = File(pickedFile.path);
            base64Image = "data:image/jpeg;base64,${base64Encode(bytes)}";
          });
        }
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    updateCubit = BlocProvider.of<UpdateAdCubit>(context);
    final ad = widget.adData;

    // === تعبئة كل الحقول ببيانات الإعلان الحالية
    updateCubit.titleController.text = ad.title ?? '';
    updateCubit.typeController.text = ad.type?.toString() ?? '';
    updateCubit.descriptionController.text = ad.description ?? '';
    updateCubit.priceController.text = ad.price?.toString() ?? '';
    updateCubit.regionController.text = ad.region ?? '';
    updateCubit.roomsController.text = ad.rooms?.toString() ?? '';
    updateCubit.bathroomsController.text = ad.bathrooms?.toString() ?? '';
    updateCubit.hallsController.text = ad.halls?.toString() ?? '';
    updateCubit.kitchensController.text = ad.kitchens?.toString() ?? '';
    updateCubit.areaController.text = ad.area?.toString() ?? '';
    updateCubit.addressController.text = ad.address ?? '';

    _selectedType = ad.type?.toString();
    _selectedRegion = ad.region;
    updateCubit.floorsCountController.text = ad.floorsCount?.toString() ?? '';

    // === تحميل قائمة المناطق مباشرة (نفس صفحة الإضافة) حتى يفتح
    // المنتقي جاهز بدل ما يطلع فاضي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AddAdvertisementCubit>().getRegions();
    });
  }

  Future<void> _openRegionPicker() async {
    final addCubit = context.read<AddAdvertisementCubit>();
    if (addCubit.regions.isEmpty) {
      addCubit.getRegions();
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (!mounted) return;
    final selected = await showRegionPickerSheet(
      context,
      regions: addCubit.regions,
      current: _selectedRegion,
    );
    if (selected != null) {
      setState(() {
        _selectedRegion = selected.isEmpty ? null : selected;
        updateCubit.regionController.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateAdCubit, UpdateAdState>(
      listener: (context, state) {
        state.whenOrNull(
          updateAdSuccess: (response) async {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.updateSuccess.tr()),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ShowUserAdCubit>().emitGetUserAds();
            Navigator.pop(context);
          },
          updateAdError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message ?? AppStrings.errorOccurred.tr())),
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.editAdTitle.tr(), style: StylesManager.font18BlackBold),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: updateCubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(AppStrings.adImage.tr()),
                    _buildImageSection(),
                    verticalSpace(20),

                    _buildLabel('عنوان الإعلان'),
                    AppTextFormField(
                      controller: updateCubit.titleController,
                      hintText: 'مثال: شقة فاخرة بحولي',
                      keyboardType: TextInputType.text,
                      validator: (v) => null,
                    ),
                    verticalSpace(16),

                    _buildLabel(AppStrings.propertyType.tr()),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedType ?? '',
                            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                          ),
                          Icon(Icons.lock_outline, size: 18.sp, color: Colors.grey),
                        ],
                      ),
                    ),
                    verticalSpace(16),

                    _buildLabel(AppStrings.region.tr()),
                    GestureDetector(
                      onTap: _openRegionPicker,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedRegion ?? AppStrings.chooseRegion.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: _selectedRegion == null ? Colors.grey : Colors.black87,
                              ),
                            ),
                            const Icon(Icons.location_on_outlined, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(16),

                    // === تفاصيل العقار - نفس حقول الإضافة
                    _buildLabel('تفاصيل العقار'),
                    Row(
                      children: [
                        Expanded(child: _numberField(updateCubit.roomsController, 'الغرف', 'عدد الغرف')),
                        horizontalSpace(10),
                        Expanded(child: _numberField(updateCubit.bathroomsController, 'الحمامات', 'عدد الحمامات')),
                      ],
                    ),
                    verticalSpace(12),
                    // === عدد الأدوار - يظهر فقط للعمارة/البيت/الفيلا (نفس منطق الإضافة)
                    if (_hasFloors) ...[
                      _numberField(updateCubit.floorsCountController, 'الأدوار', 'عدد الأدوار'),
                      verticalSpace(12),
                    ],
                    _numberField(updateCubit.areaController, 'المساحة', 'المساحة (م²)'),
                    verticalSpace(16),

                    // === السعر يختفي بإعلان البدل (نفس منطق الإضافة)
                    if (!_isExchange) ...[
                      _buildLabel(AppStrings.price.tr()),
                      AppTextFormField(
                        controller: updateCubit.priceController,
                        hintText: AppStrings.priceCurrencyHint.tr(),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? AppStrings.priceValidationError.tr() : null,
                      ),
                      verticalSpace(16),
                    ],

                    _buildLabel(AppStrings.adDescription.tr()),
                    TextFormField(
                      controller: updateCubit.descriptionController,
                      maxLines: 5,
                      maxLength: 250,
                      decoration: customDecoration(AppStrings.adDescriptionHint.tr()),
                      textAlign: TextAlign.right,
                    ),
                    verticalSpace(30),

                    AppTextButton(
                      buttonText: state is UpdateAdLoading
                          ? AppStrings.saving.tr()
                          : AppStrings.saveChanges.tr(),
                      textStyle: StylesManager.font16White,
                      onPressed: state is UpdateAdLoading
                          ? () {}
                          : () {
                              if (updateCubit.formKey.currentState!.validate()) {
                                updateCubit.emitUpdateAd(
                                  adId: widget.adData.id ?? 0,
                                  selectedPlanName: widget.adData.planName ?? "",
                                  transactionType: widget.adData.transactionType ?? "",
                                  imageBase64: base64Image,
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _numberField(TextEditingController controller, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)),
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: customDecoration(hint),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 180.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[300],
      ),
      child: InkWell(
        onTap: _pickImage,
        child: Stack(
          children: [
            if (imageRawBytes != null)
              Image.memory(
                imageRawBytes!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else if (widget.adData.images != null && widget.adData.images!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: widget.adData.images!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              )
            else
              const Center(child: Icon(Icons.add_a_photo, size: 40)),
            Positioned(
              bottom: 8,
              right: 8,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: ColorManager.primary,
                child: const Icon(Icons.edit, size: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
    );
  }
}
