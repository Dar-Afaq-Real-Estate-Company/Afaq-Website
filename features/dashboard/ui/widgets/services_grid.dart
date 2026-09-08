import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/di.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../hotels/ui/hotels_list_view.dart';
import '../../logic/home_cubit.dart';
import '../view/advertisements/view/ads_result_section/ads_result_section_view.dart';

class AnimatedSheetContent extends StatefulWidget {
  final String title;
  final List<SubCategoryModel> subCategories;

  const AnimatedSheetContent({
    super.key,
    required this.title,
    required this.subCategories,
  });

  @override
  State<AnimatedSheetContent> createState() => _AnimatedSheetContentState();
}

class _AnimatedSheetContentState extends State<AnimatedSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward(); // تشغيل الأنميشن فور الفتح
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              verticalSpace(20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.black,
                ),
              ),
              verticalSpace(20),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.subCategories.length,
                  separatorBuilder: (context, index) => verticalSpace(12),
                  itemBuilder: (context, index) {
                    return _optionRow(context, widget.subCategories[index]);
                  },
                ),
              ),
              verticalSpace(25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionRow(BuildContext context, SubCategoryModel sub) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        onTap: () {
          // === جديد: حالة خاصة لقسم "الفنادق" - نوديه لشاشة الاستعراض
          // المخصصة (جدول hotels_apartments منفصل كلياً عن جدول الإعلانات
          // العادي advertisement)، بدل الشاشة العامة اللي ما راح تلقى فيها شي
          if (widget.title == AppStrings.hotels.tr()) {
            Navigator.pop(context); // إغلاق النافذة
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HotelsListView()),
            );
            return;
          }

          final FilterSctionCubit cubitInstance =
              BlocProvider.of<FilterSctionCubit>(context);
          Navigator.pop(context); // إغلاق النافذة
          context.read<FilterSctionCubit>().getfilterSection(
                section: widget.title,
                type: sub.title,
              );
          if (sub.routeName != null) {
            Navigator.pushNamed(context, sub.routeName!,
                arguments: sub.arguments);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubitInstance,
                child: const AdsResultSectionView(),
              ),
            ),
          );
        },
        // الأيقونة الجانبية للقسم
        trailing: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(sub.icon, color: ColorManager.primary, size: 18.sp),
          ),
        ),
        // عنوان القسم الفرعي
        title: Text(
          sub.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // سهم الانتقال (يتغير اتجاهه حسب اللغة)
        leading: Icon(
          Icons.arrow_back_ios_new,
          size: 14.sp,
          color: Colors.black26,
        ),
      ),
    );
  }
}

class SubCategoryModel {
  final String title; // عنوان القسم الفرعي (مثلاً: تصميم معماري)
  final IconData icon; // الأيقونة الخاصة به
  final String? routeName; // اسم الصفحة التي سيتم الانتقال إليها (Route Name)
  final dynamic
      arguments; // أي بيانات تريد إرسالها للصفحة التالية (مثل ID القسم)

  SubCategoryModel({
    required this.title,
    required this.icon,
    this.routeName,
    this.arguments,
  });
}

void showAnimatedOptions(
    BuildContext context, String title, List<SubCategoryModel> options) {
  final filterCubit = context.read<FilterSctionCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return BlocProvider.value(
        value: filterCubit,
        child: AnimatedSheetContent(
          title: title,
          subCategories: options,
        ),
      );
    },
  );
}
