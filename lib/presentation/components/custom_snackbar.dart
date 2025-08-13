import 'package:flutter/material.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';

class SnackbarsType {
  const SnackbarsType._();

  static bool shown = false;

  static void success(BuildContext context, String text,
      {Duration duration = const Duration(milliseconds: 2000)}) {
    if (shown == true) return;
    shown = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(_Snackbar.snackbar(
            text: text,
            icon: Icons.check,
            foregroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.secondaryColor,
            duration: duration))
        .closed
        .then((_) {
      shown = false;
    });
  }

  static void error(BuildContext context, String text, {Duration? duration}) {
    if (shown == true) return;
    print('not shown');
    shown = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(_Snackbar.snackbar(
          duration: duration,
          text: text,
          icon: Icons.error_outline,
          foregroundColor: AppColors.whiteColor,
          backgroundColor: AppColors.redColor,
        ))
        .closed
        .then((_) {
      shown = false;
    });
  }
}

class _Snackbar {
  const _Snackbar._();

  static SnackBar snackbar(
      {required String text,
      required IconData icon,
      required Color foregroundColor,
      required Color backgroundColor,
      Duration? duration}) {
    return SnackBar(
      duration: duration ?? const Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed,
      showCloseIcon: true,
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          // Icon(icon, color: foregroundColor),
          Image.asset(
            AssetConstants.appLogo,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: foregroundColor),
            ),
          ),
        ],
      ),
    );
  }
}
