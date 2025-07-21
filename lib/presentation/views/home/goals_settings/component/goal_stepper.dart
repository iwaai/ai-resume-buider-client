import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';

class GoalStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const GoalStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("$totalSteps");
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(90),
            right: Radius.circular(90),
          )),
      height: 6.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) => Expanded(
            child: AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              margin: EdgeInsets.symmetric(horizontal: 2.w).copyWith(
                  left: index == 0 ? 0.w : 2.w, right: index == 4 ? 0.w : 2.w),
              height: 6.h,
              decoration: BoxDecoration(
                gradient:
                    index < currentStep ? AppColors.primaryGradient : null,
                // color: index < currentStep ? null : AppColors.whiteColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(index == 0 ? 90 : 0),
                  right: Radius.circular(index == 4 ? 90 : 0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
