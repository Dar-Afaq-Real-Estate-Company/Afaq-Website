import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/dashboard/data/response/response.dart';
import 'package:easy_localization/easy_localization.dart';

import '../resources/color_manager.dart';

/// صفحة "ابحث في الخريطة" - خريطة كاملة على الكويت فيها كل إعلان بموقعه.
/// هذي صفحة مستقلة (Navigator.push) فما فيها شريط سفلي أصلاً - نفس
/// السلوك المطلوب بالفيديو المرجعي.
///
/// TODO: يحتاج باقة google_maps_flutter بـ pubspec.yaml + Google Maps API Key.
class MapSearchView extends StatefulWidget {
  final List<AdsDataResponse?> ads;

  const MapSearchView({super.key, required this.ads});

  @override
  State<MapSearchView> createState() => _MapSearchViewState();
}

class _MapSearchViewState extends State<MapSearchView> {
  static const LatLng _kuwaitCenter = LatLng(29.3759, 47.9774);

  // الفلترة خاصة بالعقار فقط (أنواع العقارات) - مو كل التصنيفات
  // === مخزّنة كمفاتيح ترجمة عشان تتغير مع لغة التطبيق
  static const List<String> _propertyTypeKeys = [
    'opt_all', 'opt_apartment', 'opt_house', 'opt_floor', 'opt_land',
  ];
  String _selectedTypeKey = 'opt_all';

  AdsDataResponse? _selectedAd;

  // === القيمة العربية الثابتة اللي تقارن فعليًا مع قاعدة البيانات
  // (مخزّنة عربي دايمًا)، بغض النظر عن لغة عرض الواجهة
  static const Map<String, String> _typeArabicValues = {
    'opt_apartment': 'شقة',
    'opt_house': 'بيت',
    'opt_floor': 'دور',
    'opt_land': 'ارض',
  };

  List<AdsDataResponse?> get _filteredAds {
    // فقط الإعلانات اللي فيها موقع محدد (latitude/longitude) تظهر بالخريطة
    final withLocation =
        widget.ads.where((ad) => ad?.latitude != null && ad?.longitude != null);
    if (_selectedTypeKey == 'opt_all') return withLocation.toList();

    // === نستخدم "يحتوي على" لأن type مخزّن كـ "بيت للبيع" مو "بيت" لحالها
    final String arValue = _typeArabicValues[_selectedTypeKey] ?? '';
    return withLocation
        .where((ad) => (ad?.type ?? '').contains(arValue))
        .toList();
  }

  Set<Marker> get _markers {
    return _filteredAds.map((ad) {
      return Marker(
        markerId: MarkerId('ad_${ad!.id}'),
        position: LatLng(ad.latitude!, ad.longitude!),
        onTap: () => setState(() => _selectedAd = ad),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _kuwaitCenter,
              zoom: 10,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          if (_filteredAds.isEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'no_map_ads_yet'.tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // === شريط البحث + أيقونة الفلترة (نفس الفيديو المرجعي)
          Positioned(
            top: 50,
            left: 16,
            right: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: ColorManager.grey),
                        const SizedBox(width: 8),
                        Text('search_for_property'.tr(),
                            style: TextStyle(color: ColorManager.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(Icons.tune, color: ColorManager.primary),
                  ),
                ),
              ],
            ),
          ),

          // === زر رجوع
          Positioned(
            top: 50,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // === بطاقة الإعلان المختار (لما يضغط على دبوس)
          if (_selectedAd != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _SelectedAdCard(
                ad: _selectedAd!,
                onClose: () => setState(() => _selectedAd = null),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('filter_properties_sheet_title'.tr(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _propertyTypeKeys.map((key) {
                      final isSelected = key == _selectedTypeKey;
                      return ChoiceChip(
                        label: Text(key.tr()),
                        selected: isSelected,
                        selectedColor: ColorManager.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setSheetState(() => _selectedTypeKey = key);
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SelectedAdCard extends StatelessWidget {
  final AdsDataResponse ad;
  final VoidCallback onClose;

  const _SelectedAdCard({required this.ad, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              ad.images ?? '',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: ColorManager.lighterGray,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${ad.price ?? ''} د.ك',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${ad.type ?? ''} | ${ad.region ?? ''}',
                    style: TextStyle(color: ColorManager.grey, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
