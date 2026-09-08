import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

/// السيرفر أحياناً يرجع بعض الحقول (price, user_id, status) كأرقام (int)
/// وأحياناً كنصوص (String)، فهذا الـ Converter يتعامل مع الحالتين بأمان
/// بدل ما نعتمد على cast مباشر يطيح بالتطبيق.
class DynamicStringConverter implements JsonConverter<String?, dynamic> {
  const DynamicStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    return json.toString();
  }

  @override
  dynamic toJson(String? object) => object;
}

/// نفس فكرة DynamicStringConverter لكن للقيم المنطقية (has_pool/has_garden/
/// has_parking) - السيرفر يرجعها كـ 0/1 (int) مو true/false مباشرة.
class DynamicBoolConverter implements JsonConverter<bool?, dynamic> {
  const DynamicBoolConverter();

  @override
  bool? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is bool) return json;
    if (json is num) return json != 0;
    return json.toString() == '1' || json.toString().toLowerCase() == 'true';
  }

  @override
  dynamic toJson(bool? object) => object;
}
/// longitude) - السيرفر يرجعها أحيانًا كنص "29.3759000" (عمود decimal)
/// وأحيانًا كرقم، فنتعامل مع الحالتين بأمان بدل ما cast مباشر يطيح
/// بتحليل قائمة الإعلانات كاملة.
class DynamicDoubleConverter implements JsonConverter<double?, dynamic> {
  const DynamicDoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    return double.tryParse(json.toString());
  }

  @override
  dynamic toJson(double? object) => object;
}

@JsonSerializable()
class AdsResponse {
  String? message;
  @JsonKey(name: 'advertisements')
  List<AdsDataResponse?>? allAds;

  AdsResponse({
    this.message,
    this.allAds,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdsResponseFromJson(json);
}

@JsonSerializable()
class AdsDataResponse {
  int? id;
  @JsonKey(name: 'plan_price')
  String? planPrice;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'transaction_type')
  String? transactionType;
  String? phone;
  String? description;
  String? type;
  String? region;
  @DynamicStringConverter()
  String? price;
  String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'share_code')
  String? shareCode;
  @JsonKey(name: 'share_url')
  String? shareUrl;
  // === جديد: إحداثيات موقع الإعلان على الخريطة (تحتاج عمود بقاعدة البيانات
  // بعد + الباك اند يرجعها بنفس الاسم). تكون null لأي إعلان قديم ما فيه موقع.
  @DynamicDoubleConverter()
  double? latitude;
  @DynamicDoubleConverter()
  double? longitude;

  // === جديد: تصنيف العقار وتفاصيله (تحتاج أعمدة جديدة بقاعدة البيانات)
  @JsonKey(name: 'property_section')
  String? propertySection; // سكني | تجاري | استثماري | صنايعي
  @JsonKey(name: 'land_type')
  String? landType; // زراعية | تجارية | سكنية | صناعية (لو النوع أرض بس)
  @DynamicStringConverter()
  String? area; // المساحة بالمتر المربع
  @DynamicStringConverter()
  @JsonKey(name: 'rooms_count')
  String? roomsCount;
  @DynamicStringConverter()
  @JsonKey(name: 'bathrooms_count')
  String? bathroomsCount;
  String? furnishing; // مفروشة | غير مفروشة | مفروشة جزئياً
  @JsonKey(name: 'building_age')
  String? buildingAge;
  @JsonKey(name: 'location_type')
  String? locationType; // شارع واحد | زاوية | ... (بيت/أرض)
  @DynamicStringConverter()
  @JsonKey(name: 'floors_count')
  String? floorsCount; // (بيت فقط)
  @JsonKey(name: 'rented_floor')
  String? rentedFloor; // (دور فقط)

