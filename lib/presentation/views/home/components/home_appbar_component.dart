import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/presentation/components/user_pfp.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../utils/constants/assets.dart';
import '../../../theme/theme_utils/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback openDrawer; // Add a callback to open the drawer

  const HomeAppBar({
    super.key,
    required this.openDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8.h, left: 16.w, right: 16.w, bottom: Platform.isIOS ? 0 : 24.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: openDrawer,
                  child: Image.asset(
                    AssetConstants.drawer,
                    height: 20.h,
                    width: 25.w,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: BlocBuilder<NotificationsBloc, NotificationsState>(
                        builder: (context, state) {
                          return Badge(
                            smallSize: state.hasUnread ? 7.5.sp : 0,
                            alignment: const Alignment(0.55, -0.6),
                            child: Image.asset(
                              AssetConstants.notificationBellIcon,
                              height: 28.h,
                              width: 28.w,
                            ),
                          );
                        },
                      ),
                      color: AppColors.whiteColor,
                      onPressed: () =>
                          context.push(AppRoutes.notificationScreen),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.profileScreen),
                      child: UserPfp(
                        radius: 17.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ResuMate AI Resume Builder',
                  style: context.textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Lemon',
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
