import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/services/local_storage.dart';

import '../../utils/constants/result.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final localStorage = LocalStorage();

  HomeBloc() : super(HomeState()) {
    on<OnInitHome>((event, emit) => _onInit(emit));
    on<Unlock>((event, emit) => _onUnlock(event, emit));
  }

  void _onInit(Emitter emit) {
    List<String> temp = [];
    if (localStorage.isDialogShown(AppRoutes.transferableSkills)) {
      temp.add(AppRoutes.transferableSkills);
    }
    if (localStorage.isDialogShown(AppRoutes.careerRecommendations)) {
      temp.add(AppRoutes.careerRecommendations);
    }
    if (localStorage.isDialogShown(AppRoutes.resumeBuilder)) {
      temp.add(AppRoutes.resumeBuilder);
    }
    if (localStorage.isDialogShown(AppRoutes.goalSettings)) {
      temp.add(AppRoutes.goalSettings);
    }
    if (localStorage.isDialogShown(AppRoutes.successStories)) {
      temp.add(AppRoutes.successStories);
    }
    if (localStorage.isDialogShown(AppRoutes.myLibrary)) {
      temp.add(AppRoutes.myLibrary);
    }
    emit(state.copyWith(dialogShown: temp));
  }

  void _onUnlock(Unlock event, Emitter emit) {
    List<String> temp = state.dialogShown;

    if (!temp.contains(event.screen)) {
      temp.add(event.screen);
    }
    emit(state.copyWith(dialogShown: temp));
  }
}
