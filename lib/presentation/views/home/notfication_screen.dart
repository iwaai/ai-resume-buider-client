import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

import 'components/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<NotificationsBloc>()..add(GetAllNotifications()),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomAppBar(
          appBarColor: AppColors.whiteColor,
          titleWidget: Text(
            "Notifications",
            style: context.textTheme.titleMedium
                ?.copyWith(fontSize: 15.sp, color: AppColors.blackColor),
          ),
          trailingIcon: [
            Builder(builder: (context) {
              return PopupMenuButton(
                offset: Offset(0, 50.h),
                color: AppColors.whiteColor,
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      child: const Text('Mark all as read'),
                      onTap: () {
                        context.read<NotificationsBloc>().add(MarkAllAsRead());
                      },
                    )
                  ];
                },
              );
            }),
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.isLoading && state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return state.notifications.isEmpty
                ? const Center(child: Text('No Notifications Founds'))
                : ListView.builder(
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return NotificationTile(
                        notification: notification,
                        isLast: index == state.notifications.length - 1,
                        index: index,
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
