import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/views/home/components/goal_card.dart';
import 'package:second_shot/utils/constants/constant.dart';

class GoalSearchScreen extends StatelessWidget {
  const GoalSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as GoalsBloc;
    return ScaffoldWrapper(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: "Search",
      ),
      body: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<GoalsBloc, GoalsState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.horizontalPadding.h),
                  child: PrimaryTextField(
                    initialValue: state.query,
                    hintText: 'Search',
                    onChanged: (value) {
                      context.read<GoalsBloc>().add(SearchGoalsEvent(value));
                    },
                  ),
                ),
                if (state.query.isEmpty && state.filterGoalList.isEmpty)
                  const Expanded(child: Center(child: Text('Start Searching')))
                else
                  Expanded(
                    child:
                        state.query.isNotEmpty && state.filterGoalList.isEmpty
                            ? const Center(child: Text('Search Not Found'))
                            : ListView.builder(
                                itemCount: state.filterGoalList.length,
                                itemBuilder: (context, index) => GoalCard(
                                  goalModel: state.filterGoalList[index],
                                  onTap: () {
                                    context.read<GoalsBloc>().add(GoalDetailEvent(
                                        goalId:
                                            '${state.filterGoalList[index].goalId}'));
                                    context.push(AppRoutes.finilizedGoalDetail,
                                        extra: context.read<GoalsBloc>());
                                  },
                                ),
                              ),
                  )
              ],
            );
          },
        ),
      ),
    ));
  }
}
