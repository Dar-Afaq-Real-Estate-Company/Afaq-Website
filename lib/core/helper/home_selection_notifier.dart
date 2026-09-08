import 'package:flutter/material.dart';

/// === تحديد موحّد يشترك فيه صف "خدماتنا" وصف "الأقسام" بالصفحة
/// الرئيسية - لما تختار عنصر من وحدة، ينمسح تحديد الصف الثاني تلقائيًا
/// (بس عنصر واحد محدد بكل الصفحة بأي لحظة).
class HomeSelection {
  final String row; // 'services' أو 'sections'
  final int index;
  const HomeSelection(this.row, this.index);
}

class HomeSelectionNotifier {
  static final ValueNotifier<HomeSelection?> selected = ValueNotifier(null);

  static void select(String row, int index) {
    selected.value = HomeSelection(row, index);
  }
}
