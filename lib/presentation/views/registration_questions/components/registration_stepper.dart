import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/extensions.dart';

class RegistrationStepper extends StatelessWidget {
  const RegistrationStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<RegistrationQuestionsBloc>(),
      child: BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
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
                  '${state.step}/8',
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
                    8,
                    (i) {
                      return RegistrationStepperSteps(
                          isNotDone: i >= state.step,
                          isFirst: i == 0,
                          isLast: i == 7);
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

class RegistrationStepperSteps extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isNotDone;
  const RegistrationStepperSteps(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isNotDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
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
