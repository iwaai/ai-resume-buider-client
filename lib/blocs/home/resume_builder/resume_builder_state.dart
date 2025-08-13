part of 'resume_builder_bloc.dart';

class ResumeBuilderState {
  final Result result;
  final bool loading;
  final List<ResumeModel> models;
  final ResumeModel? model;

  const ResumeBuilderState({
    required this.result,
    required this.loading,
    required this.models,
    this.model,
  });

  ResumeBuilderState copyWith(
      {Result? result,
      bool? loading,
      List<ResumeModel>? models,
      ResumeModel? model}) {
    return ResumeBuilderState(
      result: result ?? Result.idle(),
      loading: loading ?? this.loading,
      models: models ?? this.models,
      model: model ?? this.model,
    );
  }

  factory ResumeBuilderState.idle() {
    return ResumeBuilderState(
        model: null, loading: false, result: Result.idle(), models: []);
  }
}
