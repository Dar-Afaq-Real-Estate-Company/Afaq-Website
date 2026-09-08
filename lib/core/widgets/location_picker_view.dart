import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:easy_localization/easy_localization.dart';

import '../resources/color_manager.dart';

/// صفحة "ضع موقعك على الخريطة" - تُستخدم داخل نموذج إضافة الإعلان.
/// تفتح خريطة على الكويت، المستخدم يحرك الخريطة لين يوصل الدبوس الثابت
/// بالنص لموقع العقار، وبعدين يضغط "تأكيد الموقع" فترجع له الإحداثيات.
///
/// TODO: يحتاج باقة google_maps_flutter مضافة بـ pubspec.yaml + مفتاح
/// Google Maps API مفعّل بملف AndroidManifest.xml (راجع آخر رسالة بالمحادثة
/// لخطوات الحصول عليه).
class LocationPickerView extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerView({super.key, this.initialLocation});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  // مركز دولة الكويت تقريبًا - يستخدم لو ما فيه موقع مبدئي
  static const LatLng _kuwaitCenter = LatLng(29.3759, 47.9774);

  late LatLng _pickedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation ?? _kuwaitCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _pickedLocation = position.target;
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          // === الدبوس الثابت بمنتصف الشاشة (نفس فكرة "حرّك الخريطة تحت الدبوس")
          Icon(Icons.location_on, size: 46, color: ColorManager.primary),

          // === زر رجوع أعلى الشاشة
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

          // === زر تأكيد الموقع بالأسفل
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.black,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context, _pickedLocation),
              child: Text(
                'confirm_location'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
