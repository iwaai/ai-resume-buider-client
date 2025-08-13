part of 'take_assessment_bloc.dart';

class TakeAssessmentState {
  final int step;
  final Map<String, dynamic> answers;
  final Result result;

  final List<CareerRecommQuestion> careerRecommendationQuestions;
  final bool loading;

  TakeAssessmentState(
      {required this.step,
      required this.answers,
      required this.result,
      this.loading = false,
      this.careerRecommendationQuestions = const []});

  TakeAssessmentState copyWith(
      {int? step,
      Map<String, dynamic>? answers,
      Result? result,
      bool? loading,
      List<CareerRecommQuestion>? careerRecommendationQuestions}) {
    return TakeAssessmentState(
      step: step ?? this.step,
      answers: answers ?? this.answers,
      loading: loading ?? this.loading,
      careerRecommendationQuestions:
          careerRecommendationQuestions ?? this.careerRecommendationQuestions,
      result: result ?? Result.idle(),
    );
  }

  factory TakeAssessmentState.idle() =>
      TakeAssessmentState(step: 1, answers: {}, result: Result.idle());
}
