import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/views/home/goals_settings/add_goals/smart_goal_qust/q1_goal_widget.dart';

import 'q2_goal_widget.dart';
import 'q3_goal_widget.dart';
import 'q4_goal_widget.dart';
import 'q5_goal_widget.dart';

class GoalQustionRender extends StatelessWidget {
  const GoalQustionRender({super.key, required this.bloc});

  final AddGoalBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddGoalBloc, AddGoalState>(builder: (context, state) {
      switch (state.currentStep) {
        case 1:
          return Q1GoalWidget(
            bloc: bloc,
          );
        case 2:
          return Q2GoalWidget(
            bloc: bloc,
          );
        case 3:
          return Q3GoalWidget(
            bloc: bloc,
          );
        case 4:
          return Q4GoalWidget(
            bloc: bloc,
          );
        case 5:
          return Q5GoalWidget(
            bloc: bloc,
          );

        default:
          return const SizedBox();
      }
    });
  }
}
