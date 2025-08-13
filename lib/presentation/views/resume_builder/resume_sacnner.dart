import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_event.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_state.dart';
import 'package:second_shot/models/resume_data_model.dart';
import 'package:second_shot/presentation/components/resume_preview_widget.dart';

class ResumeScannerScreen extends StatelessWidget {
  const ResumeScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Scanner'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ResumeBloc, ResumeState>(
        listener: (context, state) {
          if (state is ResumeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PDFGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF generated: ${state.pdfFile.path}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ResumeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ResumeInitial) {
            return _buildInitialView(context);
          }

          if (state is ImageCaptured) {
            return _buildImageCapturedView(context, state.imageFile);
          }

          if (state is ResumeDataExtracted) {
            return _buildDataExtractedView(
              context,
              state.imageFile,
              state.resumeData,
            );
          }

          if (state is PDFGenerated) {
            return _buildPDFGeneratedView(
              context,
              state.imageFile,
              state.resumeData,
              state.pdfFile,
            );
          }

          return _buildInitialView(context);
        },
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'Capture Your Resume',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Take a photo of your resume to extract and structure the data',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ResumeBloc>().add(CaptureImageEvent());
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Capture Resume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCapturedView(BuildContext context, File imageFile) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ResumeBloc>().add(ResetEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retake'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ResumeBloc>().add(
                          ProcessImageEvent(imageFile: imageFile),
                        );
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Process'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataExtractedView(
    BuildContext context,
    File imageFile,
    ResumeData resumeData,
  ) {
    return Column(
      children: [
        Expanded(
          child: ResumePreviewWidget(resumeData: resumeData),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ResumeBloc>().add(ResetEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Start Over'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ResumeBloc>().add(GeneratePDFEvent());
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPDFGeneratedView(
    BuildContext context,
    File imageFile,
    ResumeData resumeData,
    File pdfFile,
  ) {
    return Column(
      children: [
        Expanded(
          child: ResumePreviewWidget(resumeData: resumeData),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'PDF Generated Successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Saved to: ${pdfFile.path}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<ResumeBloc>().add(ResetEvent());
                },
                icon: const Icon(Icons.add),
                label: const Text('Scan Another Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
