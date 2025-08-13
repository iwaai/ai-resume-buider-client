import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.goalModel, required this.onTap});

  final CreateGoalModel goalModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final Color statusColor = _getStatusColor(goalModel.status.toString());
        final Color backgroudColor =
            _getBackgroundColor(goalModel.status.toString());
        final String buttonText = goalModel.status.toString();

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constant.horizontalPadding.w,
            vertical: Constant.verticalPadding.h,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26.r),
                color: AppColors.whiteColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: backgroudColor,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 10.h,
                                  ),
                                  backgroundColor: AppColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  buttonText,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          goalModel.mainGoalName.toString(),
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.blackColor),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w, // Reduced padding
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Deadline",
                              style: context.textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp), // Slightly smaller font
                            ),
                            Row(
                              children: [
                                Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  "${formatDate1(goalModel.createdAt.toString())} |\n${formatDate1(goalModel.deadline.toString())}",
                                  style: context.textTheme.labelMedium,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF0F2F4),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w, // Reduced padding
                                vertical: 8.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: onTap,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'View Details',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp, // Smaller font size
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case Constant.notStartedYet:
        return AppColors.redColor;
      case Constant.inProgress:
        return AppColors.yellowColor;
      case Constant.completed:
        return AppColors.lightBlueColor;
      default:
        return AppColors.grey;
    }
  }

  Color _getBackgroundColor(String status) {
    switch (status) {
      case Constant.notStartedYet:
        return AppColors.lightPink;
      case Constant.inProgress:
        return AppColors.lightYellow;
      case Constant.completed:
        return const Color(0xFF1FBA46).withOpacity(0.13);
      default:
        return AppColors.grey;
    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
// import 'package:second_shot/models/goal_model.dart';
// import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
// import 'package:second_shot/utils/constants/constant.dart';
// import 'package:second_shot/utils/extensions.dart';

// class GoalCard extends StatelessWidget {
//   const GoalCard({super.key, required this.goalModel, required this.onTap});

//   final CreateGoalModel goalModel;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GoalsBloc, GoalsState>(
//       builder: (context, state) {
//         final Color statusColor = _getStatusColor(goalModel.status.toString());
//         final Color backgroudColor =
//             _getBackgroundColor(goalModel.status.toString());
//         final String buttonText = goalModel.status.toString();

//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: Constant.horizontalPadding.w,
//             vertical: Constant.verticalPadding.h,
//           ),
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(26.r),
//                 color: AppColors.whiteColor,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: backgroudColor,
//                       borderRadius: BorderRadius.circular(22.r),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextButton(
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 15.w,
//                                   vertical: 10.h,
//                                 ),
//                                 backgroundColor: AppColors.whiteColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(25.r),
//                                 ),
//                               ),
//                               onPressed: () {},
//                               child: Text(
//                                 buttonText,
//                                 style: context.textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.w500,
//                                   color: statusColor, // Status-based color
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Constant.verticalSpace(20.h),
//                         Text(
//                           goalModel.mainGoalName.toString(),
//                           style: context.textTheme.bodyMedium
//                               ?.copyWith(color: AppColors.blackColor),
//                         ),
//                         Constant.verticalSpace(10.h),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: Constant.horizontalPadding.w / 2,
//                       vertical: Constant.verticalPadding.h,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               "Deadline",
//                               style: context.textTheme.titleMedium
//                                   ?.copyWith(fontSize: 18.sp),
//                             ),
//                             Text(
//                               "${formatDate1(goalModel.createdAt.toString())} | ${formatDate1(goalModel.deadline.toString())}",
//                               style: context.textTheme.labelMedium,
//                             )
//                           ],
//                         ),
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: const Color(0xFFF0F2F4),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 12.h,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.sp),
//                             ),
//                           ),
//                           onPressed: onTap,
//                           child: Text(
//                             'View Details',
//                             style: context.textTheme.titleMedium
//                                 ?.copyWith(color: AppColors.primaryColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Helper method to get color based on status
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case Constant.notStartedYet:
//         return AppColors.redColor;
//       case Constant.inProgress:
//         return AppColors.yellowColor;
//       case Constant.completed:
//         return AppColors.lightBlueColor;
//       default:
//         return AppColors.grey; // Default color
//     }
//   }

//   Color _getBackgroundColor(String status) {
//     switch (status) {
//       case Constant.notStartedYet:
//         return AppColors.lightPink;
//       case Constant.inProgress:
//         return AppColors.lightYellow;
//       case Constant.completed:
//         return const Color(0xFF1FBA46).withOpacity(0.13);
//       default:
//         return AppColors.grey; // Default color
//     }
//   }
// }