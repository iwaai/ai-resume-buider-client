import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/data/repos/goal_repo.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'add_goal_event.dart';
part 'add_goal_state.dart';

class AddGoalBloc extends Bloc<AddGoalEvent, AddGoalState> {
  final GoalsBloc goalsBloc;
  AddGoalBloc(this.goalsBloc) : super(AddGoalState.idle()) {
    on<UpdateMainGoalTitle>((event, emit) => _updateMainGoalTitle(event, emit));
    on<MainGoalDatePicker>((event, emit) => _mainGoalDatePicker(event, emit));
    on<AddSubgoal>((event, emit) => _addASubgoal(event, emit));
    on<RemoveASubgoal>((event, emit) => _removeASubgoal(event, emit));
    on<UpdateASubgoal>((event, emit) => _updateASubgoal(event, emit));
    on<UpdateSubGoalDate>((event, emit) => _updateSubGoalDate(event, emit));
    on<AddSupportPeople>((event, emit) => _addSupportPeople(event, emit));
    on<RemoveSupportPeople>((event, emit) => _removeSupportPeople(event, emit));
    on<NextGoalEvent>((event, emit) => _nextStep(event, emit));
    on<PrevoiusGoalEvent>((event, emit) => _prevoiusStep(event, emit));
    on<ResetQustionAnswer>((event, emit) => _resetQustion(event, emit));
    on<CreateGoal>((event, emit) => _createGoal(event, emit));
    on<UpdateQ1Answer>((event, emit) => updateQ1Answer(event, emit));
    on<UpdateQ2Answer>((event, emit) => updateQ2Answer(event, emit));
    on<UpdateQ3Answer>((event, emit) => updateQ3Answer(event, emit));
    on<UpdateQ4Answer>((event, emit) => updateQ4Answer(event, emit));
    on<UpdateQ5Answer>((event, emit) => updateQ5Answer(event, emit));
    on<ClearFields>((event, emit) => clearFields(event, emit));
    on<UpdateSupportPerson>((event, emit) => _updateSupportPeople(event, emit));
  }

  final goalRepo = GoalRepo();

  void _updateMainGoalTitle(UpdateMainGoalTitle event, Emitter emit) {
    emit(state.copyWith(title: event.title));
  }

  void _mainGoalDatePicker(MainGoalDatePicker event, Emitter emit) {
    emit(state.copyWith(endDate: event.endDate));
  }

  void _updateSupportPeople(UpdateSupportPerson event, Emitter emit) {
    final updatedList = List<SupportPeople>.from(state.supportPeople);
    updatedList[event.index] = event.updatedPerson;
    emit(state.copyWith(supportPeople: updatedList));
  }

  void _addASubgoal(AddSubgoal event, Emitter emit) {
    List<SubGoals> subgoals = [...state.subgoalsData];
    subgoals.add(SubGoals(name: '', deadline: null));

    emit(state.copyWith(subgoalsData: subgoals));
  }

  void _removeASubgoal(RemoveASubgoal event, Emitter<AddGoalState> emit) {
    debugPrint("Removing subgoal at index: ${event.index}");
    List<SubGoals> subgoals = List.from(state.subgoalsData);

    if (event.index >= 0 && event.index < subgoals.length) {
      subgoals.removeAt(event.index);
      debugPrint("Subgoal removed. New length: ${subgoals.length}");
      emit(state.copyWith(subgoalsData: subgoals));
    } else {
      debugPrint("Invalid index: ${event.index}");
    }
  }

  void _updateASubgoal(UpdateASubgoal event, Emitter emit) {
    final updatedSubgoals = List<SubGoals>.from(state.subgoalsData);
    updatedSubgoals[event.index] =
        updatedSubgoals[event.index].copyWith(name: event.value);
    emit(state.copyWith(subgoalsData: updatedSubgoals));
  }

