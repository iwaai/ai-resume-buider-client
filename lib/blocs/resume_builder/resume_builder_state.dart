import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:second_shot/models/resume_data_model.dart';
import 'package:second_shot/models/resume_template.dart';

abstract class ResumeState extends Equatable {
  const ResumeState();

  @override
  List<Object?> get props => [];
}

class ResumeInitial extends ResumeState {}

class ResumeLoading extends ResumeState {}

class ImageCaptured extends ResumeState {
  final File imageFile;

  const ImageCaptured({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class ResumeDataExtracted extends ResumeState {
  final File imageFile;
  final ResumeData resumeData;

  const ResumeDataExtracted({
    required this.imageFile,
    required this.resumeData,
  });

  @override
  List<Object> get props => [imageFile, resumeData];
}

class PDFGenerated extends ResumeState {
  final File imageFile;
  final ResumeData resumeData;
  final File pdfFile;
  final ResumeTemplate? template;

  const PDFGenerated({
    required this.imageFile,
    required this.resumeData,
    required this.pdfFile,
    this.template,
  });

  @override
  List<Object> get props => [imageFile, resumeData, pdfFile, template ?? Object()];
}

class ResumeError extends ResumeState {
  final String message;

  const ResumeError({required this.message});

  @override
  List<Object> get props => [message];
}
