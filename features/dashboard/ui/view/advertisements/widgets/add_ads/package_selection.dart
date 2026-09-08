import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/di/di.dart';
import '../../../../../../../core/helper/extensions.dart';
import '../../../../../../../core/helper/shared_pref.dart';
import '../../../../../../../core/helper/spacing.dart';
import '../../../../../../../core/resources/color_manager.dart';
import '../../../../../logic/home_cubit.dart';
import '../../view/add_ads/add_ads_view.dart';
import '../../../../../../contracting/add_contracting_view.dart';
import '../../../../../../jobs/job_vacancy_view.dart';
import '../../../../../../hotels/ui/add_hotel_view.dart';

/// === شاشة "إضافة إعلان" الجديدة كليًا: قائمة أقسام أنيقة تفتح صفحة
/// الإضافة الخاصة بكل قسم مباشرة (بدون أي شاشة استعراض بالنص)، بحركة
/// دخول متتالية (fade + slide + scale) وانتقال صفحة مخصص عند الفتح.
class PackageSelection extends StatefulWidget {
  const PackageSelection({super.key});

  @override
  State<PackageSelection> createState() => _PackageSelectionState();
}

class _AddCategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final Widget Function() pageBuilder;

  const _AddCategoryItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.pageBuilder,
  });
}

class _PackageSelectionState extends State<PackageSelection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isAdmin = false;

  late final List<_AddCategoryItem> _baseItems = [
    _AddCategoryItem(
      label: 'عقار',
      icon: Icons.home_work_outlined,
      color: const Color(0xFF2F6F68),
      pageBuilder: () => BlocProvider(
        create: (_) => di<AddAdvertisementCubit>(),
        child: const AddAdsView(),
      ),
    ),
    _AddCategoryItem(
      label: 'مقاول',
      icon: Icons.engineering_outlined,
      color: const Color(0xFFB4622B),
      pageBuilder: () => const AddContractingView(),
    ),
    _AddCategoryItem(
      label: 'وظيفة',
      icon: Icons.work_outline,
      color: const Color(0xFF3B5BA9),
      pageBuilder: () => const JobVacancyView(),
    ),
    _AddCategoryItem(
      label: 'الفنادق',
      icon: Icons.hotel_outlined,
      color: const Color(0xFFC2185B),
      pageBuilder: () => const AddHotelView(),
    ),
  ];

  // === خيار إداري فقط (userType == '2') - ينشر إعلان عقار يظهر بشريط
  // "العروض المميزة" الأفقي بالصفحة الرئيسية، بنفس صفحة إضافة العقار
  static final _AddCategoryItem _featuredItem = _AddCategoryItem(
    label: 'المشاريع المميزة',
    icon: Icons.star_rounded,
    color: const Color(0xFFB7791F),
    pageBuilder: () => BlocProvider(
      create: (_) => di<AddAdvertisementCubit>(),
      child: const AddAdsView(isFeatured: true),
    ),
  );

  List<_AddCategoryItem> get _items {
    final list = [..._baseItems];
    if (_isAdmin) list.insert(1, _featuredItem);
    return list;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final type = await SharedPrefHelper.getUserType();
    if (mounted) setState(() => _isAdmin = type == '2');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(_AddCategoryItem item) {
    AuthGuard.runAction(context, onAuthenticated: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 480),
          reverseTransitionDuration: const Duration(milliseconds: 380),
          pageBuilder: (context, animation, secondaryAnimation) => item.pageBuilder(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.97, end: 1).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أضف',
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            verticalSpace(4),
            Text(
              'اختر القسم اللي تبي تنشر إعلانك فيه',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
            verticalSpace(28),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (_, __) => verticalSpace(14),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final animation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (index / _items.length) * 0.6,
                      1.0,
                      curve: Curves.easeOutCubic,
                    ),
                  );
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(animation),
                      child: _AddCategoryCard(item: item, onTap: () => _open(item)),
                    ),
                  );
                },
              ),
            ),
            verticalSpace(90),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryCard extends StatefulWidget {
  final _AddCategoryItem item;
  final VoidCallback onTap;

  const _AddCategoryCard({required this.item, required this.onTap});

  @override
  State<_AddCategoryCard> createState() => _AddCategoryCardState();
}

class _AddCategoryCardState extends State<_AddCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(item.icon, color: item.color, size: 26.sp),
              ),
              horizontalSpace(14),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: ColorManager.lighterGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
