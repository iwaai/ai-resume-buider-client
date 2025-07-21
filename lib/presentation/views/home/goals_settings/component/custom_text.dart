import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AssetConstants.instructionStar,
          height: 12.h,
          width: 15.w,
        ),
        Constant.horizontalSpace(5.w),
        Text(
          text,
          style: context.textTheme.labelLarge
              ?.copyWith(letterSpacing: 0, color: AppColors.primaryColor),
        )
      ],
    );
  }
}
