import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/banner_model.dart';
import '../../data/repository/banners_repository.dart';

/// شريط "الإعلانات المرئية" - بانرات تتحرك أوتوماتيكياً من اليسار
/// لليمين أعلى الصفحة الرئيسية، يديرها الأدمن من لوحة التحكم.
class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  List<BannerModel> _banners = [];
  bool _loading = true;
  late final PageController _controller;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _load();
  }

  Future<void> _load() async {
    final banners = await BannersRepository.fetchAll();
    if (!mounted) return;
    setState(() {
      _banners = banners;
      _loading = false;
    });
    if (banners.length > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _banners.isEmpty) return;
      _currentPage = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 150.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: _banners.length,
                onPageChanged: (i) => _currentPage = i,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _banners[index].image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (_, __, ___) => Container(color: const Color(0xFFEDEFF3)),
                  );
                },
              ),
              if (_banners.length > 1)
                Positioned(
                  bottom: 10.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_banners.length, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        width: active ? 16.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
