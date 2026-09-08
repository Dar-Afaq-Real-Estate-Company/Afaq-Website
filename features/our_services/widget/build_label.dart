  // Helper Widget for Labels
  import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';

Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: ColorManager.black,
        ),
      ),
    );
  }
