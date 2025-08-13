import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/models/notification_model.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final bool isLast;
  final int index;

  const NotificationTile(
      {super.key,
      required this.notification,
      required this.isLast,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Swipe to Delete',
      verticalOffset: 0,
      preferBelow: true,
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: AppColors.redColor,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              size: 24,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        onDismissed: (v) {
          context.read<NotificationsBloc>().add(DeleteNotification(index));
        },
        key: ValueKey(notification.createdAt),
        child: ListTile(
          tileColor: notification.isRead == false
              ? AppColors.secondaryColor.withOpacity(.2)
              : null,
          shape: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: AppColors.borderGrey),
                ),
          leading: CircleAvatar(
            radius: 26.r,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(notificationIcon),
          ),
          visualDensity: VisualDensity.comfortable,
          title: Text(
            notification.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: 15.sp,
              color: AppColors.blackColor,
            ),
          ),
          subtitle: Text(
            notification.message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isToday(notification.createdAt)
                    ? formatTime(notification.createdAt)
                    : formatDate(notification.createdAt),
                textAlign: TextAlign.right,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.blackColor,
                  fontSize: 12.sp,
                ),
              ),
              if (!notification.isRead)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: CircleAvatar(
                    backgroundColor: AppColors.secondaryColor,
                    radius: 4.r,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  String get notificationIcon {
    switch (notification.notificationType) {
      case 'created':
        return AssetConstants.goalNotification;
      case 'alert':
        return AssetConstants.deadlineAlertNotification;
      default:
        return AssetConstants.notificationBellIcon;
    }
  }

  bool isToday(DateTime notificationDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formattedNotificationDate = DateTime(
        notificationDate.year, notificationDate.month, notificationDate.day);

    return formattedNotificationDate.isAtSameMomentAs(today);
  }
}