  // === جديد: حقول إضافية مستخدمة بصفحات التفاصيل (العنوان، الغرف/
  // الحمامات/الصالات بأسماء مختصرة، العنوان النصي، الميزات)
  String? title;
  @DynamicStringConverter()
  String? rooms;
  @DynamicStringConverter()
  String? bathrooms;
  @DynamicStringConverter()
  String? halls;
  String? address;
  List<AmenityData>? amenities;
  @JsonKey(name: 'has_pool')
  @DynamicBoolConverter()
  bool? hasPool;
  @JsonKey(name: 'has_garden')
  @DynamicBoolConverter()
  bool? hasGarden;
  @JsonKey(name: 'has_parking')
  @DynamicBoolConverter()
  bool? hasParking;
  @JsonKey(name: 'views_count')
  int? viewsCount;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'reference_no')
  final String? referenceNo;
  // === بيانات ناشر الإعلان (شريط التفاصيل الثابت + صفحة الناشر)
  @JsonKey(name: 'publisher_name')
  final String? publisherName;
  @JsonKey(name: 'publisher_logo')
  final String? publisherLogo;
  @JsonKey(name: 'publisher_account_type')
  final String? publisherAccountType;
  @JsonKey(name: 'has_commission')
  @DynamicBoolConverter()
  final bool? hasCommission;
  @JsonKey(name: 'commission_percent')
  @DynamicStringConverter()
  final String? commissionPercent;
  @JsonKey(name: 'is_featured')
  @DynamicBoolConverter()
  final bool? isFeatured;
  @JsonKey(name: 'is_expired')
  final bool? isExpired;

  AdsDataResponse({
    this.id,
    this.planPrice,
    this.planName,
    this.transactionType,
    this.phone,
    this.description,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
    this.shareCode,
    this.shareUrl,
    this.latitude,
    this.longitude,
    this.propertySection,
    this.landType,
    this.area,
    this.roomsCount,
    this.bathroomsCount,
    this.furnishing,
    this.buildingAge,
    this.locationType,
    this.floorsCount,
    this.rentedFloor,
    this.title,
    this.rooms,
    this.bathrooms,
    this.halls,
    this.address,
    this.amenities,
    this.hasPool,
    this.hasGarden,
    this.hasParking,
    this.viewsCount,
    this.createdAt,
    this.referenceNo,
    this.publisherName,
    this.publisherLogo,
    this.publisherAccountType,
    this.hasCommission,
    this.commissionPercent,
    this.isFeatured,
    this.isExpired,
  });

  factory AdsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$AdsDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AdsDataResponseToJson(this);
}

// ============= Auction Response
@JsonSerializable()
class AuctionResponse {
  bool? status;
  int? count;
  @JsonKey(name: 'upcoming_auctions')
  List<AuctionDataResponse?>? upcomingAuctions;

  AuctionResponse({
    this.status,
    this.count,
    this.upcomingAuctions,
  });

  factory AuctionResponse.fromJson(Map<String, dynamic> json) =>
      _$AuctionResponseFromJson(json);
}

@JsonSerializable()
class AuctionDataResponse {
  int? id;
  @JsonKey(name: 'plan_price')
  String? planPrice;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'transaction_type')
  String? transactionType;
  @JsonKey(name: 'auction_date')
  String? auctionDate;
  String? phone;
  String? description;
  String? type;
  String? region;
  @DynamicStringConverter()
  String? price;
  String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  String? userId;

  AuctionDataResponse({
    this.id,
    this.planPrice,
    this.planName,
    this.transactionType,
    this.phone,
    this.description,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
  });

  factory AuctionDataResponse.fromJson(Map<String, dynamic> json) =>
      _$AuctionDataResponseFromJson(json);
}

// Home =====================================

@JsonSerializable()
class HomeResponse {
  bool? status;
  int? count;
  @JsonKey(name: 'vip_ads')
  List<VipAdsDataResponse?>? vipAds;

  HomeResponse({
    this.status,
    this.count,
    this.vipAds,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}

@JsonSerializable()
class VipAdsDataResponse {
  int? id;
  @JsonKey(name: 'plan_price')
  String? planPrice;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'is_featured')
  @DynamicBoolConverter()
  bool? isFeatured;
  @JsonKey(name: 'transaction_type')
  String? transactionType;
  @JsonKey(name: 'auction_date')
  String? auctionDate;
  String? phone;
  String? description;
  String? type;
  String? region;
  @DynamicStringConverter()
  String? price;
  String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'share_code')
  String? shareCode;
  @JsonKey(name: 'share_url')
  String? shareUrl;

