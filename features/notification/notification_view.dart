import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/helper/spacing.dart';
import '../../core/resources/strings_manager.dart';
import '../../core/widgets/refresh_Indicator_widget.dart';
import '../../core/widgets/snackbar_message.dart';
import '../dashboard/logic/home_cubit.dart';
import '../dashboard/logic/home_state.dart';
import 'widgets/Notifications_widget.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final time = DateTime.now().subtract(const Duration(hours: 2));
  final Set<int> _readIndexes = {}; // تتبع عناصر المقروءة محلياً

  @override
  void initState() {
    super.initState();

    print("NOTIFICATION PAGE OPENED");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("CALLING MARK AS READ");

      await context.read<NotificationsCubit>().markNotificationsAsRead();
      print("AFTER MARK AS READ");

      context.read<NotificationsCubit>().emitGetNotifications();
    });
  }


/*
  @override
  void initState() {
    super.initState();
    // طلب الإشعارات عند فتح الصفحة بعد إطار البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().emitGetNotifications();
    });
  }
*/
  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('مسح الإشعارات'),
        content: const Text('هل تريد مسح جميع الإشعارات؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<NotificationsCubit>().clearAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.notificationsTitle.tr(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => _confirmClearAll(context),
            child: Text('مسح', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: BlocListener<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          state.maybeWhen(
            notificationsError: (error) {
              final msg = error.message ?? AppStrings.errorOccurred.tr();
              SnackBarMessage()
                  .showErrorSnackBar(message: msg, context: context);
            },
            notificationsSuccess: (_) {
              if (mounted) {
                setState(() => _readIndexes.clear());
              }
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            return state.maybeWhen(
              notificationsLoading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              notificationsSuccess: (notificationsResponse) {
                final notifications =
                    notificationsResponse.notificationsDataResponse ?? [];

                return RefreshIndicatorWidget(
                  onRefresh: () async {
                    context.read<NotificationsCubit>().emitGetNotifications();
                  },
                  child: notifications.isEmpty
                      ? buildEmptyState()
                      : ListView.separated(
                          padding: EdgeInsets.all(15.h),
                          itemCount: notifications.length,
                          separatorBuilder: (context, index) =>
                              verticalSpace(12),
                          itemBuilder: (context, index) {
                            return NotificationItem(
                              item: notifications[index]!,
                              index: index,
                            );
                          },
                        ),
                );
              },
              notificationsError: (error) => Center(
                child: Text(
                  error.message ?? AppStrings.errorOccurred.tr(),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
