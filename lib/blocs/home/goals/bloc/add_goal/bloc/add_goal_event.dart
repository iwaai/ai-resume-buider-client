part of 'add_goal_bloc.dart';

@immutable
sealed class AddGoalEvent {}

class UpdateMainGoalTitle extends AddGoalEvent {
  final String title;

  UpdateMainGoalTitle({required this.title});
}

class MainGoalDatePicker extends AddGoalEvent {
  final DateTime endDate;

  MainGoalDatePicker({required this.endDate});
}

class AddSubgoal extends AddGoalEvent {}

class RemoveASubgoal extends AddGoalEvent {
  final int index;

  RemoveASubgoal({required this.index});
}

class UpdateASubgoal extends AddGoalEvent {
  final int index;
  final String value;

  UpdateASubgoal({required this.index, required this.value});
}

class UpdateSubGoalDate extends AddGoalEvent {
  final int index;

  final DateTime endDate;
  UpdateSubGoalDate({required this.index, required this.endDate});
}

class AddSupportPeople extends AddGoalEvent {
  final List<SupportPeople> supportPeople;

  AddSupportPeople({required this.supportPeople});
}

// class UpdateSupportPeople extends AddGoalEvent {
//   final List<SupportPeople> people;

//   UpdateSupportPeople(this.people);
// }

class UpdateSupportPerson extends AddGoalEvent {
  final int index;
  final SupportPeople updatedPerson;

  UpdateSupportPerson({required this.index, required this.updatedPerson});
}

class RemoveSupportPeople extends AddGoalEvent {
  final int index;

  RemoveSupportPeople({required this.index});
}

class NextGoalEvent extends AddGoalEvent {}

class PrevoiusGoalEvent extends AddGoalEvent {}

class ResetQustionAnswer extends AddGoalEvent {}

class CreateGoal extends AddGoalEvent {}

class UpdateQ1Answer extends AddGoalEvent {
  final String answer;

  UpdateQ1Answer({required this.answer});
}

class UpdateQ2Answer extends AddGoalEvent {
  final String answer2;

  UpdateQ2Answer({required this.answer2});
}

class UpdateQ3Answer extends AddGoalEvent {
  final String answer3;

  UpdateQ3Answer({required this.answer3});
}

class UpdateQ4Answer extends AddGoalEvent {
  final String answer4;

  UpdateQ4Answer({required this.answer4});
}

class UpdateQ5Answer extends AddGoalEvent {
  final String answer5;

  UpdateQ5Answer({required this.answer5});
}

class ClearFields extends AddGoalEvent {}
