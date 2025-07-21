import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/utils/extensions.dart';

import '../theme/theme_utils/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      this.enabled = true,
      required this.onPressed,
      required this.text,
      this.textColor = AppColors.whiteColor,
      this.textSize,
      this.fontWeight,
      this.height,
      this.width,
      this.buttonColor,
      this.elevation,
      this.borderRadius,
      this.textStyle,
      this.borderColor,
      this.icon,
      this.loading = false,
      this.loaderColor = AppColors.secondaryColor});

  final VoidCallback? onPressed;
  final String text;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? textSize;
  final Color? buttonColor;
  final bool loading;
  final bool enabled;
  final double? height, width, borderRadius, elevation;
  final Widget? icon;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading || enabled == false ? null : onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height ?? 48.h,
        width: width ?? double.infinity.w,
        decoration: BoxDecoration(
            // gradient: enabled == false
            //     ? LinearGradient(colors: [AppColors.grey, AppColors.grey])
            //     : AppColors.primaryGradient,
            color: buttonColor ??
                (enabled ? null : AppColors.grey), // Sets background color
            gradient: buttonColor == null
                ? (enabled
                    ? AppColors.primaryGradient
                    : LinearGradient(colors: [AppColors.grey, AppColors.grey]))
                : null, // Gradient applies only when buttonColor is null
            borderRadius: BorderRadius.circular(
              borderRadius ?? 14.r,
            ),
            border: Border.all(color: borderColor ?? Colors.transparent)),
        child: loading
            ? SizedBox.square(
                dimension: 20.dm,
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3.w,
                  color: loaderColor,
                ),
              )
            : Text(
                text,
                style: textStyle ??
                    context.textTheme.labelMedium!.copyWith(
                        color:
                            enabled == false ? AppColors.whiteColor : textColor,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        fontSize: textSize ?? 14.sp),
              ),
      ),
    );
  }
}

// class OutlinedCommonButton extends StatelessWidget {
//   const OutlinedCommonButton(
//       {super.key,
//       required this.onPressed,
//       required this.text,
//       this.textColor,
//       this.height,
//       this.width,
//       this.buttonColor,
//       this.elevation,
//       this.borderRadius = 90,
//       this.loading = false,
//       this.loaderColor,
//       this.textSize,
//       this.textStyle});
//
//   final VoidCallback? onPressed;
//   final String text;
//   final Color? textColor;
//   final double? textSize;
//   final TextStyle? textStyle;
//
//   final Color? buttonColor;
//   final bool loading;
//   final double? height, width, borderRadius, elevation;
//   final Color? loaderColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: loading ? null : onPressed,
//       child: Container(
//         alignment: Alignment.center,
//         height: height ?? 48.h,
//         width: width ?? double.infinity.w,
//         decoration: BoxDecoration(
//           color: buttonColor ?? AppColors.primaryColor,
//           border: Border.all(
//             color: buttonColor ?? AppColors.primaryColor,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
//         ),
//         child: loading
//             ? SizedBox.square(
//                 dimension: 20.dm,
//                 child: CircularProgressIndicator(
//                   strokeCap: StrokeCap.round,
//                   strokeWidth: 3,
//                   color: loaderColor ?? AppColors.lightGreenColor,
//                 ),
//               )
//             : Text(
//                 text,
//                 style: textStyle ??
//                     context.textTheme.labelMedium!.copyWith(
//                         color: textColor ?? AppColors.lightGreenColor,
//                         fontSize: textSize ?? 12.sp),
//               ),
//       ),
//     );
//   }
// }
// class OutlinedCommonButton extends StatelessWidget {
//   const OutlinedCommonButton(
//       {super.key,
//       required this.onPressed,
//       required this.text,
//       this.textColor,
//       this.height,
//       this.width,
//       this.buttonColor,
//       this.elevation,
//       this.borderRadius = 90,
//       this.loading = false,
//       this.loaderColor,
//       this.textSize,
//       this.textStyle});
//
//   final VoidCallback? onPressed;
//   final String text;
//   final Color? textColor;
//   final double? textSize;
//   final TextStyle? textStyle;
//
//   final Color? buttonColor;
//   final bool loading;
//   final double? height, width, borderRadius, elevation;
//   final Color? loaderColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: loading ? null : onPressed,
//       child: Container(
//         alignment: Alignment.center,
//         height: height ?? 48.h,
//         width: width ?? double.infinity.w,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: buttonColor ?? AppColors.primaryColor,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
//         ),
//         child: loading
//             ? SizedBox.square(
//                 dimension: 20.dm,
//                 child: CircularProgressIndicator(
//                   strokeCap: StrokeCap.round,
//                   strokeWidth: 3,
//                   color: loaderColor ?? AppColors.primaryColor,
//                 ),
//               )
//             : Text(
//                 text,
//                 style: textStyle ??
//                     context.textTheme.labelMedium!.copyWith(
//                         color: textColor ?? AppColors.primaryColor,
//                         fontSize: textSize ?? 12.sp),
//               ),
//       ),
//     );
//   }
// }
