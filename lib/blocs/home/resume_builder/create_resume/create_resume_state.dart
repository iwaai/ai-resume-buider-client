part of 'create_resume_bloc.dart';

final class CreateResumeState {
  final Result? result;
  final bool? loading;
  final int step;
  ResumeModel createResumeModel;
  ResumeModel? updatedModel;

  CreateResumeState({
    required this.createResumeModel,
    this.updatedModel,
    required this.step,
    this.result,
    this.loading,
  });

  CreateResumeState copyWith({
    Result? result,
    bool? loading,
    int? step,
    ResumeModel? createResumeModel,
    ResumeModel? updatedModel,
  }) {
    return CreateResumeState(
      result: result,
      loading: loading ?? this.loading,
      step: step ?? this.step,
      createResumeModel: createResumeModel ?? this.createResumeModel,
      updatedModel: updatedModel ?? this.updatedModel,
    );
  }

  factory CreateResumeState.idle() {
    return CreateResumeState(
      result: null,
      loading: false,
      step: 1,
      createResumeModel: ResumeModel.initial(),
      updatedModel: ResumeModel(),
    );
  }
}
