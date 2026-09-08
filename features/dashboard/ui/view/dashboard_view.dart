import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/current_account.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/di.dart';
import '../../../../core/helper/bottom_nav_visibility.dart';
import '../../../../core/helper/constants.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/notification_dismiss_helper.dart';
import '../../../../core/helper/onboarding_keys.dart';
import '../../../../core/helper/shared_pref.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../contracting/widgets/service_completion_reminder.dart';
import '../../../search/unified_search_view.dart';
import '../../../auth/logic/cubit_cubit.dart';
import '../../../auth/logic/cubit_state.dart';
import '../../../../core/widgets/favorites_view.dart';
import '../../../notification/notification_view.dart';
import '../../../settings/view/profile/profile_drawer.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'advertisements/view/ads/ads_view.dart';
import 'advertisements/widgets/add_ads/package_selection.dart';
import 'home/home.dart';

import '../../../../core/widgets/app_loading_indicator.dart';
class EdgeSwipeExit extends StatelessWidget {
  final Widget child;
  final double edgeThreshold =
  30.0; // زيادة الحساسية قليلاً لتناسب الشاشات الكبيرة

  EdgeSwipeExit({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        double screenWidth = MediaQuery.of(context).size.width;
        double startX = details.globalPosition.dx;

        // إذا سحب المستخدم من الحافة اليسرى أو اليمنى
        if (startX < edgeThreshold || startX > (screenWidth - edgeThreshold)) {
          // تنفيذ الخروج
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: child,
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Timer? _notificationsTimer;
  final List<Widget> _pages = [
    BlocProvider(
      create: (context) => HomeCubit(di())
        ..getVipAds()
        ..getAllAds(),
      child: const Home(),
    ),
    BlocProvider(
      create: (context) => di<SearchFilterCubit>(),
      child: const UnifiedSearchView(),
    ),
    BlocProvider(
        create: (BuildContext context) => di<FilterSctionCubit>(),
        child: const PackageSelection()),
    const FavoritesView(),
    BlocProvider(
      create: (context) => HomeCubit(di())..getAllAds(),
      child: const AdsView(),
    ),
  ];

  final List<String> _titel = [
    AppStrings.appTitle.tr(),
    AppStrings.search.tr(),
    AppStrings.addAd.tr(),
    AppStrings.favorites.tr(),
    AppStrings.advertisements.tr(),
  ];

  final PageController _pageController = PageController();

  Set<int> _dismissedNotificationIds = {};

  Future<void> _loadDismissedNotificationIds() async {
    final ids = await NotificationDismissHelper.getDismissedIds();
    if (mounted) setState(() => _dismissedNotificationIds = ids);
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().emitGetNotifications();
    // === تحديث دوري كل 30 ثانية عشان يظهر عداد الإشعارات الجديدة
    // بدون الحاجة للخروج والدخول للتطبيق من جديد
    _notificationsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) context.read<NotificationsCubit>().emitGetNotifications();
    });
    _loadDismissedNotificationIds();

    context.read<NavigationCubit>().changeIndex(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPendingServiceCompletion(context);
    });
  }

  void _onItemTapped(int index) {
    context.read<NavigationCubit>().changeIndex(index);
  }

  @override
  void dispose() {
    _notificationsTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return false;
    }

    final currentIndex = context.read<NavigationCubit>().state;
    if (currentIndex != 0) {
      context.read<NavigationCubit>().changeIndex(0);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await onWillPop();
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: BlocListener<NavigationCubit, int>(
        listener: (context, index) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != index) {
            _pageController.jumpToPage(index);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          endDrawer: FutureBuilder(
            future: SharedPrefHelper.getInt(SharedPrefKeys.userId),
            builder: (context, snapshot) {
              final int currentUserId =
                  (snapshot.hasData ? snapshot.data as int : 0);
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) {
                      final cubit = di<UserInfoCubit>();
                      if (isLoggedInUser && currentUserId != 0) {
                        cubit.emitGetUserInfo(currentUserId);
                      }
                      return cubit;
                    },
                  ),
                  BlocProvider(
                    create: (context) => di<UserMonthlyPointsCubit>(),
                  )
                ],
                child: Profile(),
              );
            },
          ),
          appBar: AppBar(
            backgroundColor: ColorManager.primary,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(22.r)),
            ),
            leading: !isLoggedInUser
                ? null
                : BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                int count = 0;

                state.maybeWhen(
                  notificationsSuccess: (data) {
                    count = data.notificationsDataResponse
                        ?.where((e) =>
                            !_dismissedNotificationIds.contains(e?.id))
                        .length ??
                        0;
                  },
                  orElse: () {},
                );

                return IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => di<NotificationsCubit>()
                            ..emitGetNotifications(),
                          child: const NotificationsView(),
                        ),
                      ),
                    );
                    _loadDismissedNotificationIds();
                    if (context.mounted) {
                      context.read<NotificationsCubit>().emitGetNotifications();
                    }
                  },
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: const Color(0xFFF5A623),
                        size: 30.sp,
                      ),
                      if (count > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(4.h),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14.w,
                              minHeight: 14.h,
                            ),
                            child: Center(
                              child: Text(
                                count > 99 ? "99+" : "$count",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            title: BlocBuilder<NavigationCubit, int>(
              builder: (context, currentIndex) {
                if (currentIndex != 0) {
                  return Text(
                    _titel[currentIndex],
                    style: StylesManager.font12GrayRegular.copyWith(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.appShortName.tr(),
                          style: StylesManager.font12GrayRegular.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        horizontalSpace(6),
                        Text('🇰🇼', style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                );
              },
            ),
            centerTitle: true,
            // === تحديد أقصى عرض لمنطقة الـ actions (تعديل: الاسم الطويل
            // كان يسبب Overflow، الآن يُقص بـ "..." ويبقى بحدود مساحة
            // الشريط دايمًا بغض النظر عن طول الاسم أو اللغة
            actions: [
              BlocBuilder<NavigationCubit, int>(
                builder: (context, currentIndex) {
                  if (currentIndex != 0) return const SizedBox.shrink();
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 0.34.sw),
                    child: FutureBuilder(
                      future: SharedPrefHelper.getInt(SharedPrefKeys.userId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final int currentUserId = snapshot.data as int;
                        return BlocProvider(
                          create: (context) =>
                              di<UserInfoCubit>()..emitGetUserInfo(currentUserId),
                          child: BlocBuilder<UserInfoCubit, UserInfoState>(
                            builder: (context, state) {
                              String name = '';
                              if (state is UserInfoSuccess) {
                                name = state.data.user?.name ?? '';
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (name.isNotEmpty)
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4.w),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          reverse: true,
                                          child: Text(
                                            '${AppStrings.welcomeGreeting.tr()}، $name',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13.5.sp,
                                              color: Colors.white.withOpacity(0.92),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  IconButton(
                                    onPressed: () =>
                                        Scaffold.of(context).openEndDrawer(),
                                    icon: Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                      size: 22.sp,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              final cubit = context.read<NavigationCubit>();
              if (cubit.state != index) {
                cubit.changeIndex(index);
              }
            },
            children: _pages,
          ),
          floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: BottomNavVisibility.visible,
            builder: (context, isVisible, child) {
              if (!isVisible) return const SizedBox.shrink();
              return child!;
            },
            child: FloatingActionButton(
              key: OnboardingKeys.addAdNavKey,
              shape: const CircleBorder(),
              backgroundColor: ColorManager.primary,
              onPressed: () {
                _onItemTapped(2);
              },
              child: Icon(
                Icons.ads_click_outlined,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: BottomNavVisibility.visible,
            builder: (context, isVisible, child) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.topCenter,
                child: isVisible ? child : const SizedBox(width: double.infinity),
              );
            },
            child: BlocBuilder<NavigationCubit, int>(
            builder: (context, currentIndex) {
              return BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: const Color(0xFF2E6D71)),
                    activeIcon:
                        Icon(Icons.home, color: const Color(0xFF2E6D71)),
                    label: AppStrings.home.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: const Color(0xFF3E7CB1)),
                    activeIcon:
                        Icon(Icons.search, color: const Color(0xFF3E7CB1)),
                    label: AppStrings.search.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.ads_click_outlined),
                    label: AppStrings.addAd.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border,
                        color: const Color(0xFFE53935)),
                    activeIcon: Icon(Icons.favorite,
                        color: const Color(0xFFE53935)),
                    label: AppStrings.favorites.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.campaign, color: const Color(0xFFF5A623)),
                    activeIcon:
                        Icon(Icons.campaign, color: const Color(0xFFF5A623)),
                    label: AppStrings.advertisements.tr(),
                  ),
                ],
                currentIndex: currentIndex,
                selectedItemColor: ColorManager.primary,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                onTap: (index) => _onItemTapped(index),
              );
            },
          ),
        ),
      ),
    ),
  );
  }
}
