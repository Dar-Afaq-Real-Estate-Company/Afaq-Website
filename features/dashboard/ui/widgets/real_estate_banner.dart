import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealEstateBanner extends StatelessWidget {
  const RealEstateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const String buildingImagePath =
        'https://images.pexels.com/photos/34639/pexels-photo.jpg';

    double bannerHeight = 150.0.h;

    return Container(
      height: bannerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0.r),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              // The image covers roughly half the width
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                buildingImagePath,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
