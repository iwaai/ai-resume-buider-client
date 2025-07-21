import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../component/custom_text.dart';

class Q1GoalWidget extends StatelessWidget {
  const Q1GoalWidget({super.key, required this.bloc});

  final AddGoalBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddGoalBloc>.value(
        value: bloc,
        // ..add(
        //     UpdateQ1Answer(answer: context.read<AddGoalBloc>().state.title)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Specific",
                style: context.textTheme.titleLarge,
              ),
              Constant.verticalSpace(10.h),
              Text(
                "When a goal is specific, it's like drawing a clear picture in your mind of what you want to do. You can make your goal specific by answering the following questions:",
                style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.blackColor),
              ),
              Constant.verticalSpace(10.h),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'What do I want to do?',
                  ),
                  CustomText(
                    text: 'Why do I want to do it?',
                  ),
                ],
              ),
              Constant.verticalSpace(6.h),
              const CustomText(
                text: 'How will I do it?',
              ),
              Constant.verticalSpace(20.h),
              BlocBuilder<AddGoalBloc, AddGoalState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextField(
                        initialValue: state.title,
                        readOnly: true,
                        hintText: 'Describe here',
                        validator: validateField,
                      ),
                      Constant.verticalSpace(8.h),
                      Text("Make it Specific",
                          style: context.textTheme.titleMedium),
                      Constant.verticalSpace(5.h),
                      PrimaryTextField(
                        initialValue: state.q1Answer,
                        hintText: 'Revise goal here!',
                        onChanged: (value) {
                          // state.q1Answer = "$value";
                          // state.q1Answer = value.isEmpty ? state.title : value;
                          print("=====$value");
                          bloc.add(UpdateQ1Answer(answer: value));
                          // state.q2Answer = value;
                          // state.q3Answer = value;
                          // state.q4Answer = value;
                          // state.q5Answer = value;
                          debugPrint("Q1 ${state.q1Answer}");
                        },
                        validator: validateField,
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ));
  }
}
