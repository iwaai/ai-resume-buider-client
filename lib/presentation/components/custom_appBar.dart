import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool? isOnlybackButton;
  final VoidCallback? onClick;
  final List<Widget>? trailingIcon;
  final Color? appBarColor;
  final Color? txtColors;
  final Color? backIconColor;
  final bool isBackButton;
  final bool centerTile;
  final double? titleSpacing;
  final PreferredSizeWidget? bottomWidget; // Added parameter for bottom widget

  const CustomAppBar(
      {super.key,
      this.title,
      this.onClick,
      this.titleWidget,
      this.isBackButton = true,
      this.isOnlybackButton = false,
      this.centerTile = true,
      this.trailingIcon,
      this.appBarColor,
      this.txtColors,
      this.bottomWidget, // Initialize the bottom widget
      this.backIconColor,
      this.titleSpacing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTile,
      elevation: 0,
      titleSpacing: titleSpacing,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: appBarColor ?? Colors.transparent,
      automaticallyImplyLeading: false,
      leading: isBackButton && context.canPop()
          ? GestureDetector(
              onTap: onClick ?? () => context.pop(),
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: backIconColor ?? AppColors.blackColor,
                size: 24.sp,
              ),
            )
          : null,
      title: isOnlybackButton == true
          ? Container()
          : titleWidget ??
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                    color: txtColors ?? AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0),
              ),
      actions: trailingIcon ?? [SizedBox(width: 22.sp)],
      bottom: bottomWidget, // Assign the bottom widget here
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottomWidget?.preferredSize.height ?? 0));
}
