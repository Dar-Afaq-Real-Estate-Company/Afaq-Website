import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/helper/constants.dart';
import '../../../core/helper/shared_pref.dart';
import '../../../core/network/api_error_model.dart';
import '../../../core/resources/strings_manager.dart';
import '../data/repository/home_repository.dart';
import '../data/requests/requests.dart';
import '../data/response/response.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(const HomeState.initial());
  List<AdsDataResponse?>? specializationsList = [];
  List<SearchFilterData?>? searchFilterDataList = [];
  List<VipAdsDataResponse?>? vipAdsDataResponseList = [];

  void getAllAds() async {
    emit(const HomeState.allAdsLoading());
    final response = await _homeRepository.getAllAds();
    response.when(
      success: (specializationsResponseModel) {
        specializationsList = specializationsResponseModel.allAds ?? [];
        emit(HomeState.allAdsSuccess(specializationsResponseModel));
      },
      failure: (errorHandler) {
        emit(HomeState.allAdsError(errorHandler));
      },
    );
  }

  void getVipAds() async {
    emit(const HomeState.vipAdsLoading());
    final response = await _homeRepository.getHome();
    response.when(
      success: (homeResponse) {
        vipAdsDataResponseList = homeResponse.vipAds ?? [];
        emit(HomeState.vipAdsSuccess(homeResponse));
      },
      failure: (errorHandler) {
        emit(HomeState.vipAdsError(errorHandler));
      },
    );
  }
}



class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}


class FloorEntry {
  TextEditingController apartmentsCountController = TextEditingController(text: '1');
  List<ApartmentEntry> apartments = [ApartmentEntry()];
}

class ApartmentEntry {
  TextEditingController roomsController = TextEditingController();
  TextEditingController bathroomsController = TextEditingController();
  TextEditingController hallsController = TextEditingController();
  TextEditingController kitchensController = TextEditingController();
  TextEditingController areaController = TextEditingController();
}

class AddAdvertisementCubit extends Cubit<AddAdvertisementState> {
  final AddAdvertisementRepository _addAdvertisementRepository;
  final HomeRepository _homeRepository;
  AddAdvertisementCubit(this._addAdvertisementRepository, this._homeRepository)
      : super(const AddAdvertisementState.initial());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  // === العمولة: ثلاث حالات - عمولة (بنسبة) / بدون عمولة / عدم ذكر (فاضي)
  TextEditingController commissionController = TextEditingController();
  String commissionChoice = 'unspecified'; // 'with' | 'without' | 'unspecified'
  // === تفاصيل العقار (عنوان الإعلان، غرف، حمامات، صالات، مساحة، عنوان تفصيلي)
  TextEditingController titleController = TextEditingController();
  TextEditingController roomsController = TextEditingController();
  TextEditingController bathroomsController = TextEditingController();
  TextEditingController hallsController = TextEditingController();
  TextEditingController kitchensController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController floorsCountController = TextEditingController();
  TextEditingController rentedFloorController = TextEditingController();
  TextEditingController extraFeaturesController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // === خدمات إضافية سريعة (مسبح/حديقة/مواقف)
  bool hasPool = false;
  bool hasGarden = false;
  bool hasParking = false;
  void togglePool() {
    hasPool = !hasPool;
    _forceRebuild();
  }
  void toggleGarden() {
    hasGarden = !hasGarden;
    _forceRebuild();
  }
  void toggleParking() {
    hasParking = !hasParking;
    _forceRebuild();
  }
  List<FloorEntry> floorsDetails = [];

  int _refreshTick = 0;
  void _forceRebuild() {
    emit(AddAdvertisementState.regionChanged('__refresh_${_refreshTick++}'));
  }

  void setFloorsCount(int count) {
    if (count < 0) return;
    floorsCountController.text = count.toString();
    if (count < floorsDetails.length) {
      floorsDetails = floorsDetails.sublist(0, count);
    } else {
      while (floorsDetails.length < count) {
        floorsDetails.add(FloorEntry());
      }
    }
    _forceRebuild();
  }

