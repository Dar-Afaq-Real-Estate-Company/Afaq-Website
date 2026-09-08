import 'package:flutter/material.dart';

/// مفاتيح ثابتة (GlobalKeys) توضع على العناصر الحقيقية بواجهة التطبيق
/// (زر إضافة إعلان، عناصر "خدماتنا"، عناصر "الأقسام") حتى يقدر
/// spotlight_tour.dart يحدد موقعها الفعلي بالشاشة ويسلّط عليها الضوء.
class OnboardingKeys {
  OnboardingKeys._();

  static final GlobalKey searchKey = GlobalKey(debugLabel: 'ob_search');
  static final GlobalKey addAdNavKey = GlobalKey(debugLabel: 'ob_add_ad_nav');

  // === تحكم بصفحة "خدماتنا" (PageView) حتى نقدر نطلع للصفحة الصحيحة
  // قبل تسليط الضوء على عنصر بيها
  static final PageController servicesPageController = PageController();
  static final Map<String, GlobalKey> _serviceKeys = {};
  static GlobalKey serviceKey(String label) =>
      _serviceKeys.putIfAbsent(label, () => GlobalKey(debugLabel: 'ob_service_$label'));

  // === نفس الفكرة لصف "الأقسام"
  static final PageController sectionsPageController = PageController();
  static final Map<String, GlobalKey> _sectionKeys = {};
  static GlobalKey sectionKey(String labelKey) =>
      _sectionKeys.putIfAbsent(labelKey, () => GlobalKey(debugLabel: 'ob_section_$labelKey'));
}
