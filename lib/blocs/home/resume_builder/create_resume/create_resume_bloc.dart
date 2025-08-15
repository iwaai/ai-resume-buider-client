import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:second_shot/blocs/home/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/models/get_resume_model.dart';

import '../../../../data/repos/resume_repo.dart';
import '../../../../utils/constants/result.dart';

part 'create_resume_event.dart';
part 'create_resume_state.dart';

class CreateResumeBloc extends Bloc<CreateResumeClassEvent, CreateResumeState> {
  final repo = ResumeRepo();
  final ResumeBuilderBloc? resumeBuilderBloc;
  ResumeModel? updatedModel;

  CreateResumeBloc({this.resumeBuilderBloc}) : super(CreateResumeState.idle()) {
    on<StepIncrement>((event, emit) {
      if (state.step < 8) {
        emit(state.copyWith(step: state.step + 1));
      }
    });
    on<StepDecrement>((event, emit) {
      if (state.step > 1) {
        emit(state.copyWith(step: state.step - 1));
      }
    });
    on<UpdateResumeDataEvent>(_updateResumeDataEvent);
    on<FillDataForEditEvent>(_fillDataForEditEvent);
    on<AddAFieldEvent>(_addMore);
    on<RemoveAFieldEvent>(_removeAFieldEvent);
  }

  void _updateResumeDataEvent(UpdateResumeDataEvent event, Emitter emit) {
    ResumeModel? updateResumeModel = event.createResumeModel;
    emit(state.copyWith(createResumeModel: updateResumeModel));
    // print(
    //     "state.createResumeModel.experience!.first.isChecked${state.createResumeModel.experience!.first.isChecked}");
    log('Updated Model:: ${state.createResumeModel.toJsonCreateResume()}');
  }

  void _fillDataForEditEvent(FillDataForEditEvent event, Emitter emit) {
    print('Fill Data Start');
    if (event.model!.isNull) return;
    final mdl = event.model?.copyWith(isEdit: true);
    emit(
      state.copyWith(
        createResumeModel: mdl,
      ),
    );
    log('Filling Edit Data:::: ${state.createResumeModel.toJsonCreateResume()}');
  }

  void _addMore(AddAFieldEvent event, Emitter emit) {
    switch (state.step) {
      case 3:
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel.copyWith(
              education: (state.createResumeModel.education ?? []) +
                  [const Education(institution: "")],
            ),
          ),
        );
        break;
      case 4:
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel.copyWith(
              licensesAndCertifications:
                  (state.createResumeModel.licensesAndCertifications ?? []) +
                      [const LicensesAndCertification(certificationName: "")],
            ),
          ),
        );

        break;
      case 6:
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel.copyWith(
              experience: (state.createResumeModel.experience ?? []) +
                  [const Experience(jobTitle: "")],
            ),
          ),
        );
        break;
      case 7:
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel.copyWith(
              volunteerExperience:
                  (state.createResumeModel.volunteerExperience ?? []) +
                      [const VolunteerExperience(organizationName: "")],
            ),
          ),
        );
        break;
      case 8:
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel.copyWith(
              honorsAndAwards: (state.createResumeModel.honorsAndAwards ?? []) +
                  [const HonorsAndAward(awardName: "")],
            ),
          ),
        );
        break;
    }
  }

  void _removeAFieldEvent(RemoveAFieldEvent event, Emitter emit) {
    switch (state.step) {
      case 3:
        CreateResumeState _state = state;
        final list = state.createResumeModel.education?..removeAt(event.index);
        _state = state.copyWith(
          result: Result.successful('', event),
          createResumeModel: state.createResumeModel.copyWith(
            education: list,
          ),
        );
        emit(_state);
        break;
      case 4:
        final list = state.createResumeModel.licensesAndCertifications
          ?..removeAt(event.index);
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel: state.createResumeModel
                .copyWith(licensesAndCertifications: list),
          ),
        );
        break;
      case 6:
        final list = state.createResumeModel.experience?..removeAt(event.index);
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel:
                state.createResumeModel.copyWith(experience: list),
          ),
        );
        break;
      case 7:
        final list = state.createResumeModel.volunteerExperience
          ?..removeAt(event.index);
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel:
                state.createResumeModel.copyWith(volunteerExperience: list),
          ),
        );
        break;
      case 8:
        final list = state.createResumeModel.honorsAndAwards
          ?..removeAt(event.index);
        emit(
          state.copyWith(
            result: Result.successful('', event),
            createResumeModel:
                state.createResumeModel.copyWith(honorsAndAwards: list),
          ),
        );
        break;
      default:
    }
  }
}