  void setApartmentsCountForFloor(int floorIndex, int count) {
    if (count < 0 || floorIndex >= floorsDetails.length) return;
    final floor = floorsDetails[floorIndex];
    floor.apartmentsCountController.text = count.toString();
    if (count < floor.apartments.length) {
      floor.apartments = floor.apartments.sublist(0, count);
    } else {
      while (floor.apartments.length < count) {
        floor.apartments.add(ApartmentEntry());
      }
    }
    _forceRebuild();
  }

  String? get floorsDetailsJson {
    if (floorsDetails.isEmpty) return null;
    final list = floorsDetails.asMap().entries.map((entry) {
      final floor = entry.value;
      return {
        'floor': entry.key + 1,
        'apartments': floor.apartments.map((apt) {
          return {
            'rooms': int.tryParse(apt.roomsController.text),
            'bathrooms': int.tryParse(apt.bathroomsController.text),
            'halls': int.tryParse(apt.hallsController.text),
            'kitchens': int.tryParse(apt.kitchensController.text),
            'area': apt.areaController.text.isEmpty ? null : apt.areaController.text,
          };
        }).toList(),
      };
    }).toList();
    return jsonEncode(list);
  }

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? selectedPropertyType;
  String? selectedPropertySection;
  String? selectedLandType;
  String? selectedRegion;
  String selectedPlanName = "الأساسية";
  int selectedPlanPrice = 100;
  String selectedTransactionType = '';

  List<String> propertyTypes = [];

  List<String> selectedPropertyTypes = [];
  List<String> selectedRegions = [];

  // === الميزات (يديرها الأدمن)
  List<AmenityData> amenities = [];
  Set<int> selectedAmenityIds = {};
  bool amenitiesLoading = false;
  // === "المشاريع المميزة" - خيار إداري فقط، يظهر بشريط العروض المميزة
  bool isFeatured = false;

  void updateTransactionType(String type) {
    selectedTransactionType = type;
    emit(const AddAdvertisementState.initial());
  }

  //============================================================================
  void togglePropertyType(String value) {
    if (selectedPropertyTypes.contains(value)) {
      selectedPropertyTypes.remove(value);
    } else {
      selectedPropertyTypes.add(value);
    }
    emit(AddAdvertisementState.propertyTypeChanged(value));
  }

  //============================================================================
  void toggleRegion(String value) {
    if (selectedRegions.contains(value)) {
      selectedRegions.remove(value);
    } else {
      selectedRegions.add(value);
    }
    emit(AddAdvertisementState.regionChanged(value));
  }

  //============================================================================

  void getPropertyTypes() async {
    if (propertyTypes.isNotEmpty) return; // Don't fetch if already loaded
    emit(const AddAdvertisementState.propertyTypesLoading());
    final response = await _homeRepository.getPropertyTypes();
    response.when(
      success: (propertyTypesResponse) {
        propertyTypes = propertyTypesResponse.data
                ?.map((item) => item.name ?? '')
                .toList() ??
            [];
        emit(AddAdvertisementState.propertyTypesSuccess(propertyTypes));
      },
      failure: (errorHandler) {
        emit(AddAdvertisementState.propertyTypesError(errorHandler));
      },
    );
  }

  List<String> regions = [];

  void updateRegion(String value) {
    selectedRegion = value;
    selectedRegions = [value];
    emit(AddAdvertisementState.regionChanged(value));
  }

  // يستخدمها شيت اختيار المناطق المتعدد (نفس تصميم البحث المستخدم بالفنادق)
  void setSelectedRegions(List<String> values) {
    selectedRegions = values;
    emit(AddAdvertisementState.regionChanged(values.isEmpty ? '' : values.last));
  }

  void getRegions() async {
    if (regions.isNotEmpty) return; // already loaded
    emit(const AddAdvertisementState.regionsLoading());
    final response = await _homeRepository.getAreas();
    response.when(
      success: (areasResponse) {
        regions = areasResponse.data?.map((d) => d.name ?? '').toList() ?? [];
        emit(AddAdvertisementState.regionsSuccess(regions));
      },
      failure: (errorHandler) {
        emit(AddAdvertisementState.regionsError(errorHandler));
      },
    );
  }

