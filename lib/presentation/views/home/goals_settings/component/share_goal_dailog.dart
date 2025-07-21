import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../../utils/constants/constant.dart';
import '../../../../components/primary_button.dart';
import '../../../../theme/theme_utils/app_colors.dart';

class GoalSectionDailog {
  static Future<void> showShareGoalDialog(
      {required BuildContext context,
      AddGoalBloc? argument,
      VoidCallback? onNoTap,
      VoidCallback? onYesTap}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Image.asset(
            AssetConstants.shareGoalDialog,
            width: 162.w,
            height: 153.h,
          ),
          content: Text(
            'Would you like to share your goal with your support network?',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(fontSize: 18.sp),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
          actionsPadding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          actions: <Widget>[
            if (argument != null)
              BlocProvider.value(
                value: argument,
                child: BlocBuilder<AddGoalBloc, AddGoalState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                              // loading: state.loading,
                              borderRadius: 8.r,
                              buttonColor: const Color(0xFFE5EAED),
                              textColor: AppColors.blackColor,
                              textStyle: context.textTheme.titleMedium
                                  ?.copyWith(fontSize: 16.sp),
                              onPressed: onNoTap ??
                                  () {
                                    context.pop();
                                  },

                              // () {
                              //   Navigator.of(dialogContext).pop();

                              // },
                              text: 'No'),
                        ),
                        Constant.horizontalSpace(12.w),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: state.loading,
                            child: PrimaryButton(
                                // loading: state.loading,
                                borderRadius: 8.r,
                                textStyle: context.textTheme.titleMedium
                                    ?.copyWith(
                                        fontSize: 16.sp,
                                        color: AppColors.whiteColor),
                                onPressed: onYesTap ??
                                    () {
                                      context.pop();
                                      // if (state.supportPeople.length < 2) {
                                      //   context.push(AppRoutes.supportPeople,
                                      //       extra: argument);
                                      // } else {
                                      //   context.pop();
                                      //   context
                                      //       .read<AddGoalBloc>()
                                      //       .add(CreateGoal());
                                      // }
                                    },
                                text: 'Yes'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
          ],
        );
      },
    );
  }
}
