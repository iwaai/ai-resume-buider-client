part of 'goals_bloc.dart';

abstract class GoalsEvent {}

class GetGoalsData extends GoalsEvent {}

class AddNewGoalEvent extends GoalsEvent {
  final CreateGoalModel createGoalModel;
  AddNewGoalEvent({required this.createGoalModel});
}

class GoalDetailEvent extends GoalsEvent {
  final String goalId;

  GoalDetailEvent({required this.goalId});
}

// class SupportPeopleEvent extends GoalsEvent {
//   final SupportPeopleModel supportPeople;
//   SupportPeopleEvent({required this.supportPeople});
// }

class DeleteGoalEvent extends GoalsEvent {}

class UpdateSubGoalStatus extends GoalsEvent {
  final String subGoalId;
  UpdateSubGoalStatus({required this.subGoalId});
}

class UpdateMainGoalStatus extends GoalsEvent {}

class EditSupportPeopleEvent extends GoalsEvent {
  final List<SupportPeople> supPeople;

  EditSupportPeopleEvent({required this.supPeople});
}

class SearchGoalsEvent extends GoalsEvent {
  final String query;
  SearchGoalsEvent(this.query);
}
