import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class ProfileSections extends StatelessWidget {
  final String title;
  final String? question1;
  final String? answer1;
  final String? question2;
  final String? answer2;
  const ProfileSections(
      {super.key,
      required this.title,
      required this.question1,
      required this.answer1,
      required this.question2,
      required this.answer2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.blackColor),
        ),
        SizedBox(
          height: 8.h,
        ),
        if (question1 != null)
          Text(
            question1!.capitalizeFirst(),
            style: context.textTheme.titleLarge!.copyWith(
                color: AppColors.profileText, fontWeight: FontWeight.w500),
          ),
        if (answer1 != null && answer1!.isNotEmpty)
          Text(
            answer1!.capitalizeFirst(),
            style: context.textTheme.titleLarge!.copyWith(
                color: AppColors.blackColor, fontWeight: FontWeight.w500),
          ),
        SizedBox(
          height: 8.h,
        ),
        if (question2 != null)
          Text(
            question2!.capitalizeFirst(),
            style: context.textTheme.titleLarge!.copyWith(
                color: AppColors.profileText, fontWeight: FontWeight.w500),
          ),
        if (answer2 != null && answer2!.isNotEmpty)
          Text(
            answer2!.capitalizeFirst(),
            style: context.textTheme.titleLarge!.copyWith(
                color: AppColors.blackColor, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }
}