  // === جديد: نفس حقول تفاصيل العقار المضافة لـ AdsDataResponse
  String? title;
  @DynamicStringConverter()
  String? rooms;
  @DynamicStringConverter()
  String? bathrooms;
  @DynamicStringConverter()
  String? halls;
  @DynamicStringConverter()
  String? area;
  String? address;
  List<AmenityData>? amenities;
  @JsonKey(name: 'has_pool')
  @DynamicBoolConverter()
  bool? hasPool;
  @JsonKey(name: 'has_garden')
  @DynamicBoolConverter()
  bool? hasGarden;
  @JsonKey(name: 'has_parking')
  @DynamicBoolConverter()
  bool? hasParking;
  @JsonKey(name: 'views_count')
  int? viewsCount;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'reference_no')
  String? referenceNo;
  @JsonKey(name: 'has_commission')
  @DynamicBoolConverter()
  bool? hasCommission;
  @JsonKey(name: 'commission_percent')
  @DynamicStringConverter()
  String? commissionPercent;
  @JsonKey(name: 'publisher_name')
  String? publisherName;
  @JsonKey(name: 'publisher_logo')
  String? publisherLogo;
  @JsonKey(name: 'publisher_account_type')
  String? publisherAccountType;

  VipAdsDataResponse({
    this.id,
    this.planPrice,
    this.planName,
    this.isFeatured,
    this.transactionType,
    this.phone,
    this.description,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
    this.shareCode,
    this.shareUrl,
    this.title,
    this.rooms,
    this.bathrooms,
    this.halls,
    this.area,
    this.address,
    this.amenities,
    this.hasPool,
    this.hasGarden,
    this.hasParking,
    this.viewsCount,
    this.createdAt,
    this.referenceNo,
    this.hasCommission,
    this.commissionPercent,
    this.publisherName,
    this.publisherLogo,
    this.publisherAccountType,
  });

  factory VipAdsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$VipAdsDataResponseFromJson(json);
}

// User Id Add advertisement ===================================================

@JsonSerializable()
class AddAdvertisementResponse {
  String? message;
  @JsonKey(name: 'advertisement')
  AddAdvertisementDataResponse? addAdvertisement;

  AddAdvertisementResponse({
    this.message,
    this.addAdvertisement,
  });

  factory AddAdvertisementResponse.fromJson(Map<String, dynamic> json) =>
      _$AddAdvertisementResponseFromJson(json);
}

@JsonSerializable()
class AddAdvertisementDataResponse {
  @DynamicStringConverter()
  String? id;
  @JsonKey(name: 'reference_no')
  String? referenceNo;
  @JsonKey(name: 'plan_price')
  @DynamicStringConverter()
  String? planPrice;
  @JsonKey(name: 'plan_name')
  String? planName;
  @JsonKey(name: 'transaction_type')
  String? transactionType;
  @JsonKey(name: 'auction_date')
  String? auctionDate;
  String? title;
  String? phone;
  String? description;
  String? type;
  String? region;
  @DynamicStringConverter()
  String? price;
  dynamic images;
  @JsonKey(name: 'user_id')
  @DynamicStringConverter()
  String? userId;

  AddAdvertisementDataResponse({
    this.id,
    this.referenceNo,
    this.planName,
    this.planPrice,
    this.transactionType,
    this.phone,
    this.description,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
  });

  factory AddAdvertisementDataResponse.fromJson(Map<String, dynamic> json) {
    final obj = _$AddAdvertisementDataResponseFromJson(json);
    // === احتياطي: لو الملف المولّد (.g.dart) ما تم توليده من جديد بعد،
    // نعبّي reference_no يدويًا من نفس الجيسون مباشرة
    obj.referenceNo ??= json['reference_no']?.toString();
    return obj;
  }
}

//==============================================================================

