import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helper/spacing.dart';
import '../../../../../core/resources/color_manager.dart';

/// يلف أي ويدجت بحركة دخول (تلاشي + انزلاق للأعلى) تبدأ بعد تأخير حسب
/// ترتيب العنصر - تستخدم لعرض شبكة "خدماتنا"/"الأقسام" بحركة متتالية
/// جذابة أول ما تفتح الصفحة، بدل ما تظهر جامدة كلها دفعة واحدة.
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration stepDelay;

  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.index,
    this.baseDelay = Duration.zero,
    this.stepDelay = const Duration(milliseconds: 60),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final delay = widget.baseDelay + widget.stepDelay * widget.index;
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

class CircularIconMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CircularIconMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 42.w,
                maxHeight: 42.w,
              ),
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorManager.primary : Colors.grey[300]!,
                  width: isSelected ? 2.2.w : 1.0.w,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isSelected ? ColorManager.primary : Colors.grey[700],
                  size: 22.sp,
                ),
              ),
            ),
            verticalSpace(6),
            SizedBox(
              width: 68.w,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11.sp,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة "خدماتنا" - شبكة 4 أعمدة، أيقونة خطية بدون خلفية ملونة
/// (مطابقة لتصميم Services Sections Redesign المعتمد)
class ServiceCardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const ServiceCardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorManager.primary, width: 2),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(color: ColorManager.primary.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Center(
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(icon, size: 17.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D2939),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة "الأقسام" - شبكة 3 أعمدة، أيقونة بيضاء داخل مربع بلون العلامة
/// (مطابقة لتصميم Services Sections Redesign المعتمد)
class SectionCardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const SectionCardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE7EAEC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: Icon(icon, size: 34.sp, color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF101828),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
