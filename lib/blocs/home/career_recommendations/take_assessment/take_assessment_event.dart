part of 'take_assessment_bloc.dart';

sealed class TakeAssessmentEvent {}

class NextStep extends TakeAssessmentEvent {}

class PreviousStep extends TakeAssessmentEvent {}

class Reset extends TakeAssessmentEvent {}

class Save extends TakeAssessmentEvent {}

class SetAnswer<T> extends TakeAssessmentEvent {
  final String question;
  final T value;

  SetAnswer(this.question, this.value);
}

class RemoveAnswer<T> extends TakeAssessmentEvent {
  final String question;
  final T value;

  RemoveAnswer(this.question, this.value);
}

class GetCareerRecommendationQuestions extends TakeAssessmentEvent {}