@JsonSerializable()
class ShowUserAdResponse {
  @JsonKey(name: "advertisements")
  final List<ShowUserAdvertisementData?>? showUserAdvertisementData;

  ShowUserAdResponse({this.showUserAdvertisementData});

  factory ShowUserAdResponse.fromJson(Map<String, dynamic> json) =>
      _$ShowUserAdResponseFromJson(json);
}

@JsonSerializable()
class ShowUserAdvertisementData {
  final int? id;
  @JsonKey(name: "plan_price")
  final String? planPrice;
  @JsonKey(name: "plan_name")
  final String? planName;
  @JsonKey(name: 'is_featured')
  @DynamicBoolConverter()
  final bool? isFeatured;
  @JsonKey(name: "transaction_type")
  final String? transactionType;
  final String? phone;
  @DynamicStringConverter()
  final String? status;
  final String? description;
  @JsonKey(name: "auction_date")
  final String? auctionDate;
  final String? type;
  final String? region;
  @DynamicStringConverter()
  final String? price;
  final String? images;
  @DynamicStringConverter()
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "share_code")
  final String? shareCode;
  @JsonKey(name: "share_url")
  final String? shareUrl;
  // === جديد: باقي تفاصيل العقار - لتعديل موحّد بصفحة واحدة
  final String? title;
  @DynamicStringConverter()
  final String? rooms;
  @DynamicStringConverter()
  final String? bathrooms;
  @DynamicStringConverter()
  final String? halls;
  @DynamicStringConverter()
  final String? kitchens;
  @DynamicStringConverter()
  final String? area;
  @DynamicStringConverter()
  @JsonKey(name: 'floors_count')
  final String? floorsCount;
  final String? address;
  @JsonKey(name: 'property_section')
  final String? propertySection;
  @JsonKey(name: 'land_type')
  final String? landType;
  @JsonKey(name: 'views_count')
  @DynamicStringConverter()
  final String? viewsCount;
  @JsonKey(name: 'reference_no')
  final String? referenceNo;
  @JsonKey(name: 'has_commission')
  @DynamicBoolConverter()
  final bool? hasCommission;
  @JsonKey(name: 'commission_percent')
  @DynamicStringConverter()
  final String? commissionPercent;
  @JsonKey(name: 'is_expired')
  final bool? isExpired;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @JsonKey(name: 'publisher_name')
  String? publisherName;
  @JsonKey(name: 'publisher_logo')
  String? publisherLogo;
  @JsonKey(name: 'publisher_account_type')
  String? publisherAccountType;
  final List<AmenityData>? amenities;
  @JsonKey(name: 'has_pool')
  @DynamicBoolConverter()
  final bool? hasPool;
  @JsonKey(name: 'has_garden')
  @DynamicBoolConverter()
  final bool? hasGarden;
  @JsonKey(name: 'has_parking')
  @DynamicBoolConverter()
  final bool? hasParking;

  ShowUserAdvertisementData({
    this.id,
    this.planPrice,
    this.planName,
    this.isFeatured,
    this.transactionType,
    this.phone,
    this.status,
    this.description,
    this.auctionDate,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
    this.createdAt,
    this.shareCode,
    this.shareUrl,
    this.title,
    this.rooms,
    this.bathrooms,
    this.halls,
    this.kitchens,
    this.area,
    this.floorsCount,
    this.address,
    this.propertySection,
    this.landType,
    this.viewsCount,
    this.referenceNo,
    this.hasCommission,
    this.commissionPercent,
    this.isExpired,
    this.rejectionReason,
    this.publisherName,
    this.publisherLogo,
    this.publisherAccountType,
    this.amenities,
    this.hasPool,
    this.hasGarden,
    this.hasParking,
  });

  factory ShowUserAdvertisementData.fromJson(Map<String, dynamic> json) =>
      _$ShowUserAdvertisementDataFromJson(json);
}
// =============================================================================

@JsonSerializable()
class NotificationsResponse {
  bool? success;
  String? message;
  @JsonKey(name: 'data')
  List<NotificationsDataResponse?>? notificationsDataResponse;

