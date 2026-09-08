import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';

class UserPointsCard extends StatelessWidget {
  final String? monthlyPoints;
  final int? userActivityPoints;

  const UserPointsCard({
    super.key,
    required this.monthlyPoints,
    required this.userActivityPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color(0xff3B7B84),
            Color(0xff6B7B84),
            // Color(0xFF6A5AE0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              horizontalSpace(8),
              Text(
                "نقاطي",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          verticalSpace(15),

          /// MAIN POINTS
          Text(
            monthlyPoints ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "النقاط الشهرية",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          verticalSpace(15),

          /// DIVIDER
          Container(
            height: 1,
            color: Colors.white24,
          ),
          verticalSpace(10),

          /// SECOND ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _pointItem(
                icon: Icons.trending_up,
                title: "نقاط النشاط",
                value: userActivityPoints ?? 0,
              ),
              _pointItem(
                icon: Icons.star,
                title: "التقييم",
                value: userActivityPoints ?? 0 ~/ 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pointItem({
    required IconData icon,
    required String title,
    required int value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        horizontalSpace(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$value",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
