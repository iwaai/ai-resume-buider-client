import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../utils/constants/assets.dart';
import '../theme/theme_utils/app_colors.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.text,
    required this.body,
    required this.onDelete,
    this.loading = false,
  });

  final String text;
  final String body;
  final Function() onDelete;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AssetConstants.resumeDeleteIcon,
            height: 78.h,
            width: 78.w,
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(text,
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(body, style: context.textTheme.labelMedium),
          SizedBox(
            height: 18.h,
          ),
          loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : Row(
                  children: List.generate(
                  2,
                  (i) => Expanded(
                    child: Padding(
                      padding: i.isEven
                          ? EdgeInsets.only(right: 4.w)
                          : EdgeInsets.only(left: 4.w),
                      child: PrimaryButton(
                        height: 45.h,
                        buttonColor:
                            i.isEven ? AppColors.grey : AppColors.redColor,
                        onPressed: () {
                          if (i.isEven) {
                            context.pop();
                          } else {
                            onDelete();
                          }
                        },
                        textStyle: TextStyle(
                            fontWeight:
                                i.isOdd ? FontWeight.bold : FontWeight.w400,
                            color: i.isEven
                                ? AppColors.blackColor
                                : AppColors.whiteColor),
                        text: i.isEven ? 'Cancel' : 'Yes',
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
