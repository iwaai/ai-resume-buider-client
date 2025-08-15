import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class AssessmentStepper extends StatelessWidget {
  const AssessmentStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TakeAssessmentBloc>(),
      child: BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
          builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Steps',
                  style: context.textTheme.labelMedium!
                      .copyWith(color: AppColors.blackColor),
                ),
                Text(
                  '${state.step}/24',
                  style: context.textTheme.labelMedium!
                      .copyWith(color: AppColors.blackColor),
                ),
              ],
            ),
            SizedBox(
              height: 4.w,
            ),
            Container(
              height: 6.h,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(90),
              ),
              child: Row(
                children: [
                  ...List.generate(
                    24,
                    (i) {
                      return AssessmentStepperSteps(
                          isNotDone: i >= state.step,
                          isFirst: i == 0,
                          isLast: i == 23);
                    },
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class AssessmentStepperSteps extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isNotDone;
  const AssessmentStepperSteps(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isNotDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: EdgeInsets.only(
            left: isFirst ? 0.w : 1.w, right: isLast ? 0.w : 1.w),
        height: 6.h,
        decoration: BoxDecoration(
          gradient: isNotDone ? null : AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? 90 : 0),
            bottomLeft: Radius.circular(isFirst ? 90 : 0),
            bottomRight: Radius.circular(isLast ? 90 : 0),
            topRight: Radius.circular(isLast ? 90 : 0),
          ),
        ),
      ),
    );
  }
}
