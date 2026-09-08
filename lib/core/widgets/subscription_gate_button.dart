import 'package:flutter/material.dart';

import '../helper/shared_pref.dart';
import '../services/subscription_service.dart';
import '../../features/subscription/subscription_plans_view.dart';
import 'app_text_button.dart';

/// زر نشر/دفع موحّد لكل شاشات إضافة الإعلانات (عقار، وظائف، مقاولات،
/// شركات، مكاتب هندسية، فنادق...). يتحقق أولًا من وجود باقة فعّالة:
/// - عنده باقة فعّالة: يعرض الزر بنصه الطبيعي وينفّذ [onPublish] مباشرة.
/// - ما عنده باقة: يستبدل نص الزر بـ"اختر باقتك"، وبعد إتمام الاشتراك
///   بنجاح يعيد فحص الحالة وينفّذ [onPublish] تلقائيًا لإكمال نفس العملية.
class SubscriptionGateButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPublish;
  final Color? backgroundColor;
  final double? buttonHeight;
  final TextStyle? textStyle;

  const SubscriptionGateButton({
    super.key,
    required this.buttonText,
    required this.onPublish,
    this.backgroundColor,
    this.buttonHeight,
    this.textStyle,
  });

  @override
  State<SubscriptionGateButton> createState() => _SubscriptionGateButtonState();
}

class _SubscriptionGateButtonState extends State<SubscriptionGateButton> {
  bool _checking = true;
  bool _hasActivePlan = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final userType = await SharedPrefHelper.getUserType();
    if (userType == '2') {
      if (!mounted) return;
      setState(() {
        _hasActivePlan = true;
        _checking = false;
      });
      return;
    }
    final active = await SubscriptionService.fetchStatus();
    if (!mounted) return;
    setState(() {
      _hasActivePlan = active != null;
      _checking = false;
    });
  }

  Future<void> _openPlans() async {
    final subscribed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionPlansView()),
    );
    if (!mounted) return;
    if (subscribed == true) {
      setState(() => _hasActivePlan = true);
      widget.onPublish();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return SizedBox(
        height: widget.buttonHeight ?? 44,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return AppTextButton(
      buttonText: _hasActivePlan ? widget.buttonText : 'اختر باقتك',
      backgroundColor: widget.backgroundColor,
      buttonHeight: widget.buttonHeight,
      textStyle: widget.textStyle ?? const TextStyle(color: Colors.white),
      onPressed: _hasActivePlan ? widget.onPublish : _openPlans,
    );
  }
}