  void _updateSubGoalDate(UpdateSubGoalDate event, Emitter emit) {
    final updatedSubgoals = List<SubGoals>.from(state.subgoalsData);
    updatedSubgoals[event.index] = updatedSubgoals[event.index].copyWith(
      deadline: event.endDate,
    );
    emit(state.copyWith(subgoalsData: updatedSubgoals));
  }

  void _addSupportPeople(AddSupportPeople event, Emitter emit) {
    // if (state.supportPeople.length < 2) {
    //   List<SupportPeople> supportPeople = [...state.supportPeople];
    //   supportPeople.addAll(event.supportPeople);
    //   emit(state.copyWith(supportPeople: supportPeople));
    // }
    emit(state.copyWith(supportPeople: event.supportPeople));
  }

  void _removeSupportPeople(RemoveSupportPeople event, Emitter emit) {
    List<SupportPeople> supportPeople = [...state.supportPeople];
    supportPeople.removeAt(event.index);
    emit(state.copyWith(supportPeople: supportPeople));
  }

  void _nextStep(NextGoalEvent event, Emitter emit) {
    if (state.currentStep < 5) {
      final step = state.currentStep + 1;
      // Use the event index to emit a new state with the incremented step.
      emit(state.copyWith(currentStep: step));
    }
  }

  void _prevoiusStep(PrevoiusGoalEvent event, Emitter emit) {
    if (state.currentStep > 1) {
      final step = state.currentStep - 1;
      // Use the event index to emit a new state with the decremented step.
      emit(state.copyWith(currentStep: step));
    }
  }

  void _resetQustion(ResetQustionAnswer event, Emitter emit) {
    emit(state.copyWith(
      q1Answer: '',
      q2Answer: '',
      q3Answer: '',
      q4Answer: '',
      q5Answer: '',
    ));
  }

  void _createGoal(CreateGoal event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    CreateGoalModel goalModel = CreateGoalModel(
      mainGoalName: state.title,
      deadline: state.endDate == null
          ? formatDate1(
              DateTime.now().add(const Duration(days: 90)).toIso8601String())
          : state.endDate.toString(),
      subGoals: state.subgoalsData,
      supportPeople: state.supportPeople,
    );

    await goalRepo.createGoal(
        onSuccess: (CreateGoalModel goal) {
          goalsBloc.add(AddNewGoalEvent(createGoalModel: goal));
          goalsBloc.add(GoalDetailEvent(goalId: goal.goalId.toString()));

          emit(
            AddGoalState.idle().copyWith(
              q5Answer: state.q5Answer,
              goalModel: goal,
              result: Result.successful(
                state.result?.message ?? "",
                event,
              ),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        },
        goalModel: goalModel);
  }

  void updateQ1Answer(UpdateQ1Answer event, Emitter emit) {
    var q1Answer = event.answer.isEmpty ? state.title : event.answer;

    emit(state.copyWith(q1Answer: q1Answer, q2Answer: ''));
  }

  void updateQ2Answer(UpdateQ2Answer event, Emitter emit) {
    var q2Answer = event.answer2.isEmpty ? state.q1Answer : event.answer2;
    emit(state.copyWith(q2Answer: q2Answer, q3Answer: ''));
  }

  void updateQ3Answer(UpdateQ3Answer event, Emitter emit) {
    final q3Answer = event.answer3.isEmpty ? state.q2Answer : event.answer3;
    emit(state.copyWith(
      q3Answer: q3Answer,
      q4Answer: '',
    ));
  }

  void updateQ4Answer(UpdateQ4Answer event, Emitter emit) {
    final q4Answer = event.answer4.isEmpty ? state.q3Answer : event.answer4;
    emit(state.copyWith(q4Answer: q4Answer, q5Answer: ''));
  }

  void updateQ5Answer(UpdateQ5Answer event, Emitter emit) {
    final q5Answer = event.answer5.isEmpty ? state.q4Answer : event.answer5;
    emit(state.copyWith(q5Answer: q5Answer, title: q5Answer));
  }

  void clearFields(ClearFields event, Emitter emit) {
    emit(AddGoalState.idle());
  }
}
