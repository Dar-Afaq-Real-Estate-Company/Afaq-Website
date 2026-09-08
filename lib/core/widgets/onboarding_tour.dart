import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_manager.dart';

class _OnboardingStep {
  final String title;
  final String body;
  final IconData icon;
  const _OnboardingStep({required this.title, required this.body, required this.icon});
}

const List<_OnboardingStep> _steps = [
  _OnboardingStep(
    title: 'أهلاً بك في آفاق!',
    body: 'تطبيق آفاق العقاري يجمع لك كل ما يخص العقار في الكويت بمكان واحد. خلنا نتعرف بسرعة على أهم أقسام التطبيق.',
    icon: Icons.waving_hand_rounded,
  ),
  _OnboardingStep(
    title: 'إضافة إعلان',
    body: 'من أيقونة "➕ إضافة إعلان" تقدر تعرض عقارك، تسجّل نفسك كمقاول، تنشر وظيفة، أو تضيف شركتك العقارية، مكتبك الهندسي، أو حتى فندقك وشقتك المفروشة.',
    icon: Icons.add_circle_outline,
  ),
  _OnboardingStep(
    title: 'العقارات',
    body: 'تصفح العقارات المتاحة للبيع، الإيجار، أو البدل بكل سهولة.',
    icon: Icons.home_work_outlined,
  ),
  _OnboardingStep(
    title: 'إدارة الأملاك',
    body: 'خدمة متكاملة لإدارة عقاراتك بالكامل نيابةً عنك.',
    icon: Icons.apartment_outlined,
  ),
  _OnboardingStep(
    title: 'التقييم العقاري',
    body: 'اطلب تقييمًا رسميًا لعقارك من مختصين معتمدين.',
    icon: Icons.fact_check_outlined,
  ),
  _OnboardingStep(
    title: 'حساب تكلفة البناء',
    body: 'قدّر تكلفة بناء عقارك بشكل سريع ودقيق.',
    icon: Icons.calculate_outlined,
  ),
  _OnboardingStep(
    title: 'الاستشارة العقارية',
    body: 'احصل على استشارة من خبراء عقاريين قبل أي قرار مهم.',
    icon: Icons.support_agent_outlined,
  ),
  _OnboardingStep(
    title: 'قسم العقار',
    body: 'استعرض كل التصنيفات العقارية: سكني، تجاري، استثماري، وصناعي.',
    icon: Icons.villa_outlined,
  ),
  _OnboardingStep(
    title: 'المقاولات',
    body: 'تواصل مع مقاولين موثوقين لتنفيذ مشروعك.',
    icon: Icons.engineering_outlined,
  ),
  _OnboardingStep(
    title: 'الوظائف',
    body: 'تصفح الوظائف الشاغرة أو أعلن أنك تبحث عن عمل.',
    icon: Icons.work_outline,
  ),
  _OnboardingStep(
    title: 'الشركات والمكاتب الهندسية',
    body: 'تعرّف على أفضل الشركات العقارية والمكاتب الهندسية في الكويت.',
    icon: Icons.business_outlined,
  ),
  _OnboardingStep(
    title: 'الفنادق',
    body: 'استعرض واحجز الفنادق بسهولة.',
    icon: Icons.hotel_outlined,
  ),
  _OnboardingStep(
    title: 'أهلاً وسهلاً بك في آفاق',
    body: 'خيارك العقاري الأول في الكويت.',
    icon: Icons.emoji_events_outlined,
  ),
];

/// شخصية "آفاق" الكرتونية - أيقونة دائرية متحركة بأعلى البطاقة
class _Mascot extends StatelessWidget {
  final IconData icon;
  const _Mascot({required this.icon});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(icon),
      tween: Tween(begin: 0.7, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 92.w,
        height: 92.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: ColorManager.primary.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 44.sp),
      ),
    );
  }
}

/// عرض جولة الترحيب - Dialog كامل الشاشة تقريبًا مع مؤشر خطوات، Next/تخطي
Future<void> showOnboardingTour(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, _, __) => const _OnboardingTourDialog(),
    transitionBuilder: (context, animation, __, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: Tween(begin: 0.85, end: 1.0).animate(curved), child: child),
      );
    },
  );
}

class _OnboardingTourDialog extends StatefulWidget {
  const _OnboardingTourDialog();

  @override
  State<_OnboardingTourDialog> createState() => _OnboardingTourDialogState();
}

class _OnboardingTourDialogState extends State<_OnboardingTourDialog> {
  int _index = 0;

  void _next() {
    if (_index == _steps.length - 1) {
      Navigator.of(context).pop();
    } else {
      setState(() => _index++);
    }
  }

  void _skip() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final step = _steps[_index];
    final bool isLast = _index == _steps.length - 1;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Mascot(icon: step.icon),
              verticalSpaceOnboarding(18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey(_index),
                  children: [
                    Text(
                      step.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    verticalSpaceOnboarding(10),
                    Text(
                      step.body,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5.sp, color: Colors.grey[600], height: 1.6),
                    ),
                  ],
                ),
              ),
              verticalSpaceOnboarding(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) {
                  final bool active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: active ? 16.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: active ? ColorManager.primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                }),
              ),
              verticalSpaceOnboarding(24),
              Row(
                children: [
                  if (!isLast)
                    Expanded(
                      child: TextButton(
                        onPressed: _skip,
                        child: Text('تخطي', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                      ),
                    ),
                  Expanded(
                    flex: isLast ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                      child: Text(
                        isLast ? 'ابدأ الآن' : 'التالي',
                        style: TextStyle(color: Colors.white, fontSize: 14.5.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget verticalSpaceOnboarding(double h) => SizedBox(height: h.h);
