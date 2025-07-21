part of 'my_library_bloc.dart';

sealed class MyLibraryEvent {}

class GetDataEvent extends MyLibraryEvent {}

class GetCareerLikesEvent extends MyLibraryEvent {}

class LibraryToggleLikeEvent extends MyLibraryEvent {
  final String nodeId;
  final String descriptionId;
  final ShowNode nodeName;

  LibraryToggleLikeEvent(
      {required this.nodeId,
      required this.descriptionId,
      required this.nodeName});
}

class GetFormQuestions extends MyLibraryEvent {}

class AwardStepIncrementEvent extends MyLibraryEvent {
  final bool isSkip;

  AwardStepIncrementEvent({this.isSkip = false});
}

class AwardStepReset extends MyLibraryEvent {
  final int? step;

  AwardStepReset({this.step});
}

class UpdateAwardFormEvent extends MyLibraryEvent {
  final AwardQuestionModel model;
  final bool isListAnswer;

  UpdateAwardFormEvent({
    required this.model,
    required this.isListAnswer,
  });
}

class FillFormEvent extends MyLibraryEvent {
  final List<AwardQuestionModel> models;

  FillFormEvent({required this.models});
}

class GetAwardsEvent extends MyLibraryEvent {}

class SendAwardReportToEmailEvent extends MyLibraryEvent {
  final File awardReport;

  SendAwardReportToEmailEvent({required this.awardReport});
}

class ShareIDPReportEvent extends MyLibraryEvent {
  final File report;
  final List<SupportPerson> supportPeople;

  ShareIDPReportEvent({
    required this.report,
    required this.supportPeople,
  });
}
