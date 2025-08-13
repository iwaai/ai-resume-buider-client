part of 'add_goal_bloc.dart';

@immutable
// ignore: must_be_immutable
class AddGoalState {
  final Result? result;
  final bool loading;
  String title;
  final String? mainGoalDate;

  final DateTime? startDate;
  final DateTime? endDate;
  final List<SupportPeople> supportPeople;
  final List<String> goalQustionList;
  final int currentStep;
  final int totalSteps;
  String q1Answer;
  String q2Answer;
  String q3Answer;
  String q4Answer;
  String q5Answer;
  CreateGoalModel? goalModel;
  final List<SubGoals> subgoalsData;

  // final List<Widget> questions;

  AddGoalState(
      {required this.result,
      this.title = '',
      this.mainGoalDate,
      this.loading = false,
      this.endDate,
      this.supportPeople = const [],
      this.goalQustionList = const [],
      this.startDate,
      this.currentStep = 1,
      this.totalSteps = 5,
      this.q1Answer = '',
      this.q2Answer = '',
      this.q3Answer = '',
      this.q4Answer = '',
      this.q5Answer = '',
      this.goalModel,
      this.subgoalsData = const []});

  AddGoalState copyWith({
    Result? result,
    bool? loading,
    String? title,
    String? mainGoalDate,
    DateTime? startDate,
    List<SupportPeople>? supportPeople,
    List<String>? goalQustionList,
    DateTime? endDate,
    int? currentStep,
    int? totalSteps,
    String? q1Answer,
    String? q2Answer,
    String? q3Answer,
    String? q4Answer,
    String? q5Answer,
    List<SubGoals>? subgoalsData,
    CreateGoalModel? goalModel,
  }) {
    return AddGoalState(
      result: result,
      loading: loading ?? this.loading,
      title: title ?? this.title,
      mainGoalDate: mainGoalDate ?? this.mainGoalDate,
      startDate: startDate ?? this.startDate,
      supportPeople: supportPeople ?? this.supportPeople,
      endDate: endDate ?? this.endDate,
      goalQustionList: goalQustionList ?? this.goalQustionList,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: currentStep ?? this.totalSteps,
      q1Answer: q1Answer ?? this.q1Answer,
      q2Answer: q2Answer ?? this.q2Answer,
      q3Answer: q3Answer ?? this.q3Answer,
      q4Answer: q4Answer ?? this.q4Answer,
      q5Answer: q5Answer ?? this.q5Answer,
      subgoalsData: subgoalsData ?? this.subgoalsData,
      goalModel: goalModel ?? this.goalModel,
    );
  }

  factory AddGoalState.idle() {
    return AddGoalState(result: Result.idle(), loading: false);
  }
}
