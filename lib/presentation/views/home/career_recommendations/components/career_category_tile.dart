import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class CareerCategoryTile extends StatelessWidget {
  final String title;
  final bool selected;
  final Function() onTap;
  const CareerCategoryTile(
      {super.key,
      required this.title,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // Reduced duration

        alignment: const Alignment(0, 0),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            // color: selected ? null : AppColors.whiteColor,
            gradient: !selected
                ? const LinearGradient(
                    colors: [AppColors.whiteColor, AppColors.whiteColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)
                : AppColors.primaryGradient),
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleMedium!
              .copyWith(color: !selected ? null : AppColors.whiteColor),
        ),
      ),
    );
  }
}
