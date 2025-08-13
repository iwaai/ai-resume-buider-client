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

class Q5GoalWidget extends StatelessWidget {
  const Q5GoalWidget({super.key, required this.bloc});

  final AddGoalBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Time-Bound",
              style: context.textTheme.titleLarge,
            ),
            Constant.verticalSpace(10.h),
            Text(
              "When a goal is time-bound, it means you give yourself a deadline or a specific time to finish it.",
              style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.blackColor),
            ),
            Constant.verticalSpace(10.h),
            const CustomText(
              text: 'What’s my deadline?',
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'How long will I work on this each day?',
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'When do I want to finish?',
            ),
            Constant.verticalSpace(20.h),
            BlocBuilder<AddGoalBloc, AddGoalState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextField(
                      readOnly: true,
                      hintText: 'Describe here',
                      validator: validateField,
                      initialValue: state.q4Answer.isEmpty
                          ? state.q3Answer
                          : state.q4Answer,
                      // onChanged: (value) {
                      //   state.q5Answer = value;
                      //   state.title = value;
                      //   debugPrint("Q5 : ${state.q5Answer}");
                      // },
                    ),
                    Constant.verticalSpace(8.h),
                    Text("Make it Time-Bound",
                        style: context.textTheme.titleMedium),
                    Constant.verticalSpace(5.h),
                    PrimaryTextField(
                      initialValue: state.q5Answer,
                      hintText: 'Revise goal here!',
                      onChanged: (value) {
                        // state.q5Answer = value.isEmpty ? state.q4Answer : value;
                        // state.q5Answer = state.title;
                        bloc.add(UpdateQ5Answer(answer5: value));
                        state.q5Answer = state.title;
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
