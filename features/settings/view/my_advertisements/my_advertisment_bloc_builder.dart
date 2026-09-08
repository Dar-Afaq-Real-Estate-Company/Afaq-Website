import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../dashboard/data/response/response.dart';
import '../../../dashboard/logic/home_cubit.dart';
import '../../../dashboard/logic/home_state.dart';
import '../../widgets/my_advertisments.dart';
import 'my_job_listings_section.dart';
import 'my_contracting_section.dart';

import '../../../../core/widgets/app_loading_indicator.dart';

class MyAdvertismentBlocBuilder extends StatefulWidget {
  const MyAdvertismentBlocBuilder({super.key});

  @override
  State<MyAdvertismentBlocBuilder> createState() => _MyAdvertismentBlocBuilderState();
}

class _MyAdvertismentBlocBuilderState extends State<MyAdvertismentBlocBuilder> {
  List<Map<String, dynamic>> _jobs = [];
  bool _jobsLoaded = false;
  List<Map<String, dynamic>> _contracting = [];
  String _filter = 'all'; // all | property | contracting | job

  @override
  void initState() {
    super.initState();
    _loadJobs();
    _loadContracting();
  }

  Future<void> _loadContracting() async {
    try {
      final items = await fetchMyContractingListings();
      if (!mounted) return;
      setState(() => _contracting = items);
    } catch (_) {}
  }

  Future<void> _loadJobs() async {
    try {
      final jobs = await fetchMyJobListings();
      if (!mounted) return;
      setState(() {
        _jobs = jobs;
        _jobsLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _jobsLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowUserAdCubit, ShowUserAdsState>(
      builder: (context, state) {
        return state.maybeWhen(
          showUserAdsLoading: () => const Center(child: AppLoadingIndicator()),
          showUserAdsSuccess: (showUserAdResponse) {
            final ads = showUserAdResponse.showUserAdvertisementData ?? [];

            // === صفحة واحدة: كل الإعلانات (عقار + وظائف) مرتّبة تنازليًا
            // بتاريخ النشر، فالأحدث دايمًا فوق بدون فصل بأقسام
            final List<_UnifiedAd> items = [
              ...ads.whereType<ShowUserAdvertisementData>().map((ad) => _UnifiedAd(
                    date: DateTime.tryParse(ad.createdAt ?? '') ?? DateTime(2000),
                    property: ad,
                  )),
              ..._jobs.map((job) => _UnifiedAd(
                    date: DateTime.tryParse((job['created_at'] ?? '').toString()) ??
                        DateTime(2000),
                    job: job,
                  )),
              ..._contracting.map((c) => _UnifiedAd(
                    date: DateTime.tryParse((c['created_at'] ?? '').toString()) ?? DateTime(2000),
                    contracting: c,
                  )),
            ]..sort((a, b) => b.date.compareTo(a.date));

            final List<_UnifiedAd> filteredItems = _filter == 'all'
                ? items
                : items.where((i) {
                    if (_filter == 'property') return i.property != null;
                    if (_filter == 'contracting') return i.contracting != null;
                    return i.job != null;
                  }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ShowUserAdCubit>().emitGetUserAds();
                await _loadJobs();
                await _loadContracting();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _filterChip('الكل', 'all'),
                          const SizedBox(width: 8),
                          _filterChip('عقار', 'property'),
                          const SizedBox(width: 8),
                          _filterChip('مقاول', 'contracting'),
                          const SizedBox(width: 8),
                          _filterChip('وظيفة', 'job'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: Center(child: Text(AppStrings.noAdsAvailable.tr())),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: filteredItems.length,
                            separatorBuilder: (_, __) => verticalSpace(10),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              if (item.property != null) {
                                return ShowUserAdCard(
                                  showUserAdvertisementData: item.property!,
                                );
                              }
                              if (item.contracting != null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ContractingAdCard(
                                    item: item.contracting!,
                                    onChanged: _loadContracting,
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: JobAdCard(
                                  item: item.job!,
                                  onChanged: _loadJobs,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
          showUserAdsError: (error) => Center(
            child: Text(error.message ?? AppStrings.errorOccurred.tr()),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF16818A) : Colors.white,
          border: Border.all(color: selected ? const Color(0xFF16818A) : const Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.white : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}

/// عنصر موحّد يجمع إعلان عقار أو إعلان وظيفة مع تاريخ نشره للترتيب
class _UnifiedAd {
  final DateTime date;
  final ShowUserAdvertisementData? property;
  final Map<String, dynamic>? job;
  final Map<String, dynamic>? contracting;

  _UnifiedAd({required this.date, this.property, this.job, this.contracting});
}
