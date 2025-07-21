import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog(
      {this.title,
      this.body,
      this.okBtnFunction,
      this.okBtnText,
      this.imageHeight,
      this.additionalButton,
      this.barrierDismissible = true,
      super.key,
      this.image,
      this.customDialog,
      this.isRowButton = false,
      this.isSupport = false});

  final String? image;
  final double? imageHeight;
  final String? title;
  final String? body;
  final VoidCallback? okBtnFunction;
  final String? okBtnText;
  final Widget? additionalButton;
  final bool barrierDismissible;
  final Widget? customDialog;
  final bool isRowButton;
  final bool isSupport;

  Future<void> showCustomDialog(BuildContext context) {
    if (customDialog == null && title == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Either customDialog or title must be provided.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.w).copyWith(
                bottom: isSupport ? 0 : 16,
                top: isSupport ? 0 : 16,
              ),
              child: customDialog ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(image != null)
                      Image.asset(image!, height: imageHeight ?? 165.h),
                      SizedBox(height: 16.h),
                      Text(
                        title ?? '',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        body ?? '',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (!isRowButton)
                        Column(
                          children: [
                            PrimaryButton(
                              onPressed: okBtnFunction ?? () => context.pop(),
                              text: okBtnText ?? 'Okay',
                            ),
                            if (additionalButton != null) ...[
                              SizedBox(height: 16.h),
                              additionalButton!,
                            ]
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                onPressed: okBtnFunction ?? () => context.pop(),
                                text: okBtnText ?? 'Okay',
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (additionalButton != null) ...[
                              SizedBox(height: 16.h),
                              additionalButton!,
                            ]
                          ],
                        )
                    ],
                  ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: anim1,
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (customDialog == null && title == null) {
      throw ArgumentError('Either customDialog or title must be provided.');
    }
    return const Dialog();
  }
}
