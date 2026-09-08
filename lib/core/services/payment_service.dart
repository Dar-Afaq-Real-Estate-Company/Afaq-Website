import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../helper/shared_pref.dart';
import '../widgets/payment_webview_screen.dart';

/// أنواع العناصر المدفوعة
class PaymentItemType {
  static const String advertisement = 'advertisement';
  static const String job = 'job';
  static const String hotel = 'hotel';
  static const String contracting = 'contracting';
  static const String company = 'company';
  static const String engineering = 'engineering';
  static const String consultation = 'consultation';
  static const String officialEvaluation = 'official_evaluation';
  static const String subscription = 'subscription';
}

class PaymentResult {
  final bool success;
  final bool skipped; // حساب إداري - بدون دفع
  final String? trackId;
  final String? message;

  const PaymentResult({
    required this.success,
    this.skipped = false,
    this.trackId,
    this.message,
  });
}

/// الدفع الإلكتروني عبر KNET.
/// التفعيل يتم بالسيرفر من ردّ البنك — التطبيق يستعلم عن النتيجة فقط.
class PaymentService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.afaq.group/api/',
    connectTimeout: const Duration(seconds: 25),
    receiveTimeout: const Duration(seconds: 25),
  ));

  /// يفتح بوابة الدفع ويرجع النتيجة.
  /// [itemId] يُمرَّر لو العنصر أُنشئ مسبقًا بحالة "بانتظار الدفع".
  static Future<PaymentResult> pay({
    required BuildContext context,
    required String itemType,
    int? itemId,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);

      final response = await _dio.post('payment/create', data: {
        'user_id': userId,
        'item_type': itemType,
        if (itemId != null) 'item_id': itemId,
        if (payload != null) 'payload': payload,
      });

      // حساب إداري: يُنشر بدون دفع
      if (response.data['skip_payment'] == true) {
        return PaymentResult(
          success: true,
          skipped: true,
          message: response.data['message']?.toString(),
        );
      }

      final String url = response.data['payment_url'].toString();
      final String trackId = response.data['track_id'].toString();

      if (!context.mounted) {
        return const PaymentResult(success: false);
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(
            url: url,
            title: 'الدفع الإلكتروني',
          ),
        ),
      );

      // نتحقق من النتيجة بالسيرفر (المصدر الموثوق)
      return await _checkStatus(trackId);
    } on DioException catch (e) {
      return PaymentResult(
        success: false,
        message: e.response?.data is Map
            ? (e.response?.data['message']?.toString() ?? 'تعذر بدء عملية الدفع')
            : 'تعذر الاتصال بالسيرفر',
      );
    } catch (_) {
      return const PaymentResult(
        success: false,
        message: 'تعذر بدء عملية الدفع، حاول مرة أخرى',
      );
    }
  }

  static Future<PaymentResult> _checkStatus(String trackId) async {
    // نحاول أكثر من مرة لأن ردّ البنك قد يتأخر ثوانٍ
    for (int attempt = 0; attempt < 4; attempt++) {
      try {
        final response = await _dio.get('payment/status/$trackId');
        final status = response.data['payment_status']?.toString();

        if (status == 'paid') {
          return PaymentResult(success: true, trackId: trackId);
        }
        if (status == 'failed' || status == 'cancelled') {
          return PaymentResult(
            success: false,
            trackId: trackId,
            message: status == 'cancelled'
                ? 'تم إلغاء عملية الدفع'
                : 'لم تكتمل عملية الدفع',
          );
        }
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 2));
    }

    return PaymentResult(
      success: false,
      trackId: trackId,
      message: 'ما وصلنا تأكيد الدفع بعد، تحقق من إعلاناتك بعد قليل',
    );
  }

  /// يربط عملية دفع ناجحة بعنصر أُنشئ بعدها
  static Future<void> attachItem({
    required String trackId,
    required int itemId,
  }) async {
    try {
      await _dio.post('payment/attach-item', data: {
        'track_id': trackId,
        'item_id': itemId,
      });
    } catch (_) {}
  }

  /// سعر القسم (يُقرأ من السيرفر لو احتجناه بالواجهة)
  static Future<double> priceOf(String itemType) async {
    try {
      final response = await _dio.get('payment/price/$itemType');
      return double.tryParse(response.data['amount'].toString()) ?? 30;
    } catch (_) {
      return 30;
    }
  }
}
