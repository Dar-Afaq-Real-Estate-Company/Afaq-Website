import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/hotel_model.dart';
import '../data/hotels_repository.dart';

abstract class HotelsListState {}
class HotelsListLoading extends HotelsListState {}
class HotelsListSuccess extends HotelsListState {
  final List<HotelModel> hotels;
  HotelsListSuccess(this.hotels);
}
class HotelsListError extends HotelsListState {
  final String message;
  HotelsListError(this.message);
}

class HotelsListCubit extends Cubit<HotelsListState> {
  HotelsListCubit() : super(HotelsListLoading());

  String? region;
  double minPrice = 0;
  double maxPrice = 500;
  final Set<String> amenityFilter = {};

  Future<void> load() async {
    emit(HotelsListLoading());
    try {
      final hotels = await HotelsRepository.fetchAll(region: region, minPrice: minPrice, maxPrice: maxPrice);
      final filtered = amenityFilter.isEmpty
          ? hotels
          : hotels.where((h) => amenityFilter.every((a) => h.amenities.contains(a))).toList();
      emit(HotelsListSuccess(filtered));
    } catch (_) {
      emit(HotelsListError('تعذر تحميل الفنادق، تأكد من اتصالك بالإنترنت'));
    }
  }

  void setRegion(String? value) {
    region = value;
    load();
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    load();
  }

  void toggleAmenityFilter(String key) {
    amenityFilter.contains(key) ? amenityFilter.remove(key) : amenityFilter.add(key);
    load();
  }
}

abstract class AddHotelState {}
class AddHotelInitial extends AddHotelState {}
class AddHotelSubmitting extends AddHotelState {}
class AddHotelSuccess extends AddHotelState {}
class AddHotelFailure extends AddHotelState {
  final String message;
  AddHotelFailure(this.message);
}

class AddHotelCubit extends Cubit<AddHotelState> {
  AddHotelCubit() : super(AddHotelInitial());

  String name = '';
  String region = '';
  double? latitude;
  double? longitude;
  String phone = '';
  String? whatsapp;
  bool sameAsPhoneForWhatsapp = true;
  String description = '';
  final Set<String> amenities = {};
  final Set<String> views = {};
  final List<File> images = [];

  // === سعر الليلة للغرفة (أساسي)، وسعر الليلة للجناح (اختياري لو الفندق يحتوي أجنحة)
  String roomPrice = '';
  bool hasSuites = false;
  String suitePrice = '';

  Future<void> submit() async {
    if (name.isEmpty || region.isEmpty || phone.isEmpty || roomPrice.isEmpty || images.length < 3) {
      emit(AddHotelFailure('يرجى تعبئة جميع الحقول المطلوبة وإضافة 3 صور على الأقل'));
      return;
    }
    if (hasSuites && suitePrice.isEmpty) {
      emit(AddHotelFailure('يرجى كتابة سعر الليلة للجناح'));
      return;
    }
    emit(AddHotelSubmitting());
    try {
      final base64Images = <String>[];
      for (final f in images) {
        base64Images.add(base64Encode(await f.readAsBytes()));
      }
      final rooms = <Map<String, dynamic>>[
        {'room_type': 'غرفة', 'capacity': 2, 'price_per_night': double.tryParse(roomPrice) ?? 0, 'rooms_count': 1},
        if (hasSuites)
          {'room_type': 'جناح', 'capacity': 2, 'price_per_night': double.tryParse(suitePrice) ?? 0, 'rooms_count': 1},
      ];
      final ok = await HotelsRepository.add(
        name: name,
        region: region,
        latitude: latitude,
        longitude: longitude,
        pricePerNight: double.tryParse(roomPrice) ?? 0,
        description: description.isEmpty ? null : description,
        phone: phone,
        whatsapp: sameAsPhoneForWhatsapp ? phone : whatsapp,
        amenities: amenities.toList(),
        views: views.toList(),
        imagesBase64: base64Images,
        rooms: rooms,
      );
      emit(ok ? AddHotelSuccess() : AddHotelFailure('تعذر نشر الفندق، حاول مرة أخرى'));
    } catch (_) {
      emit(AddHotelFailure('تعذر الاتصال بالسيرفر'));
    }
  }
}