  NotificationsResponse({
    this.success,
    this.message,
    this.notificationsDataResponse,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}

@JsonSerializable()

class NotificationsDataResponse {
  int? id;
  String? email;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'Subject')
  String? subject;

  @JsonKey(name: 'is_read')
  int? isRead;

  NotificationsDataResponse({
    this.id,
    this.email,
    this.message,
    this.subject,
    this.isRead,
  });


  factory NotificationsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDataResponseFromJson(json);
}

// ================= SearchAdsResponse =================
@JsonSerializable()
class SearchAdsResponse {
  final String? message;
  final int? count;
  final List<AdModel>? data;
  SearchAdsResponse(this.count, this.data, this.message);

  factory SearchAdsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchAdsResponseFromJson(json);
}

@JsonSerializable()
class AdModel {
  final int? id;
  @JsonKey(name: 'plan_price')
  final String? planPrice;
  @JsonKey(name: 'plan_name')
  final String? planName;
  @JsonKey(name: 'transaction_type')
  final String? transactionType;
  final String? phone;
  @DynamicStringConverter()
  final String? status;
  final String? description;
  @JsonKey(name: 'auction_date')
  final String? auctionDate;
  final String? type;
  final String? region;
  @DynamicStringConverter()
  final String? price;
  final String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'share_code')
  final String? shareCode;
  @JsonKey(name: 'share_url')
  final String? shareUrl;

  // === جديد: نفس حقول تفاصيل العقار المضافة بالموديلات الثانية
  final String? title;
  @DynamicStringConverter()
  final String? rooms;
  @DynamicStringConverter()
  final String? bathrooms;
  @DynamicStringConverter()
  final String? halls;
  @DynamicStringConverter()
  final String? area;
  final String? address;
  final List<AmenityData>? amenities;
  // === جديد: خدمات إضافية سريعة (مسبح/حديقة/مواقف)
  @JsonKey(name: 'has_pool')
  @DynamicBoolConverter()
  final bool? hasPool;
  @JsonKey(name: 'has_garden')
  @DynamicBoolConverter()
  final bool? hasGarden;
  @JsonKey(name: 'has_parking')
  @DynamicBoolConverter()
  final bool? hasParking;
  @JsonKey(name: 'has_commission')
  @DynamicBoolConverter()
  final bool? hasCommission;
  @JsonKey(name: 'commission_percent')
  @DynamicStringConverter()
  final String? commissionPercent;

  AdModel({
    this.id,
    this.planPrice,
    this.planName,
    this.transactionType,
    this.phone,
    this.status,
    this.description,
    this.auctionDate,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
    this.createdAt,
    this.shareCode,
    this.shareUrl,
    this.title,
    this.rooms,
    this.bathrooms,
    this.halls,
    this.area,
    this.address,
    this.amenities,
    this.hasPool,
    this.hasGarden,
    this.hasParking,
    this.hasCommission,
    this.commissionPercent,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) =>
      _$AdModelFromJson(json);
}

// =============================================================================
@JsonSerializable()
class UserMonthlyPointsResponse {
  final bool? status;
  @JsonKey(name: 'current_month')
  final int? currentMonth;
  @JsonKey(name: 'total_points')
  final String? totalPoints;
  UserMonthlyPointsResponse(this.status, this.currentMonth, this.totalPoints);

  factory UserMonthlyPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserMonthlyPointsResponseFromJson(json);
}

// === DeleteAdResponse
@JsonSerializable()
class DeleteAdResponse {
  String? message;
  DeleteAdResponse({
    this.message,
  });

  factory DeleteAdResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAdResponseFromJson(json);
}

// ====== Update Response ======================================================
@JsonSerializable()
class UpdateAdResponse {
  String? message;
  bool? status;

  UpdateAdResponse({
    this.message,
    this.status,
  });

  factory UpdateAdResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdResponseFromJson(json);
}

@JsonSerializable()
class FilterSectionResponse {
  final bool? success;
  final int? count;
  final List<FilterSectionModel>? data;

  FilterSectionResponse({this.success, this.count, this.data});

