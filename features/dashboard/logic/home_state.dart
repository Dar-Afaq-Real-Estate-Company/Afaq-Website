import 'dart:io';

import 'package:flutter/src/widgets/basic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/api_error_model.dart';
import '../data/response/response.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.allAdsLoading() = AllAdsLoading;
  const factory HomeState.allAdsSuccess(AdsResponse adsResponse) =
      AllAdsSuccess;
  const factory HomeState.allAdsError(ApiErrorModel apiErrorModel) =
      AllAdsError;

//************* vip Ads State **************************************************
  const factory HomeState.vipAdsLoading() = VipAdsLoading;
  const factory HomeState.vipAdsSuccess(HomeResponse homeResponse) =
      VipAdsSuccess;
  const factory HomeState.vipAdsError(ApiErrorModel apiErrorModel) =
      VipAdsError;
}

@freezed
class AddAdvertisementState with _$AddAdvertisementState {
  const factory AddAdvertisementState.initial() = _AddAdvertisementInitial;

  const factory AddAdvertisementState.addAdvertisementLoading() =
      AddAdvertisementLoading;
  const factory AddAdvertisementState.addAdvertisementSuccess(
          AddAdvertisementResponse addAdvertisementResponse) =
      AddAdvertisementSuccess;
  const factory AddAdvertisementState.addAdvertisementError(
      ApiErrorModel apiErrorModel) = AddAdvertisementError;

  const factory AddAdvertisementState.imagePicked(File image) = ImagePicked;

  const factory AddAdvertisementState.propertyTypeChanged(String type) =
      PropertyTypeChanged;
  const factory AddAdvertisementState.regionChanged(String region) =
      RegionChanged;

  const factory AddAdvertisementState.propertyTypesLoading() =
      PropertyTypesLoading;
  const factory AddAdvertisementState.propertyTypesSuccess(
      List<String> propertyTypes) = PropertyTypesSuccess;
  const factory AddAdvertisementState.propertyTypesError(
      ApiErrorModel apiErrorModel) = PropertyTypesError;

  const factory AddAdvertisementState.regionsLoading() = RegionsLoading;
  const factory AddAdvertisementState.regionsSuccess(List<String> regions) =
      RegionsSuccess;
  const factory AddAdvertisementState.regionsError(
      ApiErrorModel apiErrorModel) = RegionsError;
  // داخل ملف الـ State
  const factory AddAdvertisementState.transactionTypeChanged(String type) =
      TransactionTypeChanged;

  // === جديد: حالات الميزات (مواقف سيارات، حمام سباحة، حديقة...)
  const factory AddAdvertisementState.amenitiesLoading() = AmenitiesLoading;
  const factory AddAdvertisementState.amenitiesSuccess(
      List<AmenityData> amenities) = AmenitiesSuccess;
  const factory AddAdvertisementState.amenitiesError(
      ApiErrorModel apiErrorModel) = AmenitiesError;
  const factory AddAdvertisementState.amenityToggled(int amenityId) =
      AmenityToggled;
}

@freezed
class ShowUserAdsState with _$ShowUserAdsState {
  const factory ShowUserAdsState.initial() = _ShowUserAdsInitial;

  // حالات جلب إعلانات المستخدم الخاص (My Ads)
  const factory ShowUserAdsState.showUserAdsLoading() = ShowUserAdsLoading;
  const factory ShowUserAdsState.showUserAdsSuccess(
      ShowUserAdResponse showUserAdResponse) = ShowUserAdsSuccess;
  const factory ShowUserAdsState.showUserAdsError(ApiErrorModel apiErrorModel) =
      ShowUserAdsError;

  // // حالات جلب تفاصيل إعلان محدد (Ad Details)
  // const factory UserAdsState.adDetailsLoading() = AdDetailsLoading;
  // const factory UserAdsState.adDetailsSuccess(ShowAdResponse showAdResponse) = AdDetailsSuccess;
  // const factory UserAdsState.adDetailsError(ApiErrorModel apiErrorModel) = AdDetailsError;
}

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _NotificationsInitial;
  const factory NotificationsState.notificationsLoading() =
      NotificationssLoading;
  const factory NotificationsState.notificationsSuccess(
      NotificationsResponse notificationsResponse) = NotificationsSuccess;
  const factory NotificationsState.notificationsError(
      ApiErrorModel apiErrorModel) = NotificationsError;
}

// ============= NewsState =====================================================
@freezed
class NewsState with _$NewsState {
  const factory NewsState.initial() = _NewsInitial;

  const factory NewsState.newsLoading() = NewsLoading;

  const factory NewsState.newsSuccess(NewsResponse newsResponse) = NewsSuccess;

  const factory NewsState.newsError(ApiErrorModel apiErrorModel) = NewsError;
}