  void updatePropertyType(String value) {
    selectedPropertyType = value;
    selectedRegions = [value];
    titleController.clear();
    roomsController.clear();
    bathroomsController.clear();
    hallsController.clear();
    kitchensController.clear();
    areaController.clear();
    floorsCountController.clear();
    rentedFloorController.clear();
    floorsDetails = [];
    emit(AddAdvertisementState.propertyTypeChanged(value));
  }

  void updatePropertySection(String value) {
    selectedPropertySection = value;
    emit(const AddAdvertisementState.initial());
  }

  void updateLandType(String value) {
    selectedLandType = value;
    emit(AddAdvertisementState.propertyTypeChanged(value));
  }

  // === جلب الميزات المتاحة (يديرها الأدمن) وتبديل الاختيار
  void getAmenities() async {
    if (amenities.isNotEmpty) return;
    amenitiesLoading = true;
    _forceRebuild();
    final response = await _homeRepository.getAmenities();
    response.when(
      success: (amenitiesResponse) {
        amenities = amenitiesResponse.data ?? [];
        amenitiesLoading = false;
        _forceRebuild();
      },
      failure: (errorHandler) {
        amenitiesLoading = false;
        _forceRebuild();
      },
    );
  }

  void toggleAmenity(int amenityId) {
    if (selectedAmenityIds.contains(amenityId)) {
      selectedAmenityIds.remove(amenityId);
    } else {
      selectedAmenityIds.add(amenityId);
    }
    _forceRebuild();
  }

// ********************* ImageSource *******************************************
  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      emit(const AddAdvertisementState.initial());
      emit(AddAdvertisementState.imagePicked(selectedImage!));
    }
  }

  void showImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppStrings.photoShoot.tr()),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppStrings.chooseFromGallery.tr()),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
//******************************************************************************

  void setPackageDetails(String name, int price) {
    selectedPlanName = name;
    selectedPlanPrice = price;
    emit(const AddAdvertisementState.initial());
  }

  void getAddAdvertisement({double? latitude, double? longitude}) async {
    if (selectedPropertyType == null || selectedRegion == null) {
      emit(AddAdvertisementState.addAdvertisementError(
          ApiErrorModel(message: 'يرجى اختيار نوع العقار والمنطقة أولاً')));
      return;
    }
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    final String userPhone =
        await SharedPrefHelper.getString(SharedPrefKeys.userPhone);
    emit(const AddAdvertisementState.addAdvertisementLoading());
    String? base64Image;
    if (selectedImage != null) {
      List<int> imageBytes = await selectedImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    final response = await _addAdvertisementRepository.addAdvertisement(
      AddAdvertisementRequest(
        description: descriptionController.text,
        selectedPlanPrice: selectedPlanPrice,
        selectedPlanName: selectedPlanName,
        transactionType: selectedTransactionType,
        title: titleController.text,
        type: selectedPropertyType!,
        region: selectedRegion!,
        price: selectedTransactionType.contains('بدل')
            ? '0'
            : priceController.text,
        hasCommission: commissionChoice == 'unspecified' ? null : commissionChoice == 'with',
        commissionPercent:
            commissionChoice == 'with' ? commissionController.text.trim() : null,
        phone: userPhone,
        userId: userId,
        image: base64Image,
        amenities: selectedAmenityIds.toList(),
        rooms: int.tryParse(roomsController.text),
        bathrooms: int.tryParse(bathroomsController.text),
        halls: int.tryParse(hallsController.text),
        kitchens: int.tryParse(kitchensController.text),
        area: areaController.text.isEmpty ? null : areaController.text,
        floorsCount: int.tryParse(floorsCountController.text),
        rentedFloor: rentedFloorController.text.isEmpty
            ? null
            : rentedFloorController.text,
        floorsDetails: floorsDetailsJson,
        address:
            addressController.text.isEmpty ? null : addressController.text,
        latitude: latitude,
        longitude: longitude,
        propertySection: selectedPropertySection,
        landType: selectedLandType,
        extraFeatures: extraFeaturesController.text.trim().isEmpty
            ? null
            : extraFeaturesController.text.trim(),
        hasPool: hasPool,
        hasGarden: hasGarden,
        hasParking: hasParking,
        isFeatured: isFeatured,
      ),
    );
    response.when(
      success: (addAdvertisementModel) {
        emit(AddAdvertisementState.addAdvertisementSuccess(
            addAdvertisementModel));
      },
      failure: (errorHandler) {
        emit(AddAdvertisementState.addAdvertisementError(errorHandler));
      },
    );
  }
}