  factory FilterSectionResponse.fromJson(Map<String, dynamic> json) =>
      _$FilterSectionResponseFromJson(json);
}

@JsonSerializable()
class FilterSectionModel {
  final int? id;
  @JsonKey(name: 'plan_price')
  final String? planPrice;
  @JsonKey(name: 'plan_name')
  final String? planName;
  @JsonKey(name: 'transaction_type')
  final String? transactionType;
  final String? phone;
  @DynamicStringConverter()
  final String? status;
  final String? description;
  @JsonKey(name: 'auction_date')
  final String? auctionDate;
  final String? type;
  final String? region;
  @DynamicStringConverter()
  final String? price;
  final String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'share_code')
  final String? shareCode;
  @JsonKey(name: 'share_url')
  final String? shareUrl;

  FilterSectionModel({
    this.id,
    this.planPrice,
    this.planName,
    this.transactionType,
    this.phone,
    this.status,
    this.description,
    this.auctionDate,
    this.type,
    this.region,
    this.price,
    this.images,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.shareCode,
    this.shareUrl,
    this.publisherName,
    this.publisherLogo,
    this.publisherAccountType,
  });

  @JsonKey(name: 'publisher_name')
  final String? publisherName;
  @JsonKey(name: 'publisher_logo')
  final String? publisherLogo;
  @JsonKey(name: 'publisher_account_type')
  final String? publisherAccountType;

  // --- أضف الدالة هنا ---
  VipAdsDataResponse toVipResponse() {
    return VipAdsDataResponse(
      id: id,
      planPrice: planPrice,
      planName: planName,
      transactionType: transactionType,
      phone: phone,
      description: description,
      type: type.toString(),
      region: region,
      price: price,
      images: images,
      userId: userId,
      publisherName: publisherName,
      publisherLogo: publisherLogo,
      publisherAccountType: publisherAccountType,
    );
  }

  factory FilterSectionModel.fromJson(Map<String, dynamic> json) =>
      _$FilterSectionModelFromJson(json);
}

@JsonSerializable()
class PropertyTypesResponse {
  final bool? success;
  final String? message;
  final List<PropertyTypesResponseData>? data;

  PropertyTypesResponse({this.success, this.message, this.data});

  factory PropertyTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypesResponseFromJson(json);
}

@JsonSerializable()
class PropertyTypesResponseData {
  final int? id;
  final String? name;

  PropertyTypesResponseData({this.id, this.name});

  factory PropertyTypesResponseData.fromJson(Map<String, dynamic> json) =>
      _$PropertyTypesResponseDataFromJson(json);
}

@JsonSerializable()
class AreasResponse {
  final bool? success;
  final String? message;
  final List<AreaData>? data;

  AreasResponse({this.success, this.message, this.data});

  factory AreasResponse.fromJson(Map<String, dynamic> json) =>
      _$AreasResponseFromJson(json);
}

@JsonSerializable()
class AreaData {
  final int? id;
  final String? name;

  AreaData({this.id, this.name});

  factory AreaData.fromJson(Map<String, dynamic> json) =>
      _$AreaDataFromJson(json);
}

// ================= News =====================================

@JsonSerializable()
class NewsResponse {
  final bool? success;
  final List<NewsResponseData>? data;
  final String? message;

  NewsResponse({this.success, this.message, this.data});

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);
}

@JsonSerializable()
class NewsResponseData {
  final int? id;
  final String? title;
  final String? url;

  NewsResponseData({this.id, this.title, this.url});

  factory NewsResponseData.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseDataFromJson(json);
}

// ================ SearchFilterResponse =======================================

@JsonSerializable()
class SearchFilterResponse {
  final bool? success;
  final int? count;
  final List<SearchFilterData>? data;

  SearchFilterResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SearchFilterResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterResponseToJson(this);
}

