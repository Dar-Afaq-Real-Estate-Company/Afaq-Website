import 'package:dio/dio.dart';

import '../helper/shared_pref.dart';

class SubscriptionPlan {
  final int id;
  final String name;
  final String? nameEn;
  final double price;
  final int durationDays;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    this.nameEn,
    required this.price,
    required this.durationDays,
    required this.features,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString(),
      price: double.tryParse(json['price'].toString()) ?? 0,
      durationDays: json['duration_days'] is int
          ? json['duration_days']
          : int.tryParse(json['duration_days'].toString()) ?? 30,
      features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  // === ترجمة عرضية للاسم/المزايا لحد ما السيرفر يرسل name_en/features_en -
  // تغطي القيم الحالية المعروفة بالباقتين (أساسية/احترافية)، وترجع النص
  // الأصلي لو القيمة غير معروفة (باقة جديدة أضيفت من لوحة التحكم)
  static const Map<String, String> _nameMap = {
    'الباقة الأساسية': 'Basic Plan',
    'الباقة الاحترافية': 'Professional Plan',
  };
  static const Map<String, String> _featureMap = {
    'عدد الإعلانات: 1': 'Number of ads: 1',
    'عدد الإعلانات: 5': 'Number of ads: 5',
    'استلام العملاء مباشرة': 'Receive clients directly',
    'خدمة تصوير / فيديو حسب الطلب': 'Photography / video service on request',
    'تثبيت الإعلان في أعلى النتائج': 'Pin the ad at the top of results',
  };

  String displayName(String lang) {
    if (lang != 'ar') return nameEn ?? _nameMap[name] ?? name;
    return name;
  }

  List<String> displayFeatures(String lang) {
    if (lang != 'ar') return features.map((f) => _featureMap[f] ?? f).toList();
    return features;
  }
}

class ActiveSubscription {
  final SubscriptionPlan plan;
  final DateTime? expiresAt;

  ActiveSubscription({required this.plan, this.expiresAt});
}

/// خدمة الباقات (الاشتراك) - جلب الباقات المتاحة والتحقق من وجود باقة
/// فعّالة للمستخدم الحالي.
class SubscriptionService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));

  static Future<List<SubscriptionPlan>> fetchPlans() async {
    final response = await _dio.get('subscription-plans');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => SubscriptionPlan.fromJson(e)).toList();
  }

  static Future<ActiveSubscription?> fetchStatus() async {
    try {
      final int userId = await SharedPrefHelper.getInt('userId');
      final response = await _dio.get('subscription-status', queryParameters: {'user_id': userId});

      if (response.data['active'] != true || response.data['data'] == null) {
        return null;
      }

      final data = response.data['data'] as Map<String, dynamic>;
      final planJson = data['plan'] as Map<String, dynamic>?;
      if (planJson == null) return null;

      return ActiveSubscription(
        plan: SubscriptionPlan.fromJson(planJson),
        expiresAt: data['expires_at'] != null ? DateTime.tryParse(data['expires_at'].toString()) : null,
      );
    } catch (_) {
      return null;
    }
  }
}
