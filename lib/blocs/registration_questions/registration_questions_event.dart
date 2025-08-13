// registration_event.dart
part of 'registration_questions_bloc.dart';

abstract class RegistrationQuestionsEvent {}

class UpdateQ1EducationEvent extends RegistrationQuestionsEvent {
  final String? education;

  UpdateQ1EducationEvent(this.education);
}

class UpdateQ1ExpertiseEvent extends RegistrationQuestionsEvent {
  final String? expertise;

  UpdateQ1ExpertiseEvent(this.expertise);
}

class SearchEducationEvent extends RegistrationQuestionsEvent {
  final String? query;

  SearchEducationEvent(this.query);
}

class ResetExpertiseListEvent extends RegistrationQuestionsEvent {
  ResetExpertiseListEvent();
}

class UpdateQ2AnswerEvent extends RegistrationQuestionsEvent {
  final String answer;

  UpdateQ2AnswerEvent(this.answer);
}

class UpdateQ3AnswerEvent extends RegistrationQuestionsEvent {
  final bool answer;

  UpdateQ3AnswerEvent(this.answer);
}

class UpdateQ4AnswerEvent extends RegistrationQuestionsEvent {
  final bool answer;

  UpdateQ4AnswerEvent(this.answer);
}

class UpdateQ4BranchAnswerEvent extends RegistrationQuestionsEvent {
  final ForceService? branch;

  UpdateQ4BranchAnswerEvent(this.branch);
}

class UpdateQ4RankEvent extends RegistrationQuestionsEvent {
  final ForceRanks? rank;

  UpdateQ4RankEvent(this.rank);
}

class SearchRankEvent extends RegistrationQuestionsEvent {
  final String? query;

  SearchRankEvent(this.query);
}

class ResetRankListEvent extends RegistrationQuestionsEvent {}

class UpdateQ5AnswerEvent extends RegistrationQuestionsEvent {
  final bool answer;

  UpdateQ5AnswerEvent(this.answer);
}

class UpdateQ5SportEvent extends RegistrationQuestionsEvent {
  final SportsModel sport;

  UpdateQ5SportEvent(this.sport);
}

class UpdateQ5PositionEvent extends RegistrationQuestionsEvent {
  final SportsPositionsModel? position;

  UpdateQ5PositionEvent(this.position);
}

class UpdateQ6HobbyEvent extends RegistrationQuestionsEvent {
  final HobbyModel? hobby;

  UpdateQ6HobbyEvent(this.hobby);
}

class ResetHobbiesEvent extends RegistrationQuestionsEvent {}

class SearchHobbiesEvent extends RegistrationQuestionsEvent {
  final String? query;

  SearchHobbiesEvent(this.query);
}

class UpdateQ7HobbyEvent extends RegistrationQuestionsEvent {
  final HobbyModel? hobby;

  UpdateQ7HobbyEvent(this.hobby);
}

class ResetSecondHobbiesEvent extends RegistrationQuestionsEvent {}

class UpdateQ8SubjectEvent extends RegistrationQuestionsEvent {
  final SubjectModel? subject;

  UpdateQ8SubjectEvent(this.subject);
}

class UpdateQ9AnswerEvent extends RegistrationQuestionsEvent {
  final bool answer;

  UpdateQ9AnswerEvent(this.answer);
}

class UpdateQ9JobTitleEvent extends RegistrationQuestionsEvent {
  final String? jobTitle;

  UpdateQ9JobTitleEvent(this.jobTitle);
}

class UpdateQ10CareerEvent extends RegistrationQuestionsEvent {
  final String? career;

  UpdateQ10CareerEvent(this.career);
}

class NextStepEvent extends RegistrationQuestionsEvent {}

class PreviousStepEvent extends RegistrationQuestionsEvent {}

class ResetStepsEvent extends RegistrationQuestionsEvent {}

class UpdateAnswersForEditEvent extends RegistrationQuestionsEvent {}

class SubmitEvent extends RegistrationQuestionsEvent {}

class GetRegistrationQuestionsDataEvent extends RegistrationQuestionsEvent {}

class EmptyFormEvent extends RegistrationQuestionsEvent {}

class GetRegistrationDataEvent extends RegistrationQuestionsEvent {}
