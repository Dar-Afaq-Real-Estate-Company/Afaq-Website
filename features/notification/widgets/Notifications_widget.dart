import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../dashboard/data/response/response.dart';
import '../../dashboard/logic/home_cubit.dart';

Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_off_outlined,
          size: 80,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.noNotifications.tr(),
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

class NotificationItem extends StatefulWidget {
  final NotificationsDataResponse item;
  final int index;

  const NotificationItem({super.key, required this.item, required this.index});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isRead = false;
  final DateTime _time = DateTime.now().subtract(const Duration(hours: 2));

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Dismissible(
      key: Key(item.message ?? widget.index.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.noNotifications.tr()),
          ),
        );
        context.read<NotificationsCubit>().emitGetNotifications();
      },
      child: InkWell(
        onTap: () => setState(() => _isRead = true),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor:
                    _isRead ? Colors.grey.shade100 : Colors.white70,
                child: Icon(
                  _isRead
                      ? Icons.notifications_none
                      : Icons.notifications_active,
                  color: _isRead ? Colors.grey : ColorManager.primary,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.message ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _isRead ? Colors.grey.shade700 : Colors.black,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      item.subject ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    verticalSpace(8),
                    Text(
                      DateFormat('hh:mm a').format(_time),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (!_isRead)
                CircleAvatar(radius: 4, backgroundColor: ColorManager.primary),
            ],
          ),
        ),
      ),
    );
  }
}
