import 'package:dio/dio.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_factory.dart';
import 'hotel_model.dart';

/// طبقة بيانات مستقلة لقسم الفنادق الجديد - تتحدث مباشرة مع نفس نقاط
/// الـ API الحالية بالسيرفر، باستخدام نفس Dio المشترك بالتطبيق (التوكن
/// مضاف عليه تلقائيًا بعد تسجيل الدخول).
class HotelsRepository {
  static Dio get _dio {
    final dio = DioFactory.getDio();
    dio.options.baseUrl = ApiConstants.apiBaseUrl;
    return dio;
  }

  static Future<List<HotelModel>> fetchAll({String? region, double? minPrice, double? maxPrice}) async {
    final response = await _dio.get('hotels', queryParameters: {
      if (region != null && region.isNotEmpty) 'region': region,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
    });
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => HotelModel.fromJson(e)).toList();
  }

  static Future<HotelModel> fetchOne(int id) async {
    final response = await _dio.get('hotels/$id');
    return HotelModel.fromJson(response.data['data']);
  }

  static Future<bool> add({
    required String name,
    required String region,
    double? latitude,
    double? longitude,
    required double pricePerNight,
    String? description,
    required String phone,
    String? whatsapp,
    required List<String> amenities,
    required List<String> views,
    required List<String> imagesBase64,
    required List<Map<String, dynamic>> rooms,
  }) async {
    final response = await _dio.post('hotels', data: {
      'name': name,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'price_per_night': pricePerNight,
      'description': description,
      'phone': phone,
      'whatsapp': whatsapp ?? phone,
      'amenities': amenities,
      'views': views,
      'images': imagesBase64,
      'rooms': rooms,
    });
    return response.data['status'] == true;
  }
}