// =================== ShowUserAdCubit =========================================
class ShowUserAdCubit extends Cubit<ShowUserAdsState> {
  final ShowUserAdRepository showUserAdRepository;
  ShowUserAdCubit(this.showUserAdRepository)
      : super(const ShowUserAdsState.initial());

  void emitGetUserAds() async {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    emit(const ShowUserAdsState.showUserAdsLoading());

    final result = await showUserAdRepository.getUserAd(userId);

    result.when(
      success: (showUserAdResponse) {
        print(showUserAdResponse.showUserAdvertisementData);
        emit(ShowUserAdsState.showUserAdsSuccess(showUserAdResponse));
      },
      failure: (apiError) {
        emit(ShowUserAdsState.showUserAdsError(apiError));
      },
    );
  }
}

// ========== NotificationsCubit ===============================================

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepository;
  NotificationsCubit(this.notificationsRepository)
      : super(const NotificationsState.initial());

  // === نرسل user_id عشان حالة "مقروء" تكون لكل مستخدم ومحفوظة بالسيرفر
  // (قبل كانت محفوظة بالجهاز فتُمحى مع حذف التطبيق)
  Future<Map<String, dynamic>> _body() async {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    return {'user_id': userId};
  }

  void emitGetNotifications() async {
    emit(const NotificationsState.notificationsLoading());

    final result = await notificationsRepository.getNotifications(await _body());

    result.when(
      success: (notificationsResponse) {
        emit(NotificationsState.notificationsSuccess(notificationsResponse));
      },
      failure: (apiError) {
        emit(NotificationsState.notificationsError(apiError));
      },
    );
  }

  Future<void> markNotificationsAsRead() async {
    await notificationsRepository.markNotificationsAsRead(await _body());
  }

  Future<void> clearAllNotifications() async {
    await notificationsRepository.clearAllNotifications(await _body());
    emitGetNotifications();
  }
}

// ===== News ============================================
class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;

  NewsCubit(this.newsRepository) : super(const NewsState.initial());

  void emitGetNews() async {
    emit(const NewsState.newsLoading());

    final result = await newsRepository.getNews();

    result.when(
      success: (newsResponse) {
        emit(NewsState.newsSuccess(newsResponse));
      },
      failure: (apiError) {
        emit(NewsState.newsError(apiError));
      },
    );
  }
}

// Delete Cubit ==========================================================

class DeleteAdCubit extends Cubit<DeleteState> {
  final DeleteAdRepository deleteAdRepository;
  DeleteAdCubit(this.deleteAdRepository) : super(const DeleteState.initial());

  void emitDeleteAds(int id) async {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    emit(const DeleteState.deleteLoading());

    final result = await deleteAdRepository.deleteAd(
      DeleteAdRequest(
        userId: userId,
        id: id,
      ),
    );
    result.when(
      success: (deleteAdResponse) {
        print(deleteAdResponse.message);
        emit(DeleteState.deleteSuccess(deleteAdResponse));
      },
      failure: (apiError) {
        emit(DeleteState.deleteError(apiError));
      },
    );
  }
}

// Update Cubit=============================================================

class UpdateAdCubit extends Cubit<UpdateAdState> {
  final UpdateAdRepository updateAdRepository;

  UpdateAdCubit(this.updateAdRepository) : super(UpdateAdState.initial());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController roomsController = TextEditingController();
  TextEditingController bathroomsController = TextEditingController();
  TextEditingController hallsController = TextEditingController();
  TextEditingController kitchensController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController floorsCountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // File? selectedImage;
  // final ImagePicker _picker = ImagePicker();
  String selectedPlanName = "الأساسية";

  // Future<void> pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage = File(image.path);
  //     emit(UpdateAdState.initial());
  //     emit(UpdateAdState.updateAdImagePicked(selectedImage!));
  //   }
  // }

