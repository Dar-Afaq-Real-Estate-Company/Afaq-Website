import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';
import '../widgets/section_placeholder_body.dart';

/// صفحة قسم "مقاولات" - مستقلة تمامًا، جاهزة لإضافة الكود الخاص فيها لاحقًا.
class ContractingSectionView extends StatelessWidget {
  const ContractingSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('مقاولات'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: const SectionPlaceholderBody(sectionTitle: 'مقاولات'),
    );
  }
}
