import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_manager.dart';
import '../helper/onboarding_keys.dart';

class _TourStep {
  final String title;
  final String body;
  final IconData icon;
  final GlobalKey? targetKey;
  // لو العنصر داخل PageView صفحات (خدماتنا/الأقسام)، نحدد رقم الصفحة
  // والكونترولر حتى ننتقل لها قبل تسليط الضوء
  final PageController? pageController;
  final int? pageIndex;

  const _TourStep({
    required this.title,
    required this.body,
    required this.icon,
    this.targetKey,
    this.pageController,
    this.pageIndex,
  });

  bool get isCentered => targetKey == null;
}

final List<_TourStep> _steps = [
  const _TourStep(
    title: 'أهلاً بك في آفاق!',
    body: 'تطبيق آفاق العقاري يجمع لك كل ما يخص العقار في الكويت بمكان واحد. خلنا نتعرف بسرعة على أهم أقسام التطبيق.',
    icon: Icons.waving_hand_rounded,
  ),
  _TourStep(
    title: 'إضافة إعلان',
    body: 'من هنا تقدر تعرض عقارك، تسجّل نفسك كمقاول، تنشر وظيفة، أو تضيف شركتك العقارية، مكتبك الهندسي، أو حتى فندقك وشقتك المفروشة.',
    icon: Icons.add_circle_outline,
    targetKey: OnboardingKeys.addAdNavKey,
  ),
  _TourStep(
    title: 'اعرض عقارك',
    body: 'أسرع طريقة تعرض عقارك للبيع أو الإيجار أو البدل.',
    icon: Icons.add_home_work_outlined,
    targetKey: OnboardingKeys.serviceKey('add_property'),
    pageController: OnboardingKeys.servicesPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'إدارة الأملاك',
    body: 'خدمة متكاملة لإدارة عقاراتك بالكامل نيابةً عنك.',
    icon: Icons.apartment,
    targetKey: OnboardingKeys.serviceKey('property_mgmt'),
    pageController: OnboardingKeys.servicesPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'التقييم العقاري',
    body: 'اطلب تقييمًا رسميًا لعقارك من مختصين معتمدين.',
    icon: Icons.calendar_month,
    targetKey: OnboardingKeys.serviceKey('valuation'),
    pageController: OnboardingKeys.servicesPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'حسبة تكلفة البناء',
    body: 'قدّر تكلفة بناء عقارك بشكل سريع ودقيق.',
    icon: Icons.construction,
    targetKey: OnboardingKeys.serviceKey('build_calc'),
    pageController: OnboardingKeys.servicesPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'الاستشارة العقارية',
    body: 'احصل على استشارة من خبراء عقاريين قبل أي قرار مهم.',
    icon: Icons.support_agent,
    targetKey: OnboardingKeys.serviceKey('consultation'),
    pageController: OnboardingKeys.servicesPageController,
    pageIndex: 1,
  ),
  _TourStep(
    title: 'قسم العقار',
    body: 'استعرض كل التصنيفات العقارية: سكني، تجاري، استثماري، وصناعي.',
    icon: Icons.home_work_outlined,
    targetKey: OnboardingKeys.sectionKey('section_real_estate'),
    pageController: OnboardingKeys.sectionsPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'المقاولات',
    body: 'تواصل مع مقاولين موثوقين لتنفيذ مشروعك.',
    icon: Icons.engineering_outlined,
    targetKey: OnboardingKeys.sectionKey('section_contracting'),
    pageController: OnboardingKeys.sectionsPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'الوظائف',
    body: 'تصفح الوظائف الشاغرة أو أعلن أنك تبحث عن عمل.',
    icon: Icons.work_outline,
    targetKey: OnboardingKeys.sectionKey('section_jobs'),
    pageController: OnboardingKeys.sectionsPageController,
    pageIndex: 0,
  ),
  _TourStep(
    title: 'الشركات والمكاتب الهندسية',
    body: 'تعرّف على أفضل الشركات العقارية والمكاتب الهندسية في الكويت.',
    icon: Icons.business_outlined,
    targetKey: OnboardingKeys.sectionKey('section_real_estate_companies'),
    pageController: OnboardingKeys.sectionsPageController,
    pageIndex: 1,
  ),
  _TourStep(
    title: 'الفنادق',
    body: 'استعرض واحجز الفنادق بسهولة.',
    icon: Icons.hotel_outlined,
    targetKey: OnboardingKeys.sectionKey('section_hotels'),
    pageController: OnboardingKeys.sectionsPageController,
    pageIndex: 1,
  ),
  const _TourStep(
    title: 'أهلاً وسهلاً بك في آفاق',
    body: 'خيارك العقاري الأول في الكويت.',
    icon: Icons.emoji_events_outlined,
  ),
];

/// يعرض جولة "سبوت لايت" تسلّط الضوء فعليًا على كل عنصر بالواجهة الحقيقية
/// (البحث، إضافة إعلان، خدماتنا، الأقسام) مع فقاعة شرح بجنبه، بدل
/// نافذة منفصلة بس. يستخدمها verify_email_view.dart بعد أول تفعيل بريد.
Future<void> showSpotlightTour(BuildContext context) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, __) => FadeTransition(
        opacity: animation,
        child: const _SpotlightTourOverlay(),
      ),
    ),
  );
}

