import 'package:flutter/material.dart';

/// شريط نطاق سعر بمقبضين:
/// - أثناء السحب: يتحرك المقبض مباشرة بدون أي تأخير (إحساس فوري).
/// - عند الإفلات: ينحسب (Snap) على أقرب قيمة مضبوطة [step] برجّة مرنة
///   (Curves.elasticOut) بدل التوقف المفاجئ.
///
/// ملاحظة مهمة: كل مقبض له AnimationController مستقل خاص فيه، عشان
/// أنيميشن مقبض ما يأثر على المقبض الثاني أبداً (كانت هذي مشكلة النسخة السابقة).
///
/// لما يوصل الحد الأعلى لنهاية النطاق [max]، تلقائياً يطلع علامة "+" بجنب
/// الرقم (مثلاً "5000+") إشارة إلى إنه ما فيه سقف فعلي - المستخدم يقصد
/// "5000 أو أكثر". لما تستخدم onChanged في الفلترة، تحقق: إذا القيمة المرجعة
/// لـ max تساوي نفس [max] اللي حطيته، عاملها كـ "بدون حد أعلى" بدل رقم دقيق.
///
/// الشريط يتبع اتجاه اللغة تلقائياً (يقرأ Directionality من الشجرة، ما يفرضه):
/// عربي (RTL) → القيمة الصغرى يمين والكبرى يسار. إنجليزي (LTR) → القيمة الصغرى
/// يسار والكبرى يمين. ما يحتاج أي كود إضافي عند تبديل لغة التطبيق.
///

