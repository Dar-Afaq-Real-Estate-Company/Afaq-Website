import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/resources/color_manager.dart';
import '../data/hotel_model.dart';
import '../data/hotels_repository.dart';

/// صفحة تفاصيل الفندق - عرض فقط + تواصل مباشر مع صاحب الفندق (اتصال/واتساب)
/// بدون أي نظام حجز داخل التطبيق، حسب التصميم المعتمد.
class HotelDetailView extends StatefulWidget {
  final int hotelId;
  const HotelDetailView({super.key, required this.hotelId});

  @override
  State<HotelDetailView> createState() => _HotelDetailViewState();
}

class _HotelDetailViewState extends State<HotelDetailView> {
  HotelModel? _hotel;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final hotel = await HotelsRepository.fetchOne(widget.hotelId);
      if (mounted) setState(() => _hotel = hotel);
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر تحميل بيانات الفندق');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Scaffold(body: Center(child: Text(_error!)));
    if (_hotel == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final hotel = _hotel!;

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: hotel.images.isEmpty
                  ? Container(color: ColorManager.lighterGray, child: Icon(Icons.hotel, size: 60, color: ColorManager.grey))
                  : PageView.builder(
                      itemCount: hotel.images.length,
                      itemBuilder: (context, i) => CachedNetworkImage(
                        imageUrl: hotel.images[i],
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(color: ColorManager.lighterGray, child: const Icon(Icons.broken_image)),
                      ),
                    ),
            ),
            Positioned(
              top: 46,
              right: 16,
              child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.black), onPressed: () => Navigator.pop(context))),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              child: Row(children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.share, size: 16, color: Colors.black54)),
                const SizedBox(width: 8),
                const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.favorite_border, size: 16, color: Colors.red)),
              ]),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(hotel.name ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.location_on, size: 16, color: ColorManager.primary),
                const SizedBox(width: 4),
                Expanded(child: Text(hotel.region ?? '', style: TextStyle(fontSize: 13, color: ColorManager.grey))),
              ]),
              const SizedBox(height: 16),

              // === أنواع الغرف المتاحة وسعر كل نوع - حسب ما أضافه صاحب الفندق
              const Text('أنواع الغرف والأسعار', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...hotel.rooms.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(r.roomType, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                      Text('${r.pricePerNight.toStringAsFixed(0)} د.ك / الليلة', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: ColorManager.primary)),
                    ]),
                  )),
              const SizedBox(height: 16),

              if (hotel.description != null && hotel.description!.isNotEmpty) ...[
                Text(hotel.description!, style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87)),
                const SizedBox(height: 18),
              ],

              if (hotel.amenities.isNotEmpty) ...[
                const Text('المرافق والمميزات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: hotel.amenities.map((k) => _pill(HotelAmenities.options[k]?['label'] as String? ?? k)).toList()),
                const SizedBox(height: 16),
              ],

              if (hotel.views.isNotEmpty) ...[
                const Text('الإطلالة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: hotel.views.map((k) => _pill(HotelViews.options[k]?['label'] as String? ?? k)).toList()),
                const SizedBox(height: 16),
              ],

              const Text(
                'الحجز يتم مباشرة مع الفندق — تطبيق أفاق يعرض بيانات الفندق فقط ويسهّل التواصل، بدون معالجة حجز أو دفع داخل التطبيق.',
                style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3), height: 1.6),
              ),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
        child: SafeArea(
          top: false,
          child: Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _whatsapp(hotel.whatsapp ?? hotel.phone ?? ''),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(13)),
                  alignment: Alignment.center,
                  child: const Text('واتساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _call(hotel.phone ?? ''),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(color: ColorManager.primary, borderRadius: BorderRadius.circular(13)),
                  alignment: Alignment.center,
                  child: const Text('اتصال', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: ColorManager.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
        child: Text(label, style: TextStyle(fontSize: 12, color: ColorManager.primary)),
      );

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String phone) async {
    final uri = Uri.parse('https://wa.me/${phone.trim()}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
