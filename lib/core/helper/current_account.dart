import 'account_types.dart';
import 'constants.dart';
import 'shared_pref.dart';

/// نوع حساب المستخدم الحالي — يُستخدم لترتيب واجهة التطبيق
class CurrentAccount {
  static String _type = AccountType.seeker;

  static String get type => _type;

  /// هل يقدر ينشر إعلانات (مالك/مكتب/مطوّر/وسيط)؟
  static bool get canPublish => AccountType.canPublish(_type);

  /// هل هو باحث عن عقار فقط؟
  static bool get isSeeker => _type == AccountType.seeker;

  /// يُقرأ عند تشغيل التطبيق وبعد تسجيل الدخول
  static Future<void> load() async {
    final saved = await SharedPrefHelper.getString(SharedPrefKeys.accountType);
    _type = saved.isEmpty ? AccountType.seeker : saved;
  }

  static Future<void> save(String value) async {
    _type = value;
    await SharedPrefHelper.setData(SharedPrefKeys.accountType, value);
  }
}
