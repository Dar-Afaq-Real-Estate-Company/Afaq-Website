import 'package:flutter/foundation.dart';

/// يتحكم بإظهار/إخفاء الشريط السفلي (BottomNavigationBar) من أي مكان
/// بالتطبيق - مثلاً وانت تسكرول داخل قائمة "أحدث الإعلانات" بالصفحة
/// الرئيسية. أي ويدجت يقدر يسمعه عبر ValueListenableBuilder بدون ما
/// نحتاج نضيف Cubit كامل أو نلمس ملف الـ DI.
class BottomNavVisibility {
  BottomNavVisibility._();

  static final ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  static void show() => visible.value = true;
  static void hide() => visible.value = false;
}
