import 'dart:io';
import 'package:equatable/equatable.dart';

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

class ResetEvent extends ResumeEvent {}
