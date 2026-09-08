import 'package:flutter/material.dart';

/// مفتاح Navigator عالمي - يسمح بفتح Dialogs/التنقل من كود لا يملك
/// BuildContext حي (مثل بعد إزالة الصفحة الحالية من المكدس).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
