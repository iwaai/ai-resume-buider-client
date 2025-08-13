import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class EditProfileTextfield extends StatelessWidget {
  final String title;
  final String hintText;
  final String? initialValue;
  final int? maxLines;
  final int? characterLimit;
  final TextInputType? textInputType;
  final bool showOptionalText;
  final double? width;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmit;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> textInputFormatters;
  final bool readOnly;

  const EditProfileTextfield(
      {super.key,
      required this.title,
      required this.hintText,
      this.initialValue,
      this.onChanged,
      this.showOptionalText = false,
      this.readOnly = false,
      this.width,
      this.maxLines,
      this.textInputType,
      this.validator,
      this.textInputFormatters = const [],
      this.characterLimit,
      this.controller,
      this.onFieldSubmit});

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
              Text(
                '(Optional)',
                style: context.textTheme.labelMedium
                    ?.copyWith(color: AppColors.secondaryColor),
              )
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        PrimaryTextField(
          readOnly: readOnly,
          key: key,
          onFieldSubmit: onFieldSubmit,
          controller: controller,
          characterLimit: characterLimit,
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            ...textInputFormatters
          ],
          validator: validator,
          inputType: textInputType,
          maxLines: maxLines,
          hintTextSize: 14.sp,
          hintText: hintText,
          initialValue: initialValue,
          onChanged: onChanged,
        )
      ],
    );
  }
}
