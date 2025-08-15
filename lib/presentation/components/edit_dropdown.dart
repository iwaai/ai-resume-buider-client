import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/components/primary_dropdown.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class EditProfileDropDown extends StatelessWidget {
  final String title;
  final String hintText;
  final String? value;
  final List<dynamic> options;
  final bool showOptionalText;
  final String? optionalText;
  final Color? optionalTextColor;
  final double? optionalTextSize;
  final bool isEnabled;
  final String? Function(String?)? validator;

  final Function(String?)? onChanged;

  const EditProfileDropDown(
      {super.key,
      required this.title,
      required this.hintText,
      this.value,
      required this.onChanged,
      required this.options,
      this.showOptionalText = false,
      this.validator,
      this.optionalText,
      this.optionalTextColor,
      this.optionalTextSize,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium!.copyWith(
                  color: AppColors.blackColor, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5.w),
            if (showOptionalText)
              Expanded(
                child: Text(
                  optionalText ?? '(or expected end)',
                  style: context.textTheme.labelMedium?.copyWith(
                      color: optionalTextColor ?? AppColors.secondaryColor,
                      fontSize: optionalTextSize ?? 10.sp),
                ),
              )
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        PrimaryDropdown(
          isEnabled: isEnabled,
          validator: validator,
          hintTextSize: 14.sp,
          borderColor: AppColors.blackColor,
          hintText: hintText,
          hintColor: AppColors.blackColor.withOpacity(0.8),
          initialValue: value,
          onChanged: onChanged,
          options: options,
        )
      ],
    );
  }
}
