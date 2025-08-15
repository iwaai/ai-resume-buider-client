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

class Q3GoalWidget extends StatelessWidget {
  const Q3GoalWidget({super.key, required this.bloc});

  final AddGoalBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddGoalBloc>.value(
      value: bloc,
      // ..add(UpdateQ3Answer(
      //     answer3: context.read<AddGoalBloc>().state.q3Answer)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Achievable",
              style: context.textTheme.titleLarge,
            ),
            Constant.verticalSpace(10.h),
            Text(
              "When something is achievable, it means it’s something you can do. It’s like setting a goal that’s just right—not too easy but not too hard. Here’s how to check if a goal is achievable if it answers the following questions:",
              style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.blackColor),
            ),
            Constant.verticalSpace(10.h),
            const CustomText(
              text: 'Do I have what I need to do this?',
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'Is it something I can do?',
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'Is it too big or too small?',
            ),
            Constant.verticalSpace(20.h),
            BlocBuilder<AddGoalBloc, AddGoalState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PrimaryTextField(
                      hintText: 'Describe here',
                      initialValue: state.q2Answer,
                      validator: validateField,
                      readOnly: true,
                      // onChanged: (value) {
                      //   state.q3Answer = value;
                      //   state.q4Answer = value;
                      //   state.q5Answer = value;
                      //   // state.q3Answer.isEmpty
                      //   //     ? "${state.q1Answer}${state.q2Answer}${state.q3Answer}"
                      //   //     : state.q3Answer;
                      // },
                    ),
                    Constant.verticalSpace(8.h),
                    Text("Make it Achievable",
                        style: context.textTheme.titleMedium),
                    Constant.verticalSpace(5.h),
                    PrimaryTextField(
                      initialValue: state.q3Answer,
                      hintText: 'Revise goal here!',
                      onChanged: (value) {
                        bloc.add(UpdateQ3Answer(answer3: value));
                        // state.q3Answer = value.isEmpty ? state.q2Answer : value;
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
