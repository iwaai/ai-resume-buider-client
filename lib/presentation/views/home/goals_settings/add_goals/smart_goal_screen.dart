import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q1_goal_widget.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q2_goal_widget.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q3_goal_widget.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q4_goal_widget.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q5_goal_widget.dart';
import 'package:second_shot/presentation/views/home/goals_settings/component/goal_stepper.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../theme/theme_utils/app_colors.dart';

class SmartGoalScreen extends StatelessWidget {
  SmartGoalScreen({super.key, required this.bloc});

  final AddGoalBloc bloc;

  late final List<Widget> questions = [
    Q1GoalWidget(bloc: bloc), // Removed `const`
    Q2GoalWidget(bloc: bloc),
    Q3GoalWidget(bloc: bloc),
    Q4GoalWidget(bloc: bloc),
    Q5GoalWidget(bloc: bloc),
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<AddGoalBloc, AddGoalState>(
        builder: (context, state) {
          return ScaffoldWrapper(
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Create S.M.A.R.T Goal',
                isBackButton: true,
                onClick: () {
                  if (state.currentStep > 0) {
                    if (state.currentStep == 1) {
                      context.read<AddGoalBloc>().add(ResetQustionAnswer());
                      context.pop();
                      // print("State == ${state.currentStep}");
                    }
                    // print("State is ${state.currentStep}");
                    context.read<AddGoalBloc>().add(PrevoiusGoalEvent());
                  } else {
                    context.pop();
                  }
                },
                bottomWidget: PreferredSize(
                    preferredSize: Size(0, 60.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.h),
                      child: Text(
                          style: TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                          'Type your goal in the chat and add make it a Smart Goal. Review and add the sub goals you want to focus on'),
                    )),
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Steps',
                            style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                          Text(
                            '0${state.currentStep}/05',
                            style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Stepper Progress
                    GoalStepper(
                      currentStep: state.currentStep,
                      totalSteps: 5,
                    ),
                    SizedBox(height: 24.h),
                    // Question Display
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: questions[state.currentStep - 1],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.horizontalPadding.w,
                          vertical: Constant.verticalPadding.h),
                      child: PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (state.currentStep < 5) {
                              context.read<AddGoalBloc>().add(NextGoalEvent());
                              if (state.currentStep == 1) {
                                bloc.add(// ..add(
                                    UpdateQ1Answer(answer: state.q1Answer));
                              } else if (state.currentStep == 2) {
                                bloc.add(
                                    UpdateQ2Answer(answer2: state.q2Answer));
                              } else if (state.currentStep == 3) {
                                bloc.add(
                                    UpdateQ3Answer(answer3: state.q3Answer));
                              } else if (state.currentStep == 4) {
                                bloc.add(
                                    UpdateQ4Answer(answer4: state.q4Answer));
                              }
                            } else {
                              state.title = state.q5Answer;
                              bloc.add(UpdateQ5Answer(
                                answer5: state.q5Answer,
                              ));
                              context.push(AppRoutes.createGoal, extra: bloc);
                            }
                          }
                        },
                        borderRadius: 12.r,
                        text: "Next",
                        textSize: 14.sp,
                      ),
                    ),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (state.currentStep < 5) {
                            context.read<AddGoalBloc>().add(NextGoalEvent());
                            if (state.currentStep == 1) {
                              bloc.add(// ..add(
                                  UpdateQ1Answer(answer: state.q1Answer));
                            } else if (state.currentStep == 2) {
                              bloc.add(UpdateQ2Answer(answer2: state.q2Answer));
                            } else if (state.currentStep == 3) {
                              bloc.add(UpdateQ3Answer(answer3: state.q3Answer));
                            } else if (state.currentStep == 4) {
                              bloc.add(UpdateQ4Answer(answer4: state.q4Answer));
                            }
                          } else {
                            state.title = state.q5Answer;
                            bloc.add(UpdateQ5Answer(
                              answer5: state.q5Answer,
                            ));
                            context.push(AppRoutes.createGoal, extra: bloc);
                          }
                        },
                        child: Text(
                          'Do Not Revise',
                          style: context.textTheme.bodyMedium!.copyWith(
                            decorationThickness: 0.6,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                            decorationColor: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Constant.verticalSpace(20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
