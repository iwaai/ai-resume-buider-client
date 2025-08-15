import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/transferable_skills/transferable_skills_bloc.dart';
import 'package:second_shot/data/repos/career_recomm_repo.dart';
import 'package:second_shot/data/repos/my_library_repo.dart';
import 'package:second_shot/data/repos/transferable_skills_repo.dart';
import 'package:second_shot/models/AwardQuestionModel.dart';
import 'package:second_shot/models/add_support_people_model.dart';
import 'package:second_shot/models/library_model.dart';

import '../../../models/AwardAnswerModel.dart';
import '../../../utils/constants/result.dart';
import '../resume_builder/resume_builder_bloc.dart';

part 'my_library_event.dart';
part 'my_library_state.dart';

class MyLibraryBloc extends Bloc<MyLibraryEvent, MyLibraryState> {
  final CareerRecommendationsBloc careerRecommendationsBloc;
  final TransferableSkillsBloc tSkillBloc;
  final ResumeBuilderBloc resumeBloc;
  final libraryRepo = MyLibraryRepo();
  final tSkillRepo = TransferableSkillsRepo();
  final careerRepo = CareerRecommRepo();

  MyLibraryBloc({
    required this.careerRecommendationsBloc,
    required this.tSkillBloc,
    required this.resumeBloc,
  }) : super(MyLibraryState.idle()) {
    on<GetDataEvent>(getData);
    on<LibraryToggleLikeEvent>(toggleLike);
    on<GetFormQuestions>(_getFormQuestions);
    on<AwardStepIncrementEvent>(_awardStepIncrement);
    on<AwardStepReset>(_awardStepReset);
    on<UpdateAwardFormEvent>(_updateAwardForm);
    on<FillFormEvent>(_fillForm);
    on<GetAwardsEvent>(_getAwards);
    on<SendAwardReportToEmailEvent>(_sendAwardReportToEmail);
    on<ShareIDPReportEvent>(_shareIdpReport);
  }

  Future<void> _shareIdpReport(ShareIDPReportEvent event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await libraryRepo.shareIdpReport(
        onSuccess: () {
          emit(state.copyWith(
              result: Result.successful('', event), loading: false));
        },
        onFailure: (String message) {
          emit(state.copyWith(
              result: Result.error(message, event), loading: false));
        },
        report: event.report,
        supportPeople: event.supportPeople);
  }

  Future<void> _sendAwardReportToEmail(
      SendAwardReportToEmailEvent event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle()));
    await libraryRepo.sendAwardReportToEmail(
        awardReport: event.awardReport,
        onSuccess: () {
          emit(state.copyWith(result: Result.successful('', event)));
        },
        onFailure: (String message) {
          emit(state.copyWith(result: Result.error(message, event)));
        });
  }

  Future<void> _getAwards(GetAwardsEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await libraryRepo.getAwards(
      onSuccess: (List<AwardAnswerModel> answerModels) {
        emit(state.copyWith(
            loading: false,
            result: Result.successful('', event),
            awardAnswerModels: answerModels));
      },
      onFailure: (String message) {
        emit(state.copyWith(
            loading: false, result: Result.error(message, event)));
      },
    );
  }

  void _fillForm(FillFormEvent event, Emitter emit) {
    final models = event.models;
    emit(state.copyWith(awardQuestionModels: models));
  }

  Future<void> _updateAwardForm(
      UpdateAwardFormEvent event, Emitter emit) async {
    AwardQuestionModel model = event.model;
    // model = model.copyWith(listAnswer: null);
    emit(state.copyWith(buttonLoader: true, result: Result.idle()));
    await libraryRepo.updateAwardForm(
        isListAnswer: event.isListAnswer,
        onSuccess: () {
          emit(state.copyWith(
              result: Result.successful('', event), buttonLoader: false));
        },
        onFailure: (String message) {
          emit(state.copyWith(
              buttonLoader: false, result: Result.error(message, event)));
        },
        model: model);
  }

  void _awardStepReset(AwardStepReset event, Emitter emit) {
    if (event.step != null) {
      emit(state.copyWith(awardStep: event.step));
    } else {
      emit(state.copyWith(awardStep: 1));
    }
  }

  Future<void> _awardStepIncrement(
      AwardStepIncrementEvent event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle()));
    if (event.isSkip == true) {
      emit(state.copyWith(
          awardStep: state.awardStep + 1,
          result: Result.successful('', event)));
      return;
    }
    emit(state.copyWith(awardImageOpacity: 1.0));
    await Future.delayed(const Duration(seconds: 1)).then((_) {
      emit(state.copyWith(
          awardStep: state.awardStep + 1, awardImageOpacity: 0.20));
    });
  }

  Future<void> _getFormQuestions(GetFormQuestions event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await libraryRepo.getFormQuestions(
        onSuccess: (List<AwardQuestionModel> models) {
      emit(state.copyWith(
          awardQuestionModels: models,
          loading: false,
          result: Result.successful('', event)));
    }, onFailure: (String message) {
      emit(state.copyWith(
          awardQuestionModels: [],
          loading: false,
          result: Result.error(message, event)));
    });
  }

  Future<void> getData(GetDataEvent event, Emitter emit) async {
    emit(state.copyWith(
      result: Result.idle(),
      loading: true,
    ));
    await libraryRepo.getSkillsLikes(onSuccess: (List<LibraryModel> models) {
      emit(state.copyWith(
        models: models,
        result: Result.successful('', event),
        // loading: false,
      ));
    }, onFailure: (String message) {
      print('Hit Failure');

      emit(state.copyWith(
        loading: false,
        result: Result.error(message, event),
      ));
    });

    emit(state.copyWith(
      result: Result.idle(),
      loading: false,
    ));
  }

  Future<void> toggleLike(LibraryToggleLikeEvent event, Emitter emit) async {
    final updatedModels = state.models.where((model) {
      final libraryItem = model.getLibraryModel;
      return !(libraryItem?.nodeId == event.nodeId &&
          libraryItem?.descriptionId == event.descriptionId &&
          libraryItem?.nodeName == event.nodeName);
    }).toList();

    emit(state.copyWith(
      result: Result.idle(),
      loading: false,
      models: updatedModels,
    ));
    await tSkillRepo.removeFromLibrary(
      onSuccess: () {
        emit(state.copyWith(
          result: Result.successful('', event),
          loading: false,
          models: updatedModels,
        ));
      },
      onFailure: (String message) {
        emit(state.copyWith(
          loading: false,
          result: Result.error(message, event),
        ));
      },
      nodeId: event.nodeId,
      descriptionId: event.descriptionId,
      nodeName: event.nodeName,
    );
  }
}
