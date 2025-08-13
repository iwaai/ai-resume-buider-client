part of 'my_library_bloc.dart';

class MyLibraryState {
  final Result result;
  final bool loading;
  final List<LibraryModel> models;
  final List<AwardQuestionModel> awardQuestionModels;
  final List<String> awards;
  int awardStep;
  final double awardImageOpacity;
  final bool buttonLoader;
  final List<AwardAnswerModel> awardAnswerModels;

  MyLibraryState({
    required this.models,
    required this.result,
    required this.loading,
    required this.awards,
    required this.awardQuestionModels,
    required this.awardStep,
    required this.awardImageOpacity,
    required this.buttonLoader,
    required this.awardAnswerModels,
  });

  MyLibraryState copyWith({
    Result? result,
    bool? loading,
    List<LibraryModel>? models,
    List<String>? awards,
    int? awardStep,
    bool? buttonLoader,
    double? awardImageOpacity,
    List<AwardQuestionModel>? awardQuestionModels,
    List<AwardAnswerModel>? awardAnswerModels,
  }) {
    return MyLibraryState(
      models: models ?? this.models,
      result: result ?? this.result,
      loading: loading ?? this.loading,
      awards: awards ?? this.awards,
      awardQuestionModels: awardQuestionModels ?? this.awardQuestionModels,
      awardStep: awardStep ?? this.awardStep,
      awardImageOpacity: awardImageOpacity ?? this.awardImageOpacity,
      buttonLoader: buttonLoader ?? this.buttonLoader,
      awardAnswerModels: awardAnswerModels ?? this.awardAnswerModels,
    );
  }

  factory MyLibraryState.idle() {
    return MyLibraryState(
        awardAnswerModels: [],
        buttonLoader: false,
        awardStep: 1,
        awardImageOpacity: 0.20,
        result: Result.idle(),
        loading: false,
        models: <LibraryModel>[],
        awards: [],
        awardQuestionModels: []);
  }
}
