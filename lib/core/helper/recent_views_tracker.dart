import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// يخزّن محليًا آخر العقارات اللي فتح المستخدم تفاصيلها (بدون أي حاجة
/// لباك اند) - يُستخدم بتبويب "الإعلانات" فوق (خيار "آخر العمليات").
class RecentViewsTracker {
  static const _key = 'recent_property_views';
  static const _max = 15;

  static Future<void> addView(Map<String, dynamic> adJson) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_key) ?? [];
    final List<Map<String, dynamic>> list = raw
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .where((e) => e['id'] != adJson['id'])
        .toList();
    list.insert(0, adJson);
    final trimmed = list.take(_max).map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_key, trimmed);
  }

  static Future<List<Map<String, dynamic>>> getViews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }
}