@JsonSerializable()
class SearchFilterData {
  final int? id;
  @JsonKey(name: 'plan_price')
  final String? planPrice;
  @JsonKey(name: 'plan_name')
  final String? planName;
  @JsonKey(name: 'transaction_type')
  final String? transactionType;
  final String? phone;
  @DynamicStringConverter()
  final String? status;
  final String? description;
  @JsonKey(name: 'auction_date')
  final String? auctionDate;
  final String? type;
  final String? region;
  @DynamicStringConverter()
  final String? price;
  final String? images;
  @DynamicStringConverter()
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'share_code')
  final String? shareCode;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'share_url')
  final String? shareUrl;
  // === جديد: إحداثيات الموقع (لو الإعلان محدد موقعه على الخريطة)
  @DynamicDoubleConverter()
  final double? latitude;
  @DynamicDoubleConverter()
  final double? longitude;

  SearchFilterData({
    required this.id,
    required this.planPrice,
    required this.planName,
    required this.transactionType,
    required this.phone,
    required this.status,
    required this.description,
    required this.auctionDate,
    required this.type,
    required this.region,
    required this.price,
    required this.images,
    required this.userId,
    required this.shareCode,
    required this.createdAt,
    required this.updatedAt,
    required this.shareUrl,
    this.latitude,
    this.longitude,
  });

  factory SearchFilterData.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterDataToJson(this);
}
//==============================================================================

@JsonSerializable()
class CalculateMarketValueRsponse {
  final String? status;
  @JsonKey(name: 'estimated_value')
  final int? estimatedValue;
  final String? currency;
  CalculateMarketValueRsponseData? details;
  CalculateMarketValueRsponse(
      this.status, this.estimatedValue, this.currency, this.details);

  factory CalculateMarketValueRsponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateMarketValueRsponseFromJson(json);
}

@JsonSerializable()
class CalculateMarketValueRsponseData {
  @JsonKey(name: 'base_price')
  final int? basePrice;
  @JsonKey(name: 'land_impact')
  final int? landImpact;
  CalculateMarketValueRsponseData(this.basePrice, this.landImpact);

  factory CalculateMarketValueRsponseData.fromJson(Map<String, dynamic> json) =>
      _$CalculateMarketValueRsponseDataFromJson(json);
}
//==============================================================================

@JsonSerializable()
class CalculateConstructionCostRsponse {
  final String? status;
  @JsonKey(name: 'construction_estimate')
  final int? constructionEstimate;
  final String? currency;
  CalculateConstructionCostRsponseData? breakdown;
  CalculateConstructionCostRsponse(
      this.status, this.constructionEstimate, this.currency, this.breakdown);

  factory CalculateConstructionCostRsponse.fromJson(
          Map<String, dynamic> json) =>
      _$CalculateConstructionCostRsponseFromJson(json);
}

@JsonSerializable()
class CalculateConstructionCostRsponseData {
  @JsonKey(name: 'structure_and_finishing')
  final int? structureAndFinishing;
  final int? elevators;
  @JsonKey(name: 'basement_extra')
  final int? basementExtra;
  @JsonKey(name: 'avg_cost_per_meter')
  final double? avg_costPerMeter;
  CalculateConstructionCostRsponseData(this.structureAndFinishing,
      this.elevators, this.basementExtra, this.avg_costPerMeter);

  factory CalculateConstructionCostRsponseData.fromJson(
          Map<String, dynamic> json) =>
      _$CalculateConstructionCostRsponseDataFromJson(json);
}

// ============= Amenities (الميزات المتاحة - يديرها الأدمن)
@JsonSerializable()
class AmenityData {
  int? id;
  String? name;
  String? icon; // مفتاح نصي زي 'wifi'، 'pool' - يترجم لأيقونة عن طريق amenityIconFor()

  AmenityData({this.id, this.name, this.icon});

  factory AmenityData.fromJson(Map<String, dynamic> json) =>
      _$AmenityDataFromJson(json);
  Map<String, dynamic> toJson() => _$AmenityDataToJson(this);
}

@JsonSerializable()
class AmenitiesResponse {
  bool? status;
  List<AmenityData>? data;

  AmenitiesResponse({this.status, this.data});

  factory AmenitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$AmenitiesResponseFromJson(json);
}
