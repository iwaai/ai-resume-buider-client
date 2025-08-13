import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:second_shot/data/repos/goal_repo.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc() : super(GoalsState.idle()) {
    on<GetGoalsData>((event, emit) => _getGoalData(event, emit));
    on<AddNewGoalEvent>((event, emit) => _addNewGoalAfterSuccess(event, emit));
    on<GoalDetailEvent>((event, emit) => _goalDetail(event, emit));
    // on<SupportPeopleEvent>((event, emit) => _addSupportPeople(event, emit));
    on<DeleteGoalEvent>((event, emit) => _deleteGoal(event, emit));
    on<UpdateSubGoalStatus>((event, emit) => _updateSubGoalStatus(event, emit));
    on<EditSupportPeopleEvent>(
        (event, emit) => _editSupportPeople(event, emit));
    on<UpdateMainGoalStatus>(
        (event, emit) => _updateMainGoalStatus(event, emit));
    on<SearchGoalsEvent>((event, emit) => _searchGoal(event, emit));
  }

  final goalRepo = GoalRepo();

  void _getGoalData(GetGoalsData event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));

    await goalRepo.getGoals(onSuccess: (data) {
      List<CreateGoalModel> goal = (data.data as List)
          .map((item) => CreateGoalModel.fromJson(item))
          .toList();

      emit(
        state.copyWith(
            result: Result.successful('', event),
            loading: false,
            goalsList: goal),
      );

      debugPrint(
          "Goal list updated: $goal"); // ✅ Check if the list is populated
    }, onFailure: (String e) {
      debugPrint("API Failure: $e"); // ✅ Check if API fails
      emit(
        state.copyWith(result: Result.error(e, event), loading: false),
      );
    });
  }

  void _addNewGoalAfterSuccess(AddNewGoalEvent event, Emitter emit) {
    emit(state.copyWith(
        goalsList: state.goalsList..insert(0, event.createGoalModel),
        goal: event.createGoalModel));
  }

  void _goalDetail(GoalDetailEvent event, Emitter emit) async {
    emit(state.copyWith(
      result: Result.idle(),
      loading: true,
    ));
    await goalRepo.goalDetails(
        onSuccess: (goalData) {
          log("Goal Data ${goalData.toJson()}");
          emit(
            state.copyWith(
              result: Result.successful('', event),
              loading: false,
              goalDtail: goalData,
            ),
          );
          debugPrint("goal data is ${state.goalDtail}");
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event)),
          );
        },
        goalId: event.goalId);
  }

  // void _addSupportPeople(SupportPeopleEvent event, Emitter emit) async {
  //   debugPrint("Add Suport prople");
  //   emit(
  //     state.copyWith(result: Result.idle(), loading: true),
  //   );
  //   await goalRepo.addSuppportPeople(onSuccess: (res) {
  //     emit(state.copyWith(
  //         loading: false, result: Result.successful(res, event)));
  //   },
  //       // supportPeople: event.supportPeople,
  //       onFailure: (e) {
  //     emit(state.copyWith(result: Result.error(e, event), loading: false));
  //   });
  // }

  void _deleteGoal(DeleteGoalEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await goalRepo.deleteGoal(
        onSuccess: (res) {
          emit(
            state.copyWith(
                loading: false, result: Result.successful(res, event)),
          );
        },
        onFailure: (error) {
          emit(
            state.copyWith(loading: false, result: Result.error(error, event)),
          );
        },
        goalId: state.goalDtail?.goalId.toString() ?? '');
  }

  void _updateSubGoalStatus(UpdateSubGoalStatus event, Emitter emit) async {
    List<CreateGoalModel> temp = [...state.goalsList];
    List<CreateGoalModel> temp2 = [...state.goalsList];
    List<SubGoals> temp3 = [...?state.goalDtail?.subGoals];

    List<SubGoals> temp4 = [...?state.goalDtail?.subGoals];
    final index =
        temp.indexWhere((goal) => goal.goalId == state.goalDtail?.goalId);
    temp[index] = temp[index].copyWith(
      status: state.goalsList[index].status == Constant.completed
          ? Constant.completed
          : Constant.inProgress,
    );

    String? tempr = state.goalDtail?.subGoalStatus.toString();

    // Check if any subgoal is incomplete
    bool hasIncompleteSubGoals = temp3.any((goal) => goal.isCompleted == false);

    emit(state.copyWith(
      goalsList: temp,
      goalDtail: state.goalDtail?.copyWith(
        status: temp[index].status,
        subGoalStatus:
            hasIncompleteSubGoals ? Constant.inProgress : Constant.completed,
      ),
      result: Result.idle(),
    ));

    await goalRepo.updateSubGoalStatus(
        onSuccess: () {
          emit(
            state.copyWith(
              result: Result.successful('', event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(
              result: Result.error(e, event),
              loading: false,
              goalsList: temp2,
              goalDtail: state.goalDtail?.copyWith(
                  subGoals: temp4,
                  status: temp2[index].status,
                  subGoalStatus: tempr),
            ),
          );
        },
        body: {
          'goalId': state.goalDtail?.goalId ?? '',
          'subGoalId': event.subGoalId
        });
  }

  void _updateMainGoalStatus(UpdateMainGoalStatus event, Emitter emit) async {
    List<CreateGoalModel> temp = [...state.goalsList];
    List<CreateGoalModel> temp2 = [...state.goalsList];
    final index = temp.indexWhere((e) => e.goalId == state.goalDtail?.goalId);

    temp[index] = temp[index].copyWith(status: Constant.completed);

    emit(
      state.copyWith(
        goalsList: temp,
        result: Result.idle(),
        goalDtail: state.goalDtail?.copyWith(status: Constant.completed),
      ),
    );
    await goalRepo.updateMainGoalStatus(
        onSuccess: () {
          emit(state.copyWith(result: Result.successful('', event)));
        },
        onFailure: (error) {
          emit(
            state.copyWith(
              goalsList: temp2,
              result: Result.error(error, event),
              goalDtail:
                  state.goalDtail?.copyWith(status: Constant.notStartedYet),
            ),
          );
        },
        goalId: state.goalDtail?.goalId.toString() ?? '');
  }

  Future<void> _editSupportPeople(
      EditSupportPeopleEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    final temp = state.goalDtail?.supportPeople ?? [];
    if (state.goalDtail!.supportPeople!.length < 2) {
      emit(
        state.copyWith(
          goalDtail: state.goalDtail!.copyWith(
            supportPeople: event.supPeople,
          ),
        ),
      );
      await goalRepo.editSupportPeople(
        onSuccess: (res) {
          emit(state.copyWith(
              loading: false, result: Result.successful(res, event)));
        },
        onError: (error) {
          emit(state.copyWith(
              goalDtail: state.goalDtail!.copyWith(
                supportPeople: temp,
              ),
              loading: false,
              result: Result.error(error, event)));
        },
        goalId: state.goalDtail?.goalId.toString() ?? '',
        supportPeople: event.supPeople,
      );
    }
  }

  void _searchGoal(SearchGoalsEvent event, Emitter<GoalsState> emit) {
    final query = event.query.trim().toLowerCase();
    emit(state.copyWith(query: query));

    if (query.isEmpty) {
      emit(state.copyWith(filterGoalList: []));
    } else {
      final filteredGoals = state.goalsList
          .where((goal) => goal.mainGoalName.toLowerCase().contains(query))
          .toList();
      emit(state.copyWith(filterGoalList: filteredGoals));
    }
  }
}
