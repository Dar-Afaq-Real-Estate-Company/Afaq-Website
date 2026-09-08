// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAdvertisementRequest _$AddAdvertisementRequestFromJson(
        Map<String, dynamic> json) =>
    AddAdvertisementRequest(
      selectedPlanPrice: (json['selected_plan_price'] as num).toInt(),
      selectedPlanName: json['selected_plan_name'] as String,
      transactionType: json['transaction_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      region: json['region'] as String,
      price: json['price'] as String,
      hasCommission: json['has_commission'] as bool?,
      commissionPercent: json['commission_percent'] as String?,
      phone: json['phone'] as String,
      userId: (json['user_id'] as num).toInt(),
      image: json['image_base64'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      rooms: (json['rooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      halls: (json['halls'] as num?)?.toInt(),
      kitchens: (json['kitchens'] as num?)?.toInt(),
      area: json['area'] as String?,
      floorsCount: (json['floors_count'] as num?)?.toInt(),
      rentedFloor: json['rented_floor'] as String?,
      floorsDetails: json['floors_details'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      propertySection: json['property_section'] as String?,
      landType: json['land_type'] as String?,
      extraFeatures: json['extra_features'] as String?,
      hasPool: json['has_pool'] as bool?,
      hasGarden: json['has_garden'] as bool?,
      hasParking: json['has_parking'] as bool?,
      isFeatured: json['is_featured'] as bool?,
    );

Map<String, dynamic> _$AddAdvertisementRequestToJson(
        AddAdvertisementRequest instance) =>
    <String, dynamic>{
      'selected_plan_price': instance.selectedPlanPrice,
      'selected_plan_name': instance.selectedPlanName,
      'transaction_type': instance.transactionType,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'region': instance.region,
      'price': instance.price,
      'has_commission': instance.hasCommission,
      'commission_percent': instance.commissionPercent,
      'phone': instance.phone,
      'user_id': instance.userId,
      'image_base64': instance.image,
      'amenities': instance.amenities,
      'rooms': instance.rooms,
      'bathrooms': instance.bathrooms,
      'halls': instance.halls,
      'kitchens': instance.kitchens,
      'area': instance.area,
      'floors_count': instance.floorsCount,
      'rented_floor': instance.rentedFloor,
      'floors_details': instance.floorsDetails,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'property_section': instance.propertySection,
      'land_type': instance.landType,
      'extra_features': instance.extraFeatures,
      'has_pool': instance.hasPool,
      'has_garden': instance.hasGarden,
      'has_parking': instance.hasParking,
      'is_featured': instance.isFeatured,
    };

ShowUserAdRequest _$ShowUserAdRequestFromJson(Map<String, dynamic> json) =>
    ShowUserAdRequest(
      userId: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$ShowUserAdRequestToJson(ShowUserAdRequest instance) =>
    <String, dynamic>{
      'id': instance.userId,
    };

DeleteAdRequest _$DeleteAdRequestFromJson(Map<String, dynamic> json) =>
    DeleteAdRequest(
      userId: (json['user_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$DeleteAdRequestToJson(DeleteAdRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'id': instance.id,
    };

UpdateAdvertisementRequest _$UpdateAdvertisementRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateAdvertisementRequest(
      selectedPlanPrice: (json['selected_plan_price'] as num).toInt(),
      selectedPlanName: json['selected_plan_name'] as String,
      transactionType: json['transaction_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      region: json['region'] as String,
      price: json['price'] as String,
      phone: json['phone'] as String,
      userId: (json['user_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      image: json['image_base64'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      rooms: (json['rooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      halls: (json['halls'] as num?)?.toInt(),
      area: json['area'] as String?,
      floorsCount: (json['floors_count'] as num?)?.toInt(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateAdvertisementRequestToJson(
        UpdateAdvertisementRequest instance) =>
    <String, dynamic>{
      'selected_plan_price': instance.selectedPlanPrice,
      'selected_plan_name': instance.selectedPlanName,
      'transaction_type': instance.transactionType,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'region': instance.region,
      'price': instance.price,
      'phone': instance.phone,
      'user_id': instance.userId,
      'id': instance.id,
      'image_base64': instance.image,
      'amenities': instance.amenities,
      'rooms': instance.rooms,
      'bathrooms': instance.bathrooms,
      'halls': instance.halls,
      'area': instance.area,
      'floors_count': instance.floorsCount,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

AdsSearchRequest _$AdsSearchRequestFromJson(Map<String, dynamic> json) =>
    AdsSearchRequest(
      region: json['region'] as String?,
      transactionType: json['transaction_type'] as String?,
    );

Map<String, dynamic> _$AdsSearchRequestToJson(AdsSearchRequest instance) =>
    <String, dynamic>{
      'region': instance.region,
      'transaction_type': instance.transactionType,
    };

UserMonthlyPointsRequest _$UserMonthlyPointsRequestFromJson(
        Map<String, dynamic> json) =>
    UserMonthlyPointsRequest(
      userId: (json['user_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserMonthlyPointsRequestToJson(
        UserMonthlyPointsRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
    };

FilterSectionRequest _$FilterSectionRequestFromJson(
        Map<String, dynamic> json) =>
    FilterSectionRequest(
      section: json['section'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$FilterSectionRequestToJson(
        FilterSectionRequest instance) =>
    <String, dynamic>{
      'section': instance.section,
      'type': instance.type,
    };

SearchFilterRequest _$SearchFilterRequestFromJson(Map<String, dynamic> json) =>
    SearchFilterRequest(
      transactionType: json['transaction_type'] as String,
      type: (json['type'] as List<dynamic>).map((e) => e as String).toList(),
      region:
          (json['region'] as List<dynamic>).map((e) => e as String).toList(),
      priceRange: json['price_range'] as String,
    );

Map<String, dynamic> _$SearchFilterRequestToJson(
        SearchFilterRequest instance) =>
    <String, dynamic>{
      'transaction_type': instance.transactionType,
      'type': instance.type,
      'region': instance.region,
      'price_range': instance.priceRange,
    };

CalculateMarketValueRequest _$CalculateMarketValueRequestFromJson(
        Map<String, dynamic> json) =>
    CalculateMarketValueRequest(
      landSize: (json['land_size'] as num).toInt(),
      location: json['location'] as String,
      position: (json['position'] as num).toInt(),
      buildingAge: json['building_age'] as String,
      finishingLevel: (json['finishing_level'] as num).toInt(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CalculateMarketValueRequestToJson(
        CalculateMarketValueRequest instance) =>
    <String, dynamic>{
      'land_size': instance.landSize,
      'location': instance.location,
      'position': instance.position,
      'building_age': instance.buildingAge,
      'finishing_level': instance.finishingLevel,
      'features': instance.features,
    };

CalculateConstructionCostRequest _$CalculateConstructionCostRequestFromJson(
        Map<String, dynamic> json) =>
    CalculateConstructionCostRequest(
      buildingArea: (json['building_area'] as num).toInt(),
      structureType: (json['structure_type'] as num).toInt(),
      finishingType: (json['finishing_type'] as num).toInt(),
      acType: (json['ac_type'] as num).toInt(),
      energySaving: json['energy_saving'] as bool,
      elevators: (json['elevators'] as num).toInt(),
      plumbingType: (json['plumbing_type'] as num).toInt(),
      hasBasement: json['has_basement'] as bool,
    );

Map<String, dynamic> _$CalculateConstructionCostRequestToJson(
        CalculateConstructionCostRequest instance) =>
    <String, dynamic>{
      'building_area': instance.buildingArea,
      'structure_type': instance.structureType,
      'finishing_type': instance.finishingType,
      'ac_type': instance.acType,
      'energy_saving': instance.energySaving,
      'elevators': instance.elevators,
      'plumbing_type': instance.plumbingType,
      'has_basement': instance.hasBasement,
    };
