import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// === مساعد مشترك لتتبع الإشعارات اللي قرأها/أخفاها المستخدم محليًا -
/// يستخدمه رقم الإشعارات فوق الأيقونة، وصفحة الإشعارات نفسها، عشان
/// يضلوا متزامنين مع بعض دايمًا.
class NotificationDismissHelper {
  static const String _key = 'dismissed_notification_ids';

  static Future<Set<int>> getDismissedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key);
    if (raw == null) return {};
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => e as int).toSet();
  }

  static Future<void> dismiss(int id) async {
    final ids = await getDismissedIds();
    ids.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(ids.toList()));
  }
}
