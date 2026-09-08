import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';

/// مؤشر تحميل مخصص لتطبيق آفاق: شعار التطبيق بالنص مع نبضة (pulse) خفيفة،
/// وحوله نقاط تدور حول الشعار - بدل الدائرة الافتراضية الجاهزة.
/// استخدمه بنفس مكان CircularProgressIndicator():
///   const Center(child: AppLoadingIndicator())
class AppLoadingIndicator extends StatefulWidget {
  final double size;
  const AppLoadingIndicator({super.key, this.size = 96});

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double t = _controller.value; // 0..1
          final double pulse = 0.94 + 0.06 * (0.5 + 0.5 * math.sin(t * 2 * math.pi));
          return Stack(
            alignment: Alignment.center,
            children: [
              // === نقاط تدور حول الشعار
              Transform.rotate(
                angle: t * 2 * math.pi,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _OrbitDotsPainter(color: ColorManager.primary),
                ),
              ),
              // === الشعار بالوسط مع نبضة خفيفة
              Transform.scale(
                scale: pulse,
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      ImageAssets.logo,
                      width: widget.size * 0.66,
                      height: widget.size * 0.66,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.home_work_rounded,
                        size: widget.size * 0.4,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitDotsPainter extends CustomPainter {
  final Color color;
  const _OrbitDotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    const int dots = 3;
    for (int i = 0; i < dots; i++) {
      final double angle = (i / dots) * 2 * math.pi;
      final Offset pos = Offset(
        center.dx + (radius - 5) * math.cos(angle),
        center.dy + (radius - 5) * math.sin(angle),
      );
      final double opacity = 0.35 + 0.65 * (i / dots);
      canvas.drawCircle(
        pos,
        3.4,
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
