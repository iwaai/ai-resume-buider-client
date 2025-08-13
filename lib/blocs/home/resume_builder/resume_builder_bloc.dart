import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/resume_repo.dart';
import 'package:second_shot/models/get_resume_model.dart';

import '../../../models/add_support_people_model.dart';
import '../../../utils/constants/result.dart';
import '../my_library/my_library_bloc.dart';

part 'resume_builder_event.dart';
part 'resume_builder_state.dart';

class ResumeBuilderBloc extends Bloc<ResumeBuilderEvent, ResumeBuilderState> {
  final repo = ResumeRepo();
  final MyLibraryBloc? libraryBloc;

  ResumeBuilderBloc({this.libraryBloc}) : super(ResumeBuilderState.idle()) {
    on<GetMyResumeEvent>((event, emit) => _getMyResume(event, emit));
    on<DeleteResumeEvent>((event, emit) => _deleteResume(event, emit));
    on<SelectAResume>((event, emit) => _selectAResume(event, emit));
    on<CreateResumeEvent>((event, emit) => _createResumeEvent(event, emit));
    on<EditResumeEvent>((event, emit) => _editResume(event, emit));
    on<SendToEmailEvent>((event, emit) => _sendToEmail(event, emit));
    on<SendToSupportPeopleEvent>(
        (event, emit) => _sentToSupportPeopleEvent(event, emit));
  }

  Future<void> _editResume(EditResumeEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.editResume(
        onFailure: (String message) {
          emit(state.copyWith(
              result: Result.error(message, event), loading: false));
        },
        onSuccess: (ResumeModel resumeModel) {
          add(GetMyResumeEvent());
          emit(state.copyWith(
              result: Result.successful('', event),
              loading: false,
              model: resumeModel));
        },
        model: event.model);
  }

  Future<void> _createResumeEvent(CreateResumeEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.createResume(
        onFailure: (String message) {
          emit(state.copyWith(
              result: Result.error(message, event), loading: false));
        },
        onSuccess: (ResumeModel resumeModel) {
          add(GetMyResumeEvent());
          emit(state.copyWith(
              result: Result.successful('', event),
              loading: false,
              model: resumeModel));
        },
        model: event.model);
  }

  void _selectAResume(SelectAResume event, Emitter emit) {
    ResumeModel model = event.model;
    if (event.model.education != null && event.model.education!.isEmpty) {
      model.education?.add(const Education(institution: ''));
    }
    if (event.model.licensesAndCertifications != null &&
        event.model.licensesAndCertifications!.isEmpty) {
      model.licensesAndCertifications
          ?.add(const LicensesAndCertification(certificationName: ''));
    }
    emit(state.copyWith(model: model));
  }

  Future<void> _getMyResume(GetMyResumeEvent event, Emitter emit) async {
    print('GETTING RESUME DATA');
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.getMyResumes(onFailure: (String message) {
      emit(
          state.copyWith(loading: false, result: Result.error(message, event)));
    }, onSuccess: (List<ResumeModel> models) {
      emit(state.copyWith(
          models: models,
          loading: false,
          result: Result.successful('', event)));
    });
  }

  Future<void> _deleteResume(DeleteResumeEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.deleteResume(
        onFailure: (String message) {
          emit(state.copyWith(
              loading: false, result: Result.error(message, event)));
        },
        onSuccess: () {
          final updatedModel = state.models
            ..removeWhere((i) {
              return i.id == event.id;
            });
          emit(state.copyWith(
              models: updatedModel,
              loading: false,
              result: Result.successful('', event)));
        },
        id: event.id);
  }

  Future<void> _sendToEmail(SendToEmailEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.sendToEmail(
        onFailure: (String message) {
          emit(state.copyWith(
              loading: false, result: Result.error(message, event)));
        },
        onSuccess: () {
          emit(state.copyWith(
              loading: false, result: Result.successful('', event)));
        },
        resume: event.resume);
  }

  Future<void> _sentToSupportPeopleEvent(
      SendToSupportPeopleEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.sendToSupportPeople(
      onFailure: (String message) {
        emit(state.copyWith(
            loading: false, result: Result.error(message, event)));
      },
      onSuccess: () {
        emit(state.copyWith(
            loading: false, result: Result.successful('', event)));
      },
      model: event.model,
    );
  }
}