//======== Delete Ad State =====================================================
@freezed
class DeleteState with _$DeleteState {
  const factory DeleteState.initial() = _DeleteStateInitial;
  const factory DeleteState.deleteLoading() = DeleteLoading;
  const factory DeleteState.deleteSuccess(DeleteAdResponse deleteAdResponse) =
      DeleteSuccess;
  const factory DeleteState.deleteError(ApiErrorModel apiErrorModel) =
      DeleteError;
}

//======= Update Ad State ======================================================

@freezed
class UpdateAdState with _$UpdateAdState {
  const factory UpdateAdState.initial() = _UpdateAdInitial;
  const factory UpdateAdState.updateAdLoading() = UpdateAdLoading;
  const factory UpdateAdState.updateAdSuccess(
      UpdateAdResponse updateAdResponse) = UpdateAdSuccess;
  const factory UpdateAdState.updateAdError(ApiErrorModel apiErrorModel) =
      UpdateAdStateError;

  const factory UpdateAdState.updateAdImagePicked(File image) =
      UpdateAdImagePicked;

  // === جديد: تبديل اختيار الميزة + جلب قائمة الميزات لصفحة التعديل
  const factory UpdateAdState.amenityToggled(int amenityId) =
      UpdateAdAmenityToggled;
  const factory UpdateAdState.amenitiesLoading() = UpdateAdAmenitiesLoading;
  const factory UpdateAdState.amenitiesSuccess(List<AmenityData> amenities) =
      UpdateAdAmenitiesSuccess;
  const factory UpdateAdState.amenitiesError(ApiErrorModel apiErrorModel) =
      UpdateAdAmenitiesError;
}

@freezed
class FilterState with _$FilterState {
  const factory FilterState.initial() = _FilterInitial;
  const factory FilterState.filterLoading() = FilterLoading;
  const factory FilterState.filterSuccess(SearchAdsResponse searchAdsResponse) =
      FilterSuccess;
  const factory FilterState.filterError(ApiErrorModel apiErrorModel) =
      FilterError;
}

@freezed
class FilterSectionState with _$FilterSectionState {
  const factory FilterSectionState.initial() = _FilterSectionInitial;
  const factory FilterSectionState.filterSectionLoading() =
      FilterSectionLoading;
  const factory FilterSectionState.filterSectionSuccess(
      FilterSectionResponse filterSectionResponse) = FilterSectionSuccess;
  const factory FilterSectionState.filterSectionError(
      ApiErrorModel apiErrorModel) = FilterSectionError;
}
//==============================================================================

@freezed
class UserMonthlyPointsState with _$UserMonthlyPointsState {
  const factory UserMonthlyPointsState.initial() = UserMonthlyPointsInitial;
  const factory UserMonthlyPointsState.userMonthlyPointsLoading() =
      UserMonthlyPointsLoading;
  const factory UserMonthlyPointsState.userMonthlyPointsSuccess(
          UserMonthlyPointsResponse userMonthlyPointsResponse) =
      UserMonthlyPointsSuccess;
  const factory UserMonthlyPointsState.userMonthlyPointsError(
      ApiErrorModel apiErrorModel) = UserMonthlyPointsError;
}

//************* searchFilter State *********************************************
@freezed
class SearchFilterState with _$SearchFilterState {
  const factory SearchFilterState.initial() = _SearchFilterStateInitial;

  const factory SearchFilterState.searchFilterLoading() = SearchFilterLoading;
  const factory SearchFilterState.searchFilterSuccess(
      SearchFilterResponse searchFilterResponse) = SearchFilterSuccess;
  const factory SearchFilterState.searchFilterError(
      ApiErrorModel apiErrorModel) = SearchFilterError;
}

@freezed
class CalculateMarketValueState with _$CalculateMarketValueState {
  const factory CalculateMarketValueState.initial() =
      _CalculateMarketValueInitial;
  const factory CalculateMarketValueState.calculateMarketValueLoading() =
      CalculateMarketValueLoading;
  const factory CalculateMarketValueState.calculateMarketValueSuccess(
          CalculateMarketValueRsponse calculateMarketValueRsponse) =
      CalculateMarketValueSuccess;
  const factory CalculateMarketValueState.calculateMarketValueError(
      ApiErrorModel apiErrorModel) = CalculateMarketValueError;
}

@freezed
class CalculateConstructionCostState with _$CalculateConstructionCostState {
  const factory CalculateConstructionCostState.initial() =
      _CalculateConstructionCostInitial;
  const factory CalculateConstructionCostState.calculateConstructionCostLoading() =
      CalculateConstructionCostLoading;
  const factory CalculateConstructionCostState.calculateConstructionCostSuccess(
          CalculateConstructionCostRsponse calculateConstructionCostRsponse) =
      CalculateConstructionCostSuccess;
  const factory CalculateConstructionCostState.calculateConstructionCostError(
      ApiErrorModel apiErrorModel) = CalculateConstructionCostError;
}
