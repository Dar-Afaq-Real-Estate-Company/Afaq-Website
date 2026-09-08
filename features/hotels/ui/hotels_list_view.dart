import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/widgets/price_range_slider.dart';
import '../../../core/widgets/region_picker_sheet.dart';
import '../../../core/routing/routes.dart';
import '../data/hotel_model.dart';
import '../logic/hotels_cubit.dart';
import 'hotel_detail_view.dart';

class HotelsListView extends StatelessWidget {
  const HotelsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotelsListCubit()..load(),
      child: const _HotelsListBody(),
    );
  }
}

class _HotelsListBody extends StatefulWidget {
  const _HotelsListBody();
  @override
  State<_HotelsListBody> createState() => _HotelsListBodyState();
}

class _HotelsListBodyState extends State<_HotelsListBody> {
  List<String> _regions = [];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HotelsListCubit>();
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp)),
                      const Spacer(),
                      Text('فنادق', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      SizedBox(width: 20.sp),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 46.h,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
                    child: Row(children: [
                      SizedBox(width: 14.w),
                      Icon(Icons.search, color: ColorManager.grey, size: 20.sp),
                      SizedBox(width: 8.w),
                      const Expanded(child: Text('ابحث عن منطقة أو فندق...', style: TextStyle(color: Color(0xFF98A2B3)))),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 34.h,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _dropdownChip(icon: Icons.tune, label: 'المرافق', active: cubit.amenityFilter.isNotEmpty, onTap: () => _openAmenities(cubit)),
                  SizedBox(width: 8.w),
                  _dropdownChip(icon: Icons.star_border, label: 'التقييم', onTap: () {}),
                  SizedBox(width: 8.w),
                  _dropdownChip(icon: Icons.attach_money, label: 'السعر', active: cubit.minPrice > 0 || cubit.maxPrice < 500, onTap: () => _openPrice(cubit)),
                ]),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Icon(Icons.map_outlined, size: 16.sp, color: ColorManager.primary),
                  SizedBox(width: 4.w),
                  Text('عرض على الخريطة', style: TextStyle(fontSize: 12.5.sp, color: ColorManager.primary)),
                ]),
                BlocBuilder<HotelsListCubit, HotelsListState>(
                  builder: (context, state) => Text(
                    state is HotelsListSuccess ? '${state.hotels.length} فندق متاح' : '',
                    style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: BlocBuilder<HotelsListCubit, HotelsListState>(
                builder: (context, state) {
                  if (state is HotelsListLoading) return const Center(child: CircularProgressIndicator());
                  if (state is HotelsListError) return Center(child: Text(state.message));
                  final hotels = (state as HotelsListSuccess).hotels;
                  if (hotels.isEmpty) return const Center(child: Text('لا توجد فنادق مطابقة'));
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    itemCount: hotels.length,
                    itemBuilder: (context, i) => _HotelCard(hotel: hotels[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () => Navigator.pushNamed(context, Routes.addHotelRoute),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _chip({required IconData icon, required String label, required VoidCallback onTap, bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(color: active ? ColorManager.primary : ColorManager.lighterGray, borderRadius: BorderRadius.circular(20.r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16.sp, color: active ? Colors.white : ColorManager.grey),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 12.5.sp, color: active ? Colors.white : Colors.black87)),
        ]),
      ),
    );
  }

  Widget _dropdownChip({required IconData icon, required String label, required VoidCallback onTap, bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: active ? ColorManager.primary : ColorManager.lightGrey), borderRadius: BorderRadius.circular(18.r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15.sp, color: active ? ColorManager.primary : ColorManager.grey),
          SizedBox(width: 5.w),
          Text(label, style: TextStyle(fontSize: 12.sp, color: active ? ColorManager.primary : Colors.black87)),
          Icon(Icons.keyboard_arrow_down, size: 16.sp, color: ColorManager.grey),
        ]),
      ),
    );
  }

  void _openAmenities(HotelsListCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (sheetContext) => StatefulBuilder(builder: (sheetContext, setSheetState) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: HotelAmenities.options.entries.map((e) {
                final selected = cubit.amenityFilter.contains(e.key);
                return GestureDetector(
                  onTap: () {
                    cubit.toggleAmenityFilter(e.key);
                    setSheetState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: selected ? ColorManager.primary.withOpacity(0.1) : Colors.white,
                      border: Border.all(color: selected ? ColorManager.primary : ColorManager.lightGrey),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(e.value['label'] as String, style: TextStyle(color: selected ? ColorManager.primary : Colors.black87, fontSize: 13.sp)),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  void _openPrice(HotelsListCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: PriceRangeSlider(
            min: 0,
            max: 500,
            step: 10,
            initialMin: cubit.minPrice,
            initialMax: cubit.maxPrice,
            currencyLabel: 'د.ك',
            onChanged: (min, max) => cubit.setPriceRange(min, max),
          ),
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final HotelModel hotel;
  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final cover = hotel.images.isNotEmpty ? hotel.images.first : '';
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HotelDetailView(hotelId: hotel.id!))),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: ColorManager.lighterGray)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(
              height: 190.h,
              width: double.infinity,
              child: cover.isEmpty
                  ? Container(color: ColorManager.lighterGray, child: Icon(Icons.hotel, size: 44.sp, color: ColorManager.grey))
                  : CachedNetworkImage(imageUrl: cover, fit: BoxFit.cover, errorWidget: (_, __, ___) => Container(color: ColorManager.lighterGray)),
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: CircleAvatar(radius: 16.r, backgroundColor: Colors.white, child: Icon(Icons.favorite_border, color: Colors.red, size: 16.sp)),
            ),
          ]),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(hotel.name ?? '', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 4.h),
              Row(children: [
                Icon(Icons.location_on, size: 14.sp, color: ColorManager.primary),
                SizedBox(width: 4.w),
                Text(hotel.region ?? '', style: TextStyle(fontSize: 12.5.sp, color: ColorManager.grey)),
              ]),
              if (hotel.amenities.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: hotel.amenities.take(3).map((key) {
                    final label = HotelAmenities.options[key]?['label'] as String? ?? key;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(color: ColorManager.lighterGray, borderRadius: BorderRadius.circular(10.r)),
                      child: Text(label, style: TextStyle(fontSize: 10.5.sp, color: Colors.black87)),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 10.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                  decoration: BoxDecoration(color: ColorManager.primary, borderRadius: BorderRadius.circular(12.r)),
                  child: Text('التفاصيل', style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w700)),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${hotel.nightPrice.toStringAsFixed(2)} د.ك', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: ColorManager.primary)),
                  Text('/ الليلة', style: TextStyle(fontSize: 10.5.sp, color: ColorManager.grey)),
                ]),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
