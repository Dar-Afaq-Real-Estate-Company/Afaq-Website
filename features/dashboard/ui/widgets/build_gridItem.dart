import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'sections/section_services.dart';

Widget buildGridItem(
  SectionServices item,
  bool isSelected,
) {
  return Column(
    children: [
      Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              item.icon,
            ),
          ),
        ],
      ),
      SizedBox(height: 6),
      Text(
        item.label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}
