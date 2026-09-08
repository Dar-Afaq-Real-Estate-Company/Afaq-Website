import 'package:flutter/material.dart';

import '../../../core/resources/color_manager.dart';

/// محتوى مؤقت لكل صفحة قسم جديدة، ريثما تحدد المطلوب داخل كل صفحة.
/// كل صفحة (RealEstateSectionView, ContractingSectionView...) تستخدمه
/// مؤقتًا وبعدين تستبدل بمحتواها الخاص.
class SectionPlaceholderBody extends StatelessWidget {
  final String sectionTitle;

  const SectionPlaceholderBody({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.build_circle_outlined,
                size: 48, color: ColorManager.grey),
            const SizedBox(height: 12),
            Text(
              'صفحة "$sectionTitle" جاهزة كهيكل مستقل\nبانتظار تحديد المحتوى المطلوب فيها',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorManager.grey),
            ),
          ],
        ),
      ),
    );
  }
}
