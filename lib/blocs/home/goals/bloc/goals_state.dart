part of 'goals_bloc.dart';

class GoalsState {
  final List<CreateGoalModel> goalsList;
  final List<CreateGoalModel> filterGoalList;
  final CreateGoalModel? goal;
  final Result? result;
  final bool loading;
  final CreateGoalModel? goalDtail;
  final String query;

  GoalsState(
      {this.goalsList = const [],
      this.result,
      this.query = '',
      this.loading = false,
      this.goalDtail,
      this.goal,
      this.filterGoalList = const []});

  GoalsState copyWith(
      {List<CreateGoalModel>? goalsList,
      List<CreateGoalModel>? filterGoalList,
      Result? result,
      bool? loading,
      CreateGoalModel? goalDtail,
      CreateGoalModel? goal,
      String? query}) {
    return GoalsState(
        goalsList: goalsList ?? this.goalsList,
        result: result ?? this.result,
        goal: goal ?? this.goal,
        goalDtail: goalDtail ?? this.goalDtail,
        loading: loading ?? this.loading,
        filterGoalList: filterGoalList ?? this.filterGoalList,
        query: query ?? this.query);
  }

  factory GoalsState.idle() {
    return GoalsState(
      result: Result.idle(),
      loading: false,
      goalsList: [],
      goal: null,
    );
  }
}