  void emitUpdateAd(
      {required int adId,
      required String selectedPlanName,
      required String transactionType,
      String? imageBase64}) async {
    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);
    final String userPhone =
        await SharedPrefHelper.getString(SharedPrefKeys.userPhone);
    emit(UpdateAdState.updateAdLoading());

    final result = await updateAdRepository.updateAd(
      UpdateAdvertisementRequest(
        selectedPlanPrice: 100,
        selectedPlanName: selectedPlanName,
        transactionType: transactionType,
        title: '',
        description: descriptionController.text,
        type: typeController.text,
        region: regionController.text,
        price: priceController.text,
        phone: userPhone,
        userId: userId,
        id: adId,
        image: imageBase64 ?? "",
        rooms: int.tryParse(roomsController.text),
        bathrooms: int.tryParse(bathroomsController.text),
        halls: int.tryParse(hallsController.text),
        area: areaController.text.isEmpty ? null : areaController.text,
        floorsCount: int.tryParse(floorsCountController.text),
        address: addressController.text.isEmpty ? null : addressController.text,
      ),
    );
    result.when(
      success: (response) => emit(UpdateAdState.updateAdSuccess(response)),
      failure: (apiError) => emit(UpdateAdState.updateAdError(apiError)),
    );
  }
}

class FilterCubit extends Cubit<FilterState> {
  final AdsSearchRepository adsSearchRepository;

  String? currentRegion;
  String? currentTransactionType;

  FilterCubit(this.adsSearchRepository) : super(FilterState.initial());

  Future<void> getAdsSearch({String? region, String? transactionType}) async {
    // 1. تحديث القيم المحفوظة (إذا تم تمرير قيم جديدة)
    if (region != null) currentRegion = region;
    if (transactionType != null) currentTransactionType = transactionType;

    emit(FilterState.filterLoading());

    final response = await adsSearchRepository.getAdsSearch(
      AdsSearchRequest(
        region: currentRegion,
        transactionType: currentTransactionType,
      ),
    );

    response.when(
      success: (data) => emit(FilterState.filterSuccess(data)),
      failure: (error) => emit(FilterState.filterError(error)),
    );
  }

  // دالة لمسح الفلاتر والبدء من جديد
  void clearFilters() {
    currentRegion = null;
    currentTransactionType = null;
    getAdsSearch(); // جلب كل البيانات بدون فلاتر
  }
}
//==============================================================================

class SearchFilterCubit extends Cubit<SearchFilterState> {
  final SearchFilterRepository searchFilterRepository;
  TextEditingController priceRange = TextEditingController();
  TextEditingController transactionType = TextEditingController();

  SearchFilterCubit(this.searchFilterRepository)
      : super(SearchFilterState.initial());

  Future<void> getSearchFilter(
    List<String>? type,
    List<String>? region,
    String? transactionType,
    String? priceRange,
  ) async {
    emit(SearchFilterState.searchFilterLoading());

    final response = await searchFilterRepository.getSearchFilter(
      SearchFilterRequest(
        transactionType: transactionType ?? "",
        type: type ?? [],
        region: region ?? [],
        priceRange: priceRange ?? "",
      ),
    );

    response.when(
      success: (data) => emit(SearchFilterState.searchFilterSuccess(data)),
      failure: (error) => emit(SearchFilterState.searchFilterError(error)),
    );
  }
}

//==============================================================================

class FilterSctionCubit extends Cubit<FilterSectionState> {
  final FilterSectionRepository filterSectionRepository;

  String? currentSection;
  String? currentType;

  FilterSctionCubit(this.filterSectionRepository)
      : super(FilterSectionState.initial());

  Future<void> getfilterSection({String? section, String? type}) async {
    if (section != null) currentSection = section;
    if (type != null) currentType = type;

    emit(FilterSectionState.filterSectionLoading());

    final response = await filterSectionRepository.getfilterSection(
      FilterSectionRequest(
        section: currentSection,
        type: currentType,
      ),
    );

    response.when(
      success: (data) => emit(FilterSectionState.filterSectionSuccess(data)),
      failure: (error) => emit(FilterSectionState.filterSectionError(error)),
    );
  }
}

