import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_event.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_state.dart';
import 'package:second_shot/services/gemini_service.dart';
import 'package:second_shot/services/pdf_service.dart';
import 'package:second_shot/services/template_factory.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final GeminiService _geminiService;
  final PDFService _pdfService;
  final ImagePicker _imagePicker;

  ResumeBloc({
    required GeminiService geminiService,
    required PDFService pdfService,
  })  : _geminiService = geminiService,
        _pdfService = pdfService,
        _imagePicker = ImagePicker(),
        super(ResumeInitial()) {
    on<CaptureImageEvent>(_onCaptureImage);
    on<ProcessImageEvent>(_onProcessImage);
    on<GeneratePDFEvent>(_onGeneratePDF);
     on<GenerateTemplatedPDFEvent>(_onGenerateTemplatedPDF);
    on<ResetEvent>(_onReset);
  }

  Future<void> _onCaptureImage(
    CaptureImageEvent event,
    Emitter<ResumeState> emit,
  ) async {
    try {
      emit(ResumeLoading());

      // Check and request camera permission
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          emit(const ResumeError(message: 'Camera permission denied'));
          return;
        }
      }

      // Check if camera is available
      if (!await _imagePicker.supportsImageSource(ImageSource.camera)) {
        emit(const ResumeError(message: 'Camera not available'));
        return;
      }

      // Capture image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        emit(ImageCaptured(imageFile: imageFile));
      } else {
        emit(ResumeInitial()); // User cancelled
      }
    } catch (e) {
      emit(ResumeError(message: 'Failed to capture image: ${e.toString()}'));
    }
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<ResumeState> emit,
  ) async {
    try {
      emit(ResumeLoading());

      final resumeData =
          await _geminiService.extractResumeData(event.imageFile);

      emit(ResumeDataExtracted(
        imageFile: event.imageFile,
        resumeData: resumeData,
      ));
    } catch (e) {
      emit(ResumeError(message: 'Failed to process image: $e'));
    }
  }

 Future<void> _onGeneratePDF(
  GeneratePDFEvent event,
  Emitter<ResumeState> emit,
) async {
  try {
    // Check if current state is correct type
    if (state is! ResumeDataExtracted) return;

    // Store the current state data BEFORE emitting loading
    final currentState = state as ResumeDataExtracted;
    
    // Now emit loading state
    emit(ResumeLoading());

    // Generate PDF using the stored state data
    final pdfFile = await _pdfService.generateResumePDF(currentState.resumeData);

    // Emit success state
    emit(PDFGenerated(
      imageFile: currentState.imageFile,
      resumeData: currentState.resumeData,
      pdfFile: pdfFile,
    ));
  } catch (e) {
    print('Error generating PDF: $e');
    emit(ResumeError(message: 'Failed to generate PDF: $e'));
  }
}

 Future<void> _onGenerateTemplatedPDF(
    GenerateTemplatedPDFEvent event,
    Emitter<ResumeState> emit,
  ) async {
    try {
      // Check if current state is correct type
      if (state is! ResumeDataExtracted) {
        emit(ResumeError(message: 'No resume data available to generate PDF'));
        return;
      }
      
      // Store the current state data BEFORE emitting loading
      final currentState = state as ResumeDataExtracted;
      final imageFile = currentState.imageFile;
      final resumeData = currentState.resumeData;
      final template = event.template;
      
      // Now emit loading state
      emit(ResumeLoading());
      
      try {
        // Generate file path
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final templateName = template.name.replaceAll(' ', '_').toLowerCase();
        final pdfPath = '${directory.path}/resume_${templateName}_$timestamp.pdf';
        
        // Use the template factory to get the appropriate generator
        final generator = TemplateFactory.getGenerator(template);
        final pdfFile = await generator.generatePDF(
          resumeData,
          pdfPath,
        );
        
        // Emit success state using stored data
        emit(PDFGenerated(
          imageFile: imageFile,
          resumeData: resumeData,
          pdfFile: pdfFile,
          template: template,
        ));
      } catch (generationError) {
        print('Template generation error: $generationError');
        emit(ResumeError(message: 'Failed to generate templated PDF: $generationError'));
      }
    } catch (e) {
      print('General error in templated PDF generation: $e');
      emit(ResumeError(message: 'Failed to generate templated PDF: $e'));
    }
  }

  void _onReset(ResetEvent event, Emitter<ResumeState> emit) {
    emit(ResumeInitial());
  }
}