class _SpotlightTourOverlay extends StatefulWidget {
  const _SpotlightTourOverlay();

  @override
  State<_SpotlightTourOverlay> createState() => _SpotlightTourOverlayState();
}

class _SpotlightTourOverlayState extends State<_SpotlightTourOverlay> {
  int _index = 0;
  Rect? _targetRect;
  bool _positioning = true;

  @override
  void initState() {
    super.initState();
    _prepareStep();
  }

  Future<void> _prepareStep() async {
    setState(() => _positioning = true);
    final step = _steps[_index];

    if (step.pageController != null &&
        step.pageIndex != null &&
        step.pageController!.hasClients) {
      await step.pageController!.animateToPage(
        step.pageIndex!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    // نعطي فريم للـ layout يستقر بعد تغيير الصفحة قبل ما نقيس الموقع
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    Rect? rect;
    final key = step.targetKey;
    if (key != null) {
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && box.attached) {
          final topLeft = box.localToGlobal(Offset.zero);
          rect = Rect.fromLTWH(topLeft.dx, topLeft.dy, box.size.width, box.size.height);
        }
      }
    }

    setState(() {
      _targetRect = rect;
      _positioning = false;
    });
  }

  void _next() {
    if (_index == _steps.length - 1) {
      Navigator.of(context).pop();
    } else {
      setState(() => _index++);
      _prepareStep();
    }
  }

  void _skip() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final step = _steps[_index];
    final bool isLast = _index == _steps.length - 1;
    final Size screen = MediaQuery.of(context).size;

    // موضع فقاعة الشرح يُحسب الآن ديناميكيًا بالـ build (بالأسفل) حسب
    // المساحة الفعلية المتاحة فوق/تحت العنصر، بدل قيمة ثابتة قد تغطيه
    final Rect? r = _targetRect;

    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // === الطبقة المعتمة مع فتحة (spotlight) حول العنصر المستهدف
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SpotlightPainter(rect: r),
                ),
              ),
            ),
            // === مؤشر سهمي بسيط فوق/تحت العنصر
            if (r != null)
              Positioned(
                left: r.center.dx - 14,
                top: r.center.dy < screen.height / 2 ? r.bottom + 2 : r.top - 30,
                child: Icon(
                  r.center.dy < screen.height / 2
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            // === بطاقة الشرح: مركزية لو ولا يوجد هدف، أو بجانب الهدف
            // مع ضمان إنها ما تغطي العنصر المسلّط عليه الضوء أبدًا -
            // نحسب المساحة الفاضية فوقه وتحته ونضع البطاقة بأكبرهما
            Builder(builder: (context) {
              if (r == null || _positioning) {
                return Center(child: _buildCard(step, isLast, context, centered: true));
              }
              const double cardEstimatedHeight = 260;
              final double spaceAbove = r.top;
              final double spaceBelow = screen.height - r.bottom;
              final bool placeBelow = spaceBelow >= cardEstimatedHeight || spaceBelow > spaceAbove;
              final double top = placeBelow
                  ? (r.bottom + 26.h).clamp(16.0, screen.height - 100)
                  : (r.top - cardEstimatedHeight - 16.h).clamp(16.0, screen.height - 100);
              return Positioned(
                top: top,
                left: 24.w,
                right: 24.w,
                child: _buildCard(step, isLast, context, centered: false),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(_TourStep step, bool isLast, BuildContext context, {required bool centered}) {
    return Container(
      margin: centered ? EdgeInsets.symmetric(horizontal: 24.w) : EdgeInsets.zero,
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ColorManager.primary, ColorManager.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(step.icon, color: Colors.white, size: 32.sp),
          ),
          SizedBox(height: 14.h),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          SizedBox(height: 8.h),
          Text(
            step.body,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600], height: 1.6),
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (i) {
              final bool active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: active ? 14.w : 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: active ? ColorManager.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              if (!isLast)
                Expanded(
                  child: TextButton(
                    onPressed: _skip,
                    child: Text('تخطي', style: TextStyle(color: Colors.grey[600], fontSize: 13.5.sp)),
                  ),
                ),
              Expanded(
                flex: isLast ? 1 : 2,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  ),
                  child: Text(
                    isLast ? 'ابدأ الآن' : 'التالي',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// يرسم طبقة معتمة على كل الشاشة مع "فتحة" بيضاوية شفافة حول العنصر
/// المستهدف حتى يبان أصلي وواضح فوق التعتيم.
class _SpotlightPainter extends CustomPainter {
  final Rect? rect;
  _SpotlightPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (rect != null) {
      final holeRect = rect!.inflate(8);
      final holePath = Path()
        ..addRRect(RRect.fromRectAndRadius(holeRect, const Radius.circular(18)));
      canvas.drawPath(
        Path.combine(PathOperation.difference, path, holePath),
        overlayPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(holeRect, const Radius.circular(18)),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    } else {
      canvas.drawPath(path, overlayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) => oldDelegate.rect != rect;
}
