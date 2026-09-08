/// "الإعلانات المرئية" - بانرات صور متحركة أعلى الصفحة الرئيسية،
/// يديرها الأدمن من لوحة التحكم.
class BannerModel {
  final int id;
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
        image: json['image']?.toString() ?? '',
      );
}
