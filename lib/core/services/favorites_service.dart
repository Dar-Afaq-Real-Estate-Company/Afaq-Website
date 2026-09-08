import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../helper/shared_pref.dart';

/// أنواع العناصر اللي تقدر تنضاف للمفضلة بالتطبيق
enum FavoriteType { advertisement, contracting, company, engineering, job, hotel }

extension FavoriteTypeValue on FavoriteType {
  String get apiValue {
    switch (this) {
      case FavoriteType.advertisement:
        return 'advertisement';
      case FavoriteType.contracting:
        return 'contracting';
      case FavoriteType.company:
        return 'company';
      case FavoriteType.engineering:
        return 'engineering';
      case FavoriteType.job:
        return 'job';
      case FavoriteType.hotel:
        return 'hotel';
    }
  }
}

/// خدمة موحّدة للمفضلة - أي صفحة بالتطبيق تقدر تستخدمها بنفس الطريقة
/// بغض النظر عن نوع العنصر (إعلان، مقاول، شركة، مكتب هندسي، وظيفة).
class FavoritesService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));

  static String _key(FavoriteType type, int itemId) => '${type.apiValue}_$itemId';

  // === مصدر وحيد للحقيقة: ValueNotifier مشترك لكل عنصر - أي FavoriteButton
  // بأي صفحة (قائمة أو تفاصيل) لنفس العنصر يشترك بنفس الـ notifier، فلما
  // يتغيّر بمكان، يتحدث بكل مكان فورياً بدون أي تنقّل أو تحديث يدوي
  static final Map<String, ValueNotifier<bool>> _notifiers = {};

  static ValueNotifier<bool> notifierFor(FavoriteType type, int itemId, {bool initial = false}) {
    final key = _key(type, itemId);
    return _notifiers.putIfAbsent(key, () => ValueNotifier<bool>(initial));
  }

  static Future<bool> addFavorite(FavoriteType type, int itemId) async {
    notifierFor(type, itemId).value = true;
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      await _dio.post('favorites', data: {
        'user_id': userId,
        'type': type.apiValue,
        'item_id': itemId,
      });
      return true;
    } catch (e) {
      if (e is DioException) {
        // ignore: avoid_print
        print('addFavorite DioException: status=${e.response?.statusCode} body=${e.response?.data} message=${e.message}');
      }
      notifierFor(type, itemId).value = false;
      return false;
    }
  }

  static Future<bool> removeFavorite(FavoriteType type, int itemId) async {
    notifierFor(type, itemId).value = false;
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
      await _dio.delete('favorites/${type.apiValue}/$itemId',
          queryParameters: {'user_id': userId});
      return true;
    } catch (_) {
      notifierFor(type, itemId).value = true;
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAll() async {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    final response = await _dio.get('favorites', queryParameters: {'user_id': userId});
    final List<dynamic> data = response.data['data'] ?? [];
    final list = data.cast<Map<String, dynamic>>();
    for (final f in list) {
      final t = FavoriteType.values.firstWhere(
        (e) => e.apiValue == f['type'],
        orElse: () => FavoriteType.advertisement,
      );
      final id = int.tryParse('${f['id']}');
      if (id != null) notifierFor(t, id).value = true;
    }
    return list;
  }

  /// يفحص هل عنصر معيّن محفوظ بالمفضلة حالياً - يُستخدم فقط أول مرة
  /// لتحديد القيمة الابتدائية للـ notifier (بعدها كل التحديثات تصير
  /// عبر الـ notifier نفسه بدون طلب شبكة إضافي)
  static Future<bool> isFavorited(FavoriteType type, int itemId) async {
    final key = _key(type, itemId);
    if (_notifiers.containsKey(key)) return _notifiers[key]!.value;
    try {
      final all = await fetchAll();
      return all.any((f) => f['type'] == type.apiValue && '${f['id']}' == '$itemId');
    } catch (_) {
      return false;
    }
  }
}
