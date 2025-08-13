import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';
import '../../../../../components/primary_textfields.dart';
import '../../../../../theme/theme_utils/app_colors.dart';
import '../../component/custom_text.dart';

class Q2GoalWidget extends StatelessWidget {
  const Q2GoalWidget({super.key, required this.bloc});

  final AddGoalBloc bloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddGoalBloc>.value(
      value: bloc,
      // ..add(
      //     UpdateQ1Answer(answer: context.read<AddGoalBloc>().state.q1Answer)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Measurable",
              style: context.textTheme.titleLarge,
            ),
            Constant.verticalSpace(10.h),
            Text(
              "When something is measurable, it means you can count or track it to see how well you’re doing. You can make your goal measurable by answering the following questions",
              style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.blackColor),
            ),
            Constant.verticalSpace(10.h),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'How much?',
                ),
                CustomText(
                  text: 'How will I know I did it?',
                ),
              ],
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'How many?',
            ),
            Constant.verticalSpace(20.h),
            BlocBuilder<AddGoalBloc, AddGoalState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PrimaryTextField(
                      readOnly: true,
                      validator: validateField,
                      initialValue: state.q1Answer,
                      // onChanged: (value) {
                      //   state.q3Answer = value;
                      //   state.q2Answer = value;
                      //   state.q4Answer = value;
                      //   state.q5Answer = value;
                      // },
                      hintText: 'Describe here',
                    ),
                    Constant.verticalSpace(8.h),
                    Text("Make it Measurable",
                        style: context.textTheme.titleMedium),
                    Constant.verticalSpace(5.h),
                    PrimaryTextField(
                      initialValue: state.q2Answer,
                      hintText: 'Revise goal here!',
                      onChanged: (value) {
                        // state.q2Answer = value;
                        // if (value.isEmpty) {
                        //   state.q2Answer = state.q1Answer;
                        // } else {
                        //   state.q2Answer = value;
                        // }
                        // state.q2Answer = value.isEmpty ? state.q1Answer : value;
                        bloc.add(UpdateQ2Answer(answer2: value));
                        log("==> ${state.q2Answer}");
                        // state.q3Answer = value;

                        // state.q4Answer = value;
                        // state.q5Answer = value;
                      },
                      validator: validateField,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
