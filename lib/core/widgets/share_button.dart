import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

/// زر مشاركة قابل لإعادة الاستخدام - يحطونه جنب زر المفضلة بأي بطاقة
/// أو صفحة تفاصيل (مقاول، شركة، مكتب هندسي، وظيفة، إعلان).
class ShareButton extends StatelessWidget {
  final String shareText;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const ShareButton({
    super.key,
    required this.shareText,
    this.size = 20,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Share.share(shareText),
      child: Container(
        padding: backgroundColor != null ? EdgeInsets.all(6.w) : EdgeInsets.zero,
        decoration: backgroundColor != null
            ? BoxDecoration(color: backgroundColor, shape: BoxShape.circle)
            : null,
        child: Icon(
          Icons.share,
          color: color ?? Colors.grey,
          size: size.sp,
        ),
      ),
    );
  }
}