//==============================================================================
class UserMonthlyPointsCubit extends Cubit<UserMonthlyPointsState> {
  final UserMonthlyPointsRepository userMonthlyPointsRepository;

  UserMonthlyPointsCubit(this.userMonthlyPointsRepository)
      : super(UserMonthlyPointsState.initial());

  Future<void> getUserMonthlyPoints() async {
    // if (UserMonthlyPointsState is! UserMonthlyPointsInitial) return;

    final int userId = await SharedPrefHelper.getInt(SharedPrefKeys.userId);

    emit(UserMonthlyPointsState.userMonthlyPointsLoading());

    final response = await userMonthlyPointsRepository.getUserMonthlyPoints(
      UserMonthlyPointsRequest(userId: userId),
    );

    response.when(
      success: (data) => emit(
        UserMonthlyPointsState.userMonthlyPointsSuccess(data),
      ),
      failure: (error) => emit(
        UserMonthlyPointsState.userMonthlyPointsError(error),
      ),
    );
  }
}

class CalculateMarketValueCubit extends Cubit<CalculateMarketValueState> {
  final CalculateMarketValueRepository calculateMarketValueRepository;

  CalculateMarketValueCubit(this.calculateMarketValueRepository)
      : super(CalculateMarketValueState.initial());
  final TextEditingController areaController = TextEditingController();
  final TextEditingController buildingAge = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController finishingLevel = TextEditingController();
  List<String> features = [];
  String? selectedFeature;
  String? selectedLocation;

  final formKey = GlobalKey<FormState>();

  void emitCalculateMarketValue() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(CalculateMarketValueState.calculateMarketValueLoading());

    final result = await calculateMarketValueRepository.getCalculateMarketValue(
      CalculateMarketValueRequest(
        landSize: int.tryParse(areaController.text) ?? 0,
        location: location.text,
        position: int.tryParse(position.text) ?? 0,
        buildingAge: buildingAge.text, // مثال: "1-3"
        finishingLevel: int.tryParse(finishingLevel.text) ?? 0,
        features: features, // مثال: ["pool", "garden"]
      ),
    );
    result.when(
      success: (response) {
        emit(CalculateMarketValueState.calculateMarketValueSuccess(response));
      },
      failure: (apiError) =>
          emit(CalculateMarketValueState.calculateMarketValueError(apiError)),
    );
  }
}

//==============================================================================
class CalculateConstructionCostCubit
    extends Cubit<CalculateConstructionCostState> {
  final CalculateConstructionCostRepository calculateConstructionCostRepository;

  CalculateConstructionCostCubit(this.calculateConstructionCostRepository)
      : super(CalculateConstructionCostState.initial());
  final TextEditingController buildingArea = TextEditingController();
  final TextEditingController structureType = TextEditingController();
  // final TextEditingController finishingType = TextEditingController();
  // final TextEditingController acType = TextEditingController();
  // final TextEditingController elevators = TextEditingController();
  // final TextEditingController plumbingType = TextEditingController();
  bool? energySaving;
  bool? hasBasement;
  int? finishingType;
  int? acType;
  int? elevators;
  int? plumbingType;

  final formKey = GlobalKey<FormState>();

  void emitCalculateConstructionCost() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(CalculateConstructionCostState.calculateConstructionCostLoading());

    final result =
        await calculateConstructionCostRepository.getCalculateConstructionCost(
      CalculateConstructionCostRequest(
          buildingArea: int.tryParse(buildingArea.text) ?? 0,
          structureType: int.tryParse(structureType.text) ?? 0,
          finishingType: finishingType ?? 0,
          acType: acType ?? 0,
          energySaving: energySaving ?? true,
          elevators: elevators ?? 0,
          plumbingType: plumbingType ?? 0,
          hasBasement: hasBasement ?? true),
    );
    result.when(
      success: (response) {
        emit(CalculateConstructionCostState.calculateConstructionCostSuccess(
            response));
      },
      failure: (apiError) => emit(
          CalculateConstructionCostState.calculateConstructionCostError(
              apiError)),
    );
  }
}
