// services/pdf_generators/julia_template_generator.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:second_shot/models/resume_data_model.dart';

class JuliaTemplateGenerator {
  static Future<File> generatePDF(ResumeData resumeData, String outputPath) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Row(
            children: [
              // Left Sidebar (Dark)
              pw.Expanded(
                flex: 35,
                child: pw.Container(
                  color: const PdfColor.fromInt(0xFF2C3E50),
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Profile Photo Placeholder
                      pw.Container(
                        width: 120,
                        height: 120,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey300,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            'PHOTO',
                            style: pw.TextStyle(
                              color: PdfColors.grey600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      
                      // Contact Section
                      _buildSidebarSection(
                        'CONTACT',
                        [
                          _buildContactItem('phone', resumeData.personalInfo.phone),
                          _buildContactItem('email', resumeData.personalInfo.email),
                          //_buildContactItem('linkedin', resumeData.personalInfo.linkedin ?? ''),
                          _buildContactItem('location', resumeData.personalInfo.address),
                        ],
                      ),
                      
                      pw.SizedBox(height: 30),
                      
                      // Education Section
                      _buildSidebarSection(
                        'EDUCATION',
                        resumeData.education.map((edu) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              edu.degree,
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              edu.institution,
                              style: pw.TextStyle(
                                color: const PdfColor.fromInt(0xFFBDC3C7),
                                fontSize: 10,
                              ),
                            ),
                            // pw.Text(
                            //   '${edu.startDate} - ${edu.endDate}',
                            //   style: pw.TextStyle(
                            //     color: const PdfColor.fromInt(0xFFBDC3C7),
                            //     fontSize: 9,
                            //   ),
                            // ),
                            pw.SizedBox(height: 8),
                          ],
                        )).toList(),
                      ),
                      
                      pw.SizedBox(height: 30),
                      
                      // Skills Section
                      _buildSidebarSection(
                        'SKILLS',
                        [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              // Professional Skills
                              pw.Text(
                                '// PROFESSIONAL',
                                style: pw.TextStyle(
                                  color: const PdfColor.fromInt(0xFFBDC3C7),
                                  fontSize: 9,
                                  fontStyle: pw.FontStyle.italic,
                                ),
                              ),
                              pw.SizedBox(height: 5),
                              ...resumeData.skills.take(6).map((skill) => 
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 3),
                                  child: pw.Text(
                                    skill,
                                    style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      pw.SizedBox(height: 30),
                      
                      // Languages Section
                      _buildSidebarSection(
                        'LANGUAGES',
                        [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'English',
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 10,
                                ),
                              ),
                              pw.Text(
                                'Native',
                                style: pw.TextStyle(
                                  color: const PdfColor.fromInt(0xFFBDC3C7),
                                  fontSize: 9,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text(
                                'Spanish',
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 10,
                                ),
                              ),
                              pw.Text(
                                'Conversational',
                                style: pw.TextStyle(
                                  color: const PdfColor.fromInt(0xFFBDC3C7),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right Content (White)
              pw.Expanded(
                flex: 65,
                child: pw.Container(
                  color: PdfColors.white,
                  padding: const pw.EdgeInsets.all(40),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Header
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            resumeData.personalInfo.fullName.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 32,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                              letterSpacing: 2,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            resumeData.personalInfo.phone?.toUpperCase() ?? 'PROFESSIONAL TITLE',
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: const PdfColor.fromInt(0xFFBDC3C7),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      
                      pw.SizedBox(height: 40),
                      
                      // Professional Summary
                      _buildMainSection(
                        'PROFESSIONAL SUMMARY',
                        [
                          pw.Text(
                            resumeData.summary ?? 'A compelling resume should start with an effective statement that shows why you are the ideal candidate for the job. Demonstrate your value to the company by summarizing your accomplishments and how they can improve the organization. Create statements that highlight your strengths and what makes you a great fit for the company. When possible, quantify your achievements with data or evidence to make them more convincing.',
                            style: pw.TextStyle(
                              fontSize: 10,
                              height: 1.5,
                              color: const PdfColor.fromInt(0xFF34495E),
                            ),
                            textAlign: pw.TextAlign.justify,
                          ),
                        ],
                      ),
                      
                      pw.SizedBox(height: 30),
                      
                      // Professional Experience
                      _buildMainSection(
                        'PROFESSIONAL EXPERIENCE',
                        resumeData.experience.map((exp) => _buildExperienceItem(exp)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildSidebarSection(String title, List<pw.Widget> content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        pw.Container(
          width: 30,
          height: 2,
          color: const PdfColor.fromInt(0xFFBDC3C7),
          margin: const pw.EdgeInsets.only(top: 5, bottom: 15),
        ),
        ...content,
      ],
    );
  }

  static pw.Widget _buildContactItem(String type, String value) {
    if (value.isEmpty) return pw.SizedBox();
    
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 15,
            child: _getContactIcon(type),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

static pw.Widget _getContactIcon(String type) {
  // Return SVG icons for better PDF rendering
  switch (type) {
    case 'phone':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" fill="white"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    case 'email':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="m4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" fill="white"/>
          <polyline points="22,6 12,13 2,6" fill="none" stroke="#333" stroke-width="1"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    case 'linkedin':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" fill="white"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    case 'location':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" fill="white"/>
          <circle cx="12" cy="10" r="3" fill="#333"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    case 'website':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="12" cy="12" r="10" fill="white"/>
          <line x1="2" y1="12" x2="22" y2="12" stroke="#333"/>
          <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" stroke="#333" fill="none"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    case 'github':
      return pw.SvgImage(
        svg: '''<svg width="12" height="12" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" fill="white"/>
        </svg>''',
        width: 12,
        height: 12,
      );
    default:
      return pw.Container(
        width: 12,
        height: 12,
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          color: PdfColors.white,
        ),
        child: pw.Center(
          child: pw.Text('•', 
            style: pw.TextStyle(
              fontSize: 8, 
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            )
          ),
        ),
      );
  }
}

  static pw.Widget _buildMainSection(String title, List<pw.Widget> content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: const PdfColor.fromInt(0xFFBDC3C7),
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 15),
        ...content,
      ],
    );
  }

  static pw.Widget _buildExperienceItem(Experience experience) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 25),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  experience.position,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
              // pw.Text(
              //   '${experience.startDate} - ${experience.endDate}',
              //   style: pw.TextStyle(
              //     fontSize: 10,
              //     color: const PdfColor.fromInt(0xFF7F8C8D),
              //   ),
              // ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            '${experience.company} / ${experience.location ?? 'Location'}',
            style: pw.TextStyle(
              fontSize: 10,
              color: const PdfColor.fromInt(0xFF7F8C8D),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            experience.description ?? 'Utilize this paragraph to succinctly outline your achievements, with the use of powerful action verbs. Concentrate on the talents and qualities you have determined are pertinent to the job description.',
            style: pw.TextStyle(
              fontSize: 10,
              height: 1.4,
              color: const PdfColor.fromInt(0xFF34495E),
            ),
            textAlign: pw.TextAlign.justify,
          ),
          
          // Experience bullets/achievements
          if (experience.achievements != null && experience.achievements!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5),
              child: pw.Column(
                children: experience.achievements!.map((achievement) => 
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 4,
                          height: 4,
                          margin: const pw.EdgeInsets.only(top: 4, right: 8),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor.fromInt(0xFF3498DB),
                            shape: pw.BoxShape.circle,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            achievement,
                            style: pw.TextStyle(
                              fontSize: 9,
                              height: 1.3,
                              color: const PdfColor.fromInt(0xFF34495E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}