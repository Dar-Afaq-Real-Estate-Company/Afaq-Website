/// موديل بيانات الفندق - قسم "Hotels" الجديد بالكامل، مستقل عن الموديلات
/// القديمة. يقرأ نفس استجابة الـ API الحالية (GET/POST hotels-apartments).
class HotelModel {
  final int? id;
  final String? name;
  final String? region;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? phone;
  final String? whatsapp;
  final List<String> amenities;
  final List<String> views;
  final List<String> images;
  final double nightPrice;
  final List<HotelRoomModel> rooms;

  HotelModel({
    this.id,
    this.name,
    this.region,
    this.latitude,
    this.longitude,
    this.description,
    this.phone,
    this.whatsapp,
    required this.amenities,
    required this.views,
    required this.images,
    required this.nightPrice,
    required this.rooms,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      region: json['region']?.toString(),
      latitude: json['latitude'] != null ? double.tryParse('${json['latitude']}') : null,
      longitude: json['longitude'] != null ? double.tryParse('${json['longitude']}') : null,
      description: json['description']?.toString(),
      phone: json['phone']?.toString(),
      whatsapp: json['whatsapp']?.toString() ?? json['phone']?.toString(),
      amenities: (json['amenities'] as List?)?.map((e) => e.toString()).toList() ?? [],
      views: (json['views'] as List?)?.map((e) => e.toString()).toList() ?? [],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      nightPrice: double.tryParse('${json['prices']?['night'] ?? json['price_per_night'] ?? 0}') ?? 0,
      rooms: (json['rooms'] as List?)?.map((e) => HotelRoomModel.fromJson(e)).toList() ?? [],
    );
  }
}

class HotelRoomModel {
  final String roomType;
  final int capacity;
  final double pricePerNight;
  final int roomsCount;

  HotelRoomModel({
    required this.roomType,
    required this.capacity,
    required this.pricePerNight,
    required this.roomsCount,
  });

  factory HotelRoomModel.fromJson(Map<String, dynamic> json) => HotelRoomModel(
        roomType: json['room_type']?.toString() ?? '',
        capacity: json['capacity'] is int ? json['capacity'] : int.tryParse('${json['capacity']}') ?? 1,
        pricePerNight: double.tryParse('${json['price_per_night'] ?? 0}') ?? 0,
        roomsCount: json['rooms_count'] is int ? json['rooms_count'] : int.tryParse('${json['rooms_count']}') ?? 1,
      );
}

/// أوصاف ثابتة للمرافق والإطلالات - نفس المفاتيح اللي يخزّنها السيرفر
class HotelAmenities {
  static const Map<String, Map<String, dynamic>> options = {
    'wifi': {'label': 'واي فاي', 'icon': 'wifi'},
    'breakfast': {'label': 'إفطار', 'icon': 'breakfast'},
    'lunch': {'label': 'غداء', 'icon': 'lunch'},
    'dinner': {'label': 'عشاء', 'icon': 'dinner'},
    'pool': {'label': 'مسبح', 'icon': 'pool'},
    'parking': {'label': 'مواقف', 'icon': 'parking'},
  };
}

class HotelViews {
  static const Map<String, Map<String, dynamic>> options = {
    'sea': {'label': 'بحرية', 'icon': 'sea'},
    'city': {'label': 'مدينة', 'icon': 'city'},
    'pool': {'label': 'مسبح', 'icon': 'pool'},
    'garden': {'label': 'حديقة', 'icon': 'garden'},
  };
}
