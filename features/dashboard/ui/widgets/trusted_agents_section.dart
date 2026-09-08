import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

import '../../../../core/resources/color_manager.dart';

/// قسم "الوكلاء الأكثر ثقة" - يجيب البيانات من لوحة الإدارة (API) بدل
/// ما تكون ثابتة بالكود. نفس تصميم الشركاء بالضبط.
class TrustedAgentsSection extends StatefulWidget {
  const TrustedAgentsSection({super.key});

  @override
  State<TrustedAgentsSection> createState() => _TrustedAgentsSectionState();
}

class _TrustedAgentsSectionState extends State<TrustedAgentsSection> {
  static const int _itemsPerPage = 4;
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<List<Map<String, dynamic>>> _fetch() async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.afaq.group/api/'));
    final response = await dio.get('trusted-agents');
    final List<dynamic> data = response.data['data'] ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (!snapshot.hasData) {
          return SizedBox(height: 120.h);
        }
        final agents = snapshot.data!;
        if (agents.isEmpty) return const SizedBox.shrink();

        final pageCount = (agents.length / _itemsPerPage).ceil();

        return SizedBox(
          height: 104.h,
          child: PageView.builder(
            itemCount: pageCount,
            controller: PageController(viewportFraction: 1),
            itemBuilder: (context, pageIndex) {
              final start = pageIndex * _itemsPerPage;
              final end = (start + _itemsPerPage).clamp(0, agents.length);
              final pageAgents = agents.sublist(start, end);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: pageAgents
                    .map((agent) => _AgentAvatar(agent: agent))
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }
}

class _AgentAvatar extends StatelessWidget {
  final Map<String, dynamic> agent;

  const _AgentAvatar({required this.agent});

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = agent['photo_url'] as String?;
    final String name = agent['name'] as String? ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: ColorManager.primary.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: ClipOval(
            child: photoUrl == null
                ? Container(
                    color: ColorManager.primary.withOpacity(0.1),
                    child: Icon(Icons.person, color: ColorManager.primary),
                  )
                : CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: ColorManager.primary.withOpacity(0.1),
                      child: const Center(
                        child: SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: ColorManager.primary.withOpacity(0.1),
                      child: Icon(Icons.person, color: ColorManager.primary),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 76.w,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, color: ColorManager.grey),
          ),
        ),
      ],
    );
  }
}