/// الاستخدام:
/// PriceRangeSlider(
///   min: 0,
///   max: 5000,
///   step: 50,
///   initialMin: 500,
///   initialMax: 3500,
///   onChanged: (min, max) => print('$min - $max'),
/// )
class PriceRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final double initialMin;
  final double initialMax;
  final void Function(double min, double max) onChanged;
  final String currencyLabel;

  const PriceRangeSlider({
    super.key,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 50,
    this.initialMin = 0,
    this.initialMax = 0,
    this.currencyLabel = 'ريال',
  });

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> with TickerProviderStateMixin {
  late double _minVal;
  late double _maxVal;

  // متحكم مستقل لكل مقبض - هذا هو إصلاح المشكلة (كانا يتشاركون متحكم واحد سابقاً)
  late AnimationController _minSnapController;
  late AnimationController _maxSnapController;

  // نحتفظ بالـ Animation الحالي لكل مقبض عشان الـ listener الثابت يقرأ منه
  Animation<double>? _minSnapAnimation;
  Animation<double>? _maxSnapAnimation;

  bool _isDraggingMin = false;
  bool _isDraggingMax = false;

  // كبّرنا المقبض من 20 إلى 28 - يفرق كثير بالإحساس عند اللمس بالجوال
  static const double _thumbSize = 28;

  // إذا وصل الحد الأعلى لنفس قيمة widget.max، معناها "5000 أو أكثر" (ما فيه سقف)
  bool get _isMaxUncapped => (widget.max - _maxVal).abs() < 0.01;

  @override
  void initState() {
    super.initState();
    _minVal = widget.initialMax > 0 ? widget.initialMin : widget.min;
    _maxVal = widget.initialMax > 0 ? widget.initialMax : widget.max;

    _minSnapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _maxSnapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // Listener واحد ثابت لكل متحكم - يتسجل مرة وحدة فقط طول عمر الويدجت،
    // فما يتراكم أكثر من listener ولا يقرأ animation غلط
    _minSnapController.addListener(() {
      if (_minSnapAnimation == null) return;
      setState(() => _minVal = _minSnapAnimation!.value);
    });
    _maxSnapController.addListener(() {
      if (_maxSnapAnimation == null) return;
      setState(() => _maxVal = _maxSnapAnimation!.value);
    });
  }

  @override
  void dispose() {
    _minSnapController.dispose();
    _maxSnapController.dispose();
    super.dispose();
  }

  double _snapToStep(double v) {
    final snapped = (v / widget.step).round() * widget.step;
    return snapped.clamp(widget.min, widget.max);
  }

  void _animateMinSnap(double from, double to) {
    _minSnapAnimation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _minSnapController, curve: Curves.elasticOut),
    );
    _minSnapController
      ..reset()
      ..forward().whenComplete(() {
        widget.onChanged(_minVal, _maxVal);
      });
  }

  void _animateMaxSnap(double from, double to) {
    _maxSnapAnimation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _maxSnapController, curve: Curves.elasticOut),
    );
    _maxSnapController
      ..reset()
      ..forward().whenComplete(() {
        widget.onChanged(_minVal, _maxVal);
      });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    // نقرأ اتجاه اللغة الحالي من التطبيق (يتغيّر تلقائياً مع easy_localization)
    // بدل ما نفرضه RTL دايماً. الحين: القيمة الصغرى دايماً بجهة "البداية"
    // (يمين بالعربي، يسار بالإنجليزي) والكبرى بجهة "النهاية" - بدون أي كود إضافي عند تبديل اللغة
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ValuePill(label: '${_minVal.round()} ${widget.currencyLabel}', accent: accent),
            _ValuePill(
              label: '${_maxVal.round()}${_isMaxUncapped ? '+' : ''} ${widget.currencyLabel}',
              accent: accent,
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth - _thumbSize;

            double valueToDx(double v) =>
                (v - widget.min) / (widget.max - widget.min) * trackWidth;

            double dxToValue(double dx) {
              final pct = (dx.clamp(0, trackWidth)) / trackWidth;
              return widget.min + pct * (widget.max - widget.min);
            }

            // المسافة من حافة "البداية" (يمين بالعربي / يسار بالإنجليزي).
            // localX دايماً إحداثي كارتيزي عادي (يسار=0) بغض النظر عن اتجاه اللغة،
            // فنعكسه فقط إذا كان الاتجاه RTL.
            double dxFromStart(double localX) {
              final clamped = localX.clamp(0, trackWidth).toDouble();
              return isRtl ? (trackWidth - clamped) : clamped;
            }

            final minDx = valueToDx(_minVal);
            final maxDx = valueToDx(_maxVal);

            return SizedBox(
              height: 32,
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                textDirection: Directionality.of(context),
                children: [
                  PositionedDirectional(
                    start: _thumbSize / 2,
                    end: _thumbSize / 2,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: _thumbSize / 2 + minDx,
                    end: _thumbSize / 2 + (trackWidth - maxDx),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // مقبض الحد الأدنى - دايماً بجهة البداية
                  PositionedDirectional(
                    key: const ValueKey('min-thumb-position'),
                    start: minDx,
                    child: GestureDetector(
                      key: const ValueKey('min-thumb-gesture'),
                      onHorizontalDragStart: (_) {
                        _minSnapController.stop();
                        setState(() => _isDraggingMin = true);
                      },
                      onHorizontalDragUpdate: (details) {
                        final box = context.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(details.globalPosition);
                        final dx = dxFromStart(local.dx);
                        final raw = dxToValue(dx);
                        setState(() {
                          _minVal = raw.clamp(widget.min, _maxVal - widget.step);
                        });
                      },
                      onHorizontalDragEnd: (_) {
                        setState(() => _isDraggingMin = false);
                        final snapped =
                            _snapToStep(_minVal).clamp(widget.min, _maxVal - widget.step);
                        _animateMinSnap(_minVal, snapped);
                      },
                      child: _Thumb(dragging: _isDraggingMin, accent: accent, size: _thumbSize),
                    ),
                  ),
                  // مقبض الحد الأعلى - دايماً بجهة النهاية
                  PositionedDirectional(
                    key: const ValueKey('max-thumb-position'),
                    start: maxDx,
                    child: GestureDetector(
                      key: const ValueKey('max-thumb-gesture'),
                      onHorizontalDragStart: (_) {
                        _maxSnapController.stop();
                        setState(() => _isDraggingMax = true);
                      },
                      onHorizontalDragUpdate: (details) {
                        final box = context.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(details.globalPosition);
                        final dx = dxFromStart(local.dx);
                        final raw = dxToValue(dx);
                        setState(() {
                          _maxVal = raw.clamp(_minVal + widget.step, widget.max);
                        });
                      },
                      onHorizontalDragEnd: (_) {
                        setState(() => _isDraggingMax = false);
                        final snapped =
                            _snapToStep(_maxVal).clamp(_minVal + widget.step, widget.max);
                        _animateMaxSnap(_maxVal, snapped);
                      },
                      child: _Thumb(dragging: _isDraggingMax, accent: accent, size: _thumbSize),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.min.round()} ${widget.currencyLabel}',
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
            Text('${widget.max.round()} ${widget.currencyLabel}',
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
          ],
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  final bool dragging;
  final Color accent;
  final double size;

  const _Thumb({required this.dragging, required this.accent, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: dragging ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: accent, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String label;
  final Color accent;

  const _ValuePill({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: accent),
      ),
    );
  }
}
