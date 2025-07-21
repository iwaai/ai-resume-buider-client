import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class SelectedOption extends StatelessWidget {
  final String title;
  final Function() onDelete;
  const SelectedOption(
      {super.key, required this.title, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall!
                .copyWith(color: AppColors.blackColor),
          ),
          SizedBox(
            width: 8.w,
          ),
          InkWell(
            onTap: () {
              onDelete();
            },
            child: const Icon(
              CupertinoIcons.delete,
              color: AppColors.redColor,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
