import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/network/api_constants.dart';
import '../requests/requests.dart';
import '../response/response.dart';
part 'home_api.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class HomeApi {
  factory HomeApi(Dio dio) = _HomeApi;

  @GET(ApiConstants.allAds)
  Future<AdsResponse> getAllAds();

  @GET(ApiConstants.adsAuction)
  Future<AuctionResponse> getAuctionResponse();

  @GET(ApiConstants.adsVip)
  Future<HomeResponse> getAdsVipResponse();

  @GET(ApiConstants.searchAds)
  Future<SearchAdsResponse> getSearchAds(
    @Query("region") String? region,
    @Query("transaction_type") String? transactionType,
  );

  @GET(ApiConstants.getUserMonthlyPoints)
  Future<UserMonthlyPointsResponse> getUserMonthlyPoints(
    @Query("user_id") int? userId,
  );

  @POST(ApiConstants.addAdvertisement)
  Future<AddAdvertisementResponse> addAdvertisement(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiConstants.showUserAdvertisement)
  Future<ShowUserAdResponse> getUserAd(
    @Query("userId") int userId,
  );
  @DELETE(ApiConstants.deleteAdvertisement)
  Future<DeleteAdResponse> deleteAd(
    @Query("user_id") int userId,
    @Query("id") int id,
  );
  @POST(ApiConstants.updateAdvertisement)
  Future<UpdateAdResponse> UpdateAd(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.notifications)
  Future<NotificationsResponse> getNotifications(@Query("user_id") int? userId);

  @POST(ApiConstants.markNotificationsAsRead)
  Future<void> markNotificationsAsRead(@Query("user_id") int? userId);

  @POST(ApiConstants.clearAllNotifications)
  Future<void> clearAllNotifications(@Query("user_id") int? userId);

  @GET(ApiConstants.filterSection)
  Future<FilterSectionResponse> getfilterSection(
    @Query("section") String? section,
    @Query("type") String? type,
  );

  @GET(ApiConstants.getPropertyTypes)
  Future<PropertyTypesResponse> getPropertyTypes();

  @GET(ApiConstants.getAreas)
  Future<AreasResponse> getAreas();

  @GET(ApiConstants.getAmenities)
  Future<AmenitiesResponse> getAmenities();

  @GET(ApiConstants.news)
  Future<NewsResponse> getNews();

  @GET(ApiConstants.searchFilter)
  Future<SearchFilterResponse> getSearchFilter(
    @Query("transaction_type") String? transactionType,
    @Query("type") List<String>? type,
    @Query("region") List<String>? region,
    @Query("price_range") String? priceRange,
  );

  @GET(ApiConstants.calculateMarketValue)
  Future<CalculateMarketValueRsponse> getCalculateMarketValue(
    @Query("land_size") int landSize,
    @Query("location") String location,
    @Query("position") int position,
    @Query("building_age") String buildingAge,
    @Query("finishing_level") int finishingLevel,
    @Query("features") List<String> features,
  );

  @GET(ApiConstants.calculateConstructionCost)
  Future<CalculateConstructionCostRsponse> getCalculateConstructionCost(
    @Query("building_area") int buildingArea,
    @Query("structure_type") int structureType,
    @Query("finishing_type") int finishingType,
    @Query("ac_type") int acType,
    @Query("energy_saving") bool energySaving,
    @Query("elevators") int elevators,
    @Query("plumbing_type") int plumbingType,
    @Query("has_basement") bool hasBasement,
  );
}

