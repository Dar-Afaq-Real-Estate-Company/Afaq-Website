import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';
import '../widgets/section_placeholder_body.dart';

/// صفحة قسم "فنادق" - مستقلة تمامًا، جاهزة لإضافة الكود الخاص فيها لاحقًا.
/// ملاحظة: فيه فعلياً ميزة فنادق/شقق سابقة بالمشروع (HotelApartmentSearchView
/// بملف services_grid.dart) - خليناها بدون لمس. لما تحدد وش تبي بهالصفحة،
/// نقرر وقتها هل نربطها بنفس الميزة القديمة أو نبني شي جديد.
class HotelsSectionView extends StatelessWidget {
  const HotelsSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: const Text('فنادق'),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: const SectionPlaceholderBody(sectionTitle: 'فنادق'),
    );
  }
}
