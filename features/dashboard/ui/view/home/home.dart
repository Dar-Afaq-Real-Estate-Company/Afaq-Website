import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/widgets/search_widget.dart';
import '../../../logic/home_cubit.dart';
import '../../widgets/category/category_list_view.dart';
import '../../widgets/sections/section_services.dart';
import '../../widgets/category/category_items_widget.dart';
// === جديد: قسم الشركاء الأكثر ثقة
import '../../widgets/trusted_partners_section.dart';
import '../../widgets/home_banner_carousel.dart';
// === جديد: قسم أحدث الإعلانات (تحت المميزة مباشرة)
import 'latest_ads_bloc_builder.dart';
import '../../widgets/latest_offers_section.dart';
import '../../widgets/trusted_agents_section.dart';
import 'home_bloc_builder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // === جديد: مفتاح لقسم "أحدث الإعلانات" عشان نقدر نسكرول له تلقائياً
  final GlobalKey _latestAdsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          verticalSpace(20),
          const HomeBannerCarousel(),
          verticalSpace(16),
          SearchWidget(
            context,
            onTap: () {
              context.read<NavigationCubit>().changeIndex(1);
            },
          ),
          verticalSpace(10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.ourServices.tr(), icon: Icons.miscellaneous_services_rounded, iconColor: const Color(0xFFB0B0B0)),
          ),
          const CategoryListView(),
          // verticalSpace(10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.sections.tr(), icon: Icons.dashboard_rounded, iconColor: const Color(0xFFE8A33D)),
          ),
          BlocProvider(
            create: (context) => di<FilterSctionCubit>(),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sectionServicesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                mainAxisExtent: 118,
              ),
              itemBuilder: (BuildContext context, int index) {
                final sectionItem = sectionServicesList[index];
                return StaggeredEntrance(
                  index: index + 6,
                  child: Center(
                    child: buildSectionItem(
                      context,
                      sectionServicesList[index],
                      sectionItem.subCategories,
                    ),
                  ),
                );
              },
            ),
          ),
          verticalSpace(10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.featuredAds.tr(), icon: Icons.workspace_premium_rounded, iconColor: const Color(0xFFFFC93C)),
          ),
          const HomeBlocBuilder(),

          // === جديد: قسم "أحدث الإعلانات" - تحت المميزة مباشرة، بطاقات
          // أفقية بصورة كبيرة، مرتبة الأحدث أولاً (الباك اند يرتبها latest() أصلاً)
          verticalSpace(16),
          Padding(
            key: _latestAdsKey,
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.latestAds.tr(), icon: Icons.campaign_rounded, iconColor: const Color(0xFFE8622C)),
          ),
          const LatestAdsBlocBuilder(),

          // === جديد: "أحدث العروض" - آخر ما نُشر بكل التطبيق (عقار/وظائف/مقاولين/فنادق)
          verticalSpace(16),
          const LatestOffersSection(),

          // === قسم "الشركاء الأكثر ثقة"
          verticalSpace(16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.trustedPartners.tr(), icon: Icons.verified_rounded, iconColor: const Color(0xFF12B76A)),
          ),
          const TrustedPartnersSection(),

          // === قسم "الوكلاء الأكثر ثقة"
          verticalSpace(16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: _sectionTitle(AppStrings.trustedAgents.tr(), icon: Icons.support_agent_rounded, iconColor: const Color(0xFF2E7CB8)),
          ),
          const TrustedAgentsSection(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {IconData? icon, Color? iconColor}) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        horizontalSpace(8),
        if (icon != null) ...[
          Icon(icon, size: 18.sp, color: iconColor ?? ColorManager.primary),
          horizontalSpace(6),
        ],
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17.sp,
            color: const Color(0xFF101828),
          ),
        ),
      ],
    );
  }
}
