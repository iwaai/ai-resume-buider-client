// presentation/screens/template_selection_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/models/resume_template.dart';
import 'package:second_shot/models/resume_data_model.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_event.dart';
import 'package:second_shot/blocs/resume_builder/resume_builder_state.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class TemplateSelectionScreen extends StatefulWidget {
  final ResumeData resumeData;

  const TemplateSelectionScreen({
    Key? key,
    required this.resumeData,
  }) : super(key: key);

  @override
  State<TemplateSelectionScreen> createState() => _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  ResumeTemplate? selectedTemplate;
  File? _generatedPdfFile;
  bool _showPdfGeneratedView = false;

  @override
  Widget build(BuildContext context) {
    // Show PDF generated view if applicable
    if (_showPdfGeneratedView && _generatedPdfFile != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Generated'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: _buildPDFGeneratedView(context, _generatedPdfFile!),
      );
    }

    final templates = ResumeTemplate.getAvailableTemplates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (selectedTemplate != null)
            TextButton.icon(
              onPressed: () => _showGenerateDialog(context),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                'Generate',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: BlocConsumer<ResumeBloc, ResumeState>(
        listener: (context, state) {
          if (state is PDFGenerated) {
            // Handle templated PDF generation success
            setState(() {
              _generatedPdfFile = state.pdfFile;
              _showPdfGeneratedView = true;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Templated PDF generated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ResumeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a template for your resume',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          final template = templates[index];
                          final isSelected = selectedTemplate?.id == template.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTemplate = template;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                                  width: isSelected ? 3 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Template Preview
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        color: Colors.grey.shade100,
                                      ),
                                      child: Stack(
                                        children: [
                                          // Template preview widget
                                          ClipRRect(
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: _buildTemplatePreview(template),
                                          ),
                                          
                                          // Premium badge
                                          if (template.isPremium)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  'PRO',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          
                                          // Selection indicator
                                          if (isSelected)
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Template Info
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          template.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          template.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading overlay
              if (state is ResumeLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTemplatePreview(ResumeTemplate template) {
    // Build miniature preview based on template type
    switch (template.id) {
      case 'julia_template':
        return _buildJuliaProfessionalPreview();
      case 'mary_rose_template':
        return _buildMaryRosePreview();
      case 'classic_template':
        return _buildClassicPreview();
      case 'modern_template':
        return _buildModernPreview();
      case 'creative_template':
        return _buildCreativePreview();
      default:
        return _buildJuliaProfessionalPreview();
    }
  }

  Widget _buildJuliaProfessionalPreview() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // Left sidebar
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF2C3E50),
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo placeholder
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Contact section
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  const SizedBox(height: 4),
                  // Skills section
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 1),
                  Container(
                    width: double.infinity * 0.8,
                    height: 1,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          // Right content
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Container(
                    width: double.infinity * 0.7,
                    height: 3,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 1),
                  Container(
                    width: double.infinity * 0.5,
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  // Content lines
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 1),
                  Container(
                    width: double.infinity * 0.8,
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 1),
                  Container(
                    width: double.infinity * 0.9,
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaryRosePreview() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header with photo and name
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  // Photo circle
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity * 0.8,
                          height: 2,
                          color: const Color(0xFFD4A574),
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity * 0.5,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contact bar
          Container(
            width: double.infinity,
            height: 6,
            color: const Color(0xFFD4C5A0),
          ),
          // Content area
          Expanded(
            flex: 4,
            child: Row(
              children: [
                // Left sidebar
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFFE8E8E8),
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity * 0.7,
                          height: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                // Right content
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity * 0.9,
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 1),
                        Container(
                          width: double.infinity * 0.8,
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicPreview() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity * 0.6,
            height: 3,
            color: Colors.black87,
          ),
          const SizedBox(height: 1),
          Container(
            width: double.infinity * 0.4,
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          // Content
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 1),
          Container(
            width: double.infinity * 0.9,
            height: 1,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 1),
          Container(
            width: double.infinity * 0.7,
            height: 1,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildModernPreview() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 8,
            color: Colors.teal,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity * 0.6,
                    height: 3,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreativePreview() {
    return Container(
      color: Colors.purple.shade50,
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity * 0.6,
                  height: 3,
                  color: Colors.purple.shade700,
                ),
                const SizedBox(height: 2),
                Container(
                  width: double.infinity * 0.8,
                  height: 1,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPDFGeneratedView(BuildContext context, File pdfFile) {
    return Column(
      children: [
        // Resume template preview section
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Templated PDF Generated Successfully!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Template info
                  if (selectedTemplate != null) ...[
                    Text(
                      'Template Used: ${selectedTemplate!.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedTemplate!.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Resume data preview
                  Text(
                    'Resume Preview:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.resumeData.personalInfo.fullName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.resumeData.personalInfo.email),
                        Text(widget.resumeData.personalInfo.phone),
                        if (widget.resumeData.summary.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Summary: ${widget.resumeData.summary}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (widget.resumeData.experience.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('${widget.resumeData.experience.length} work experiences'),
                        ],
                        if (widget.resumeData.skills.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('${widget.resumeData.skills.length} skills listed'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Bottom action buttons
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.green.shade50,
          child: Column(
            children: [
              Text(
                'Saved to: ${pdfFile.path}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final result = await OpenFile.open(pdfFile.path);
                          if (result.type != ResultType.done) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not open PDF: ${result.message}'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error opening PDF: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Open PDF', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showPdfGeneratedView = false;
                          _generatedPdfFile = null;
                          selectedTemplate = null; // Reset template selection
                        });
                      },
                      icon: const Icon(Icons.palette, size: 18),
                      label: const Text('Try Another', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showGenerateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generate PDF'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Generate PDF using ${selectedTemplate!.name} template?'),
              const SizedBox(height: 8),
              if (selectedTemplate!.isPremium)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'This is a premium template',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Show loading dialog immediately
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => WillPopScope(
                    onWillPop: () async => false,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Generating PDF with template...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                
                // Add small delay to let dialog render
                await Future.delayed(Duration(milliseconds: 100));
                
                // Dispatch the event to generate templated PDF
                if (context.mounted) {
                  context.read<ResumeBloc>().add(
                        GenerateTemplatedPDFEvent(
                          template: selectedTemplate!,
                        ),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate PDF'),
            ),
          ],
        );
      },
    );
  }
}