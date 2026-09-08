import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/favorites_service.dart';

/// زر قلب قابل لإعادة الاستخدام - يحطونه بأي بطاقة (إعلان، مقاول،
/// شركة، مكتب هندسي، وظيفة) وهو يتكفل بكل شي (الإضافة والإزالة).
/// كل الأزرار اللي بنفس النوع/الـ id يشتركون بنفس ValueNotifier، فلما
/// يتغيّر بمكان (تفاصيل مثلاً) يتحدث فوراً بكل مكان ثاني (قائمة، بطاقة
/// أخرى...) بدون أي تحديث يدوي أو انتظار تنقّل.
class FavoriteButton extends StatefulWidget {
  final FavoriteType type;
  final int itemId;
  final bool initiallyFavorited;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.type,
    required this.itemId,
    this.initiallyFavorited = false,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isLoading = false;
  late ValueNotifier<bool> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = FavoritesService.notifierFor(widget.type, widget.itemId, initial: widget.initiallyFavorited);
  }

  Future<void> _toggle() async {
    if (_isLoading) return;
    _isLoading = true;
    final bool newValue = !_notifier.value;
    _notifier.value = newValue; // تحديث فوري (Optimistic) بكل مكان يستخدم هذا الـ notifier

    final bool success = newValue
        ? await FavoritesService.addFavorite(widget.type, widget.itemId)
        : await FavoritesService.removeFavorite(widget.type, widget.itemId);

    if (!success) {
      // ignore: avoid_print
      print('Favorite toggle FAILED for ${widget.type.apiValue}/${widget.itemId} -> $newValue');
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, isFavorited, _) {
        return GestureDetector(
          onTap: _toggle,
          child: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited
                ? (widget.activeColor ?? Colors.red)
                : (widget.inactiveColor ?? Colors.grey),
            size: widget.size.sp,
          ),
        );
      },
    );
  }
}
