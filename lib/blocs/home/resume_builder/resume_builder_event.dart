part of 'resume_builder_bloc.dart';

abstract class ResumeBuilderEvent {}

class GetMyResumeEvent extends ResumeBuilderEvent {}

class DeleteResumeEvent extends ResumeBuilderEvent {
  final String id;

  DeleteResumeEvent({required this.id});
}

class SelectAResume extends ResumeBuilderEvent {
  final ResumeModel model;

  SelectAResume({required this.model});
}

class CreateResumeEvent extends ResumeBuilderEvent {
  final ResumeModel model;

  CreateResumeEvent({required this.model});
}

class EditResumeEvent extends ResumeBuilderEvent {
  final ResumeModel model;

  EditResumeEvent({required this.model});
}

class SendToEmailEvent extends ResumeBuilderEvent {
  final File resume;

  SendToEmailEvent({required this.resume});
}

class SendToSupportPeopleEvent extends ResumeBuilderEvent {
  final AddSupportPeopleModel model;

  SendToSupportPeopleEvent({
    required this.model,
  });
}
