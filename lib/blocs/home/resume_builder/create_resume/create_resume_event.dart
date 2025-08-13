part of 'create_resume_bloc.dart';

abstract class CreateResumeClassEvent {}

class StepIncrement extends CreateResumeClassEvent {}

class StepDecrement extends CreateResumeClassEvent {}

class FillDataForEditEvent extends CreateResumeClassEvent {
  final ResumeModel? model;

  FillDataForEditEvent({this.model});
}

class UpdateResumeDataEvent extends CreateResumeClassEvent {
  final ResumeModel? createResumeModel;

  UpdateResumeDataEvent({required this.createResumeModel});
}

class EditFieldEvent extends CreateResumeClassEvent {
  final int i;
  final ResumeModel? updatedModel;

  EditFieldEvent({required this.i, required this.updatedModel});
}

class AddAFieldEvent extends CreateResumeClassEvent {}

class RemoveAFieldEvent extends CreateResumeClassEvent {
  final int index;

  RemoveAFieldEvent({required this.index});
}
