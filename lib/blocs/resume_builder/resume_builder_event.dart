import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:second_shot/models/resume_template.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object> get props => [];
}

class CaptureImageEvent extends ResumeEvent {}

class ProcessImageEvent extends ResumeEvent {
  final File imageFile;

  const ProcessImageEvent({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class GeneratePDFEvent extends ResumeEvent {}


class GenerateTemplatedPDFEvent extends ResumeEvent {
  final ResumeTemplate template;

  const GenerateTemplatedPDFEvent({required this.template});

  @override
  List<Object> get props => [template];
}

class ResetEvent extends ResumeEvent {}