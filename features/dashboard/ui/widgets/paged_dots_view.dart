import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';

/// ويدجت عام قابل لإعادة الاستخدام: يعرض أي قائمة عناصر بشكل صفحات
/// قابلة للسحب يمين/يسار مع نقاط (dots) تحت توضح الصفحة الحالية.
/// نفس ستايل قسم "الشركاء الأكثر ثقة" (trusted_partners_section.dart)،
/// بس معمم عشان نقدر نستخدمه لأي قائمة ثانية (الخدمات، الأقسام...).
class PagedDotsView<T> extends StatefulWidget {
  final List<T> items;
  final int itemsPerPage;
  final double height;
  // === تحكم خارجي اختياري بالصفحة (يستخدمه spotlight_tour.dart للتنقل
  // التلقائي بين الصفحات وقت الجولة التعريفية)
  final PageController? controller;

  /// يبني محتوى الصفحة الواحدة بالكامل (Row أو GridView حسب الحاجة)
  final Widget Function(BuildContext context, List<T> pageItems) pageBuilder;

  const PagedDotsView({
    super.key,
    required this.items,
    required this.pageBuilder,
    required this.itemsPerPage,
    this.height = 110,
    this.controller,
  });

  @override
  State<PagedDotsView<T>> createState() => _PagedDotsViewState<T>();
}

class _PagedDotsViewState<T> extends State<PagedDotsView<T>> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = widget.controller ?? PageController();
  }

  @override
  void dispose() {
    // نتخلص من الكونترولر بس لو أنشأناه نحن (مو المُمرر من برا)
    if (widget.controller == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  int get _pageCount => (widget.items.length / widget.itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    // === تمرير أفقي مستمر (كل العناصر بصف واحد يُسحب يمين/يسار)
    return SizedBox(
      height: widget.height.h,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          physics: const BouncingScrollPhysics(),
          child: widget.pageBuilder(context, widget.items),
        ),
      ),
    );
  }
}
