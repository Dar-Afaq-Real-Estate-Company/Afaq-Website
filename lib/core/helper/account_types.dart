import 'package:flutter/material.dart';
import '../resources/strings_manager.dart';

/// أنواع حسابات المستخدمين — 4 أنواع فقط، تُحدّد ترتيب التطبيق بعد تسجيل الدخول
class AccountType {
  static const String seeker = 'seeker';
  static const String company = 'company';
  static const String office = 'office';
  static const String broker = 'broker';

  static const List<AccountTypeOption> options = [
    AccountTypeOption(
      value: seeker,
      titleKey: 'acc_type_seeker_title',
      subtitleKey: 'acc_type_seeker_subtitle',
      icon: Icons.person_outline,
    ),
    AccountTypeOption(
      value: company,
      titleKey: 'acc_type_company_title',
      subtitleKey: 'acc_type_company_subtitle',
      icon: Icons.business_outlined,
    ),
    AccountTypeOption(
      value: office,
      titleKey: 'acc_type_office_title',
      subtitleKey: 'acc_type_office_subtitle',
      icon: Icons.apartment_outlined,
    ),
    AccountTypeOption(
      value: broker,
      titleKey: 'acc_type_broker_title',
      subtitleKey: 'acc_type_broker_subtitle',
      icon: Icons.handshake_outlined,
    ),
  ];

  static AccountTypeOption of(String value) => options.firstWhere(
        (o) => o.value == value,
        orElse: () => options.first,
      );

  /// هل هذا النوع ينشر إعلانات؟ (يُستخدم لترتيب واجهة التطبيق)
  static bool canPublish(String value) => value != seeker;
}

class AccountTypeOption {
  final String value;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  const AccountTypeOption({
    required this.value,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });

  String title([String langCode = 'ar']) => AppStrings.getString(titleKey, langCode);
  String subtitle([String langCode = 'ar']) => AppStrings.getString(subtitleKey, langCode);
}
