import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../resources/color_manager.dart';

/// صفحة عامة لفتح بوابة الدفع الإلكتروني داخل التطبيق (WebView)
/// نفس نمط ArticleWebViewScreen الموجود بالمشروع، بس مخصصة للدفع.
///
/// TODO: لما يتحدد مزود بوابة الدفع (MyFatoorah / Tap / UPayments...):
/// 1. راقب روابط النجاح/الفشل عبر NavigationDelegate (onNavigationRequest)
///    وقارنها مع success_url / error_url اللي يرجعها المزود.
/// 2. لما يوصل رابط النجاح، اسكر هذي الصفحة وارجع نتيجة true للصفحة
///    اللي قبلها (Navigator.pop(context, true))، وحدّث حالة الطلب
///    بالباك اند (مثلاً عن طريق استدعاء API تأكيد الدفع).
class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const PaymentWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => isLoading = true),
          onPageFinished: (url) => setState(() => isLoading = false),
          // TODO: فعّل هذا لما تعرف روابط النجاح/الفشل من مزود الدفع
          // onNavigationRequest: (request) {
          //   if (request.url.contains('payment-success')) {
          //     Navigator.pop(context, true);
          //     return NavigationDecision.prevent;
          //   }
          //   if (request.url.contains('payment-failed')) {
          //     Navigator.pop(context, false);
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: ColorManager.white,
        elevation: 0,
        foregroundColor: ColorManager.black,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
