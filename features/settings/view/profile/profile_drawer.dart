import 'package:flutter/material.dart';

import 'profile_view.dart';

/// الشاشة الجانبية دمجت مع البروفايل — تعرضه مباشرة
/// (اللغة وإعدادات الحساب أصبحت داخل البروفايل نفسه)
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) => const ProfileView();
}
