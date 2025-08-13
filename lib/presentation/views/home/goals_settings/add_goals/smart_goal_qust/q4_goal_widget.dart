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

class Q4GoalWidget extends StatelessWidget {
  const Q4GoalWidget({super.key, required this.bloc});

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
              "Relevant",
              style: context.textTheme.titleLarge,
            ),
            Constant.verticalSpace(10.h),
            Text(
              "When a goal is relevant, it means it’s important to you and fits with what you want in life.",
              style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.blackColor),
            ),
            Constant.verticalSpace(10.h),
            const CustomText(
              text: 'Can I really do this with what I have?',
            ),
            Constant.verticalSpace(6.h),
            const CustomText(
              text: 'Is this something I can work on now?',
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
                        initialValue: state.q3Answer
                        // .isEmpty
                        //     ? state.q2Answer
                        //     : state.q3Answer,
                        //  state.q4Answer.isEmpty
                        //     ? "${state.q3Answer}${state.q4Answer}"
                        //     : state.q4Answer,
                        // onChanged: (value) {
                        //   state.q4Answer = value;
                        //   state.q5Answer = value;
                        //   print("Q4 : ${state.q4Answer}");
                        // },
                        ),
                    Constant.verticalSpace(8.h),
                    Text("Make it Relevant",
                        style: context.textTheme.titleMedium),
                    Constant.verticalSpace(5.h),
                    PrimaryTextField(
                      initialValue: state.q4Answer,
                      hintText: 'Revise goal here!',
                      onChanged: (value) {
                        // state.q4Answer = value;
                        // state.q5Answer = value;
                        // state.q4Answer = value.isEmpty ? state.q3Answer : value;
                        bloc.add(UpdateQ4Answer(answer4: value));
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
