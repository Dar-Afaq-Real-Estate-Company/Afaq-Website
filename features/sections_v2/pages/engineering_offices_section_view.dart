import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';
import '../widgets/section_placeholder_body.dart';

/// صفحة قسم "مكاتب هندسية" - مستقلة تمامًا، جاهزة لإضافة الكود الخاص فيها لاحقًا.
class EngineeringOfficesSectionView extends StatelessWidget {
  const EngineeringOfficesSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('مكاتب هندسية'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: const SectionPlaceholderBody(sectionTitle: 'مكاتب هندسية'),
    );
  }
}
