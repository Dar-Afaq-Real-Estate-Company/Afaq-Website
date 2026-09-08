import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/banner_model.dart';

/// يجيب "الإعلانات المرئية" من السيرفر - بدون توكن، عام لكل زائر.
class BannersRepository {
  static Dio get _dio => DioFactory.getDio();

  static Future<List<BannerModel>> fetchAll() async {
    try {
      final response = await _dio.get('${ApiConstants.apiBaseUrl}banners');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => BannerModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
