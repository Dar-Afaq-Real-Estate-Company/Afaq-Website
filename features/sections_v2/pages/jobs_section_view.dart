import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';
import '../widgets/section_placeholder_body.dart';

/// صفحة قسم "وظائف" - مستقلة تمامًا، جاهزة لإضافة الكود الخاص فيها لاحقًا.
class JobsSectionView extends StatelessWidget {
  const JobsSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('وظائف'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: const SectionPlaceholderBody(sectionTitle: 'وظائف'),
    );
  }
}
