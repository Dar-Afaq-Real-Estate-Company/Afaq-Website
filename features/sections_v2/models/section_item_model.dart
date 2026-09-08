import 'package:flutter/material.dart';

/// موديل عنصر القسم الواحد بقائمة "الأقسام" الجديدة.
/// كل قسم يفتح صفحة مستقلة خاصة فيه (route) - مو Bottom Sheet مشترك
/// زي القائمة القديمة (section_services.dart المحفوظة على جنب).
class SectionItemModel {
  final String labelKey; // مفتاح الترجمة بـ strings_manager.dart
  final IconData icon;
  final String route;
  final Color? color;

  const SectionItemModel({
    required this.labelKey,
    required this.icon,
    required this.route,
    this.color,
  });
}
