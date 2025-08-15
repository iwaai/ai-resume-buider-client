import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:second_shot/models/resume_data_model.dart';

class PDFService {
  Future<File> generateResumePDF(ResumeData resumeData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header with personal info
            _buildHeader(resumeData.personalInfo),
            pw.SizedBox(height: 20),

            // Summary section
            if (resumeData.summary.isNotEmpty) ...[
              _buildSectionTitle('Professional Summary'),
              _buildText(resumeData.summary),
              pw.SizedBox(height: 16),
            ],

            // Experience section
            if (resumeData.experience.isNotEmpty) ...[
              _buildSectionTitle('Professional Experience'),
              ...resumeData.experience.map((exp) => _buildExperienceItem(exp)),
              pw.SizedBox(height: 16),
            ],

            // Education section
            if (resumeData.education.isNotEmpty) ...[
              _buildSectionTitle('Education'),
              ...resumeData.education.map((edu) => _buildEducationItem(edu)),
              pw.SizedBox(height: 16),
            ],

            // Skills section
            if (resumeData.skills.isNotEmpty) ...[
              _buildSectionTitle('Skills'),
              _buildSkillsList(resumeData.skills),
              pw.SizedBox(height: 16),
            ],

            // Certifications section
            if (resumeData.certifications.isNotEmpty) ...[
              _buildSectionTitle('Certifications'),
              _buildBulletList(resumeData.certifications),
              pw.SizedBox(height: 16),
            ],

            // // Languages section
            // if (resumeData.languages.isNotEmpty) ...[
            //   _buildSectionTitle('Languages'),
            //   _buildBulletList(resumeData.languages),
            // ],
          ];
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildHeader(PersonalInfo personalInfo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          personalInfo.fullName,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        if (personalInfo.email.isNotEmpty)
          pw.Text('Email: ${personalInfo.email}'),
        if (personalInfo.phone.isNotEmpty)
          pw.Text('Phone: ${personalInfo.phone}'),
        if (personalInfo.address.isNotEmpty)
          pw.Text('Address: ${personalInfo.address}'),
        if (personalInfo.linkedIn.isNotEmpty)
          pw.Text('LinkedIn: ${personalInfo.linkedIn}'),
        if (personalInfo.github.isNotEmpty)
          pw.Text('GitHub: ${personalInfo.github}'),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Container(
          height: 2,
          width: 100,
          color: PdfColors.blue,
          margin: const pw.EdgeInsets.only(top: 4, bottom: 8),
        ),
      ],
    );
  }

  pw.Widget _buildText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(text),
    );
  }

  pw.Widget _buildExperienceItem(Experience experience) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                experience.position,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(experience.duration),
            ],
          ),
          pw.Text(
            experience.company,
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 4),
          if (experience.description.isNotEmpty)
            pw.Text(experience.description),
          if (experience.achievements.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            ...experience.achievements.map(
              (achievement) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, bottom: 2),
                child: pw.Text('• $achievement'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education education) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                education.degree,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(education.graduationYear),
            ],
          ),
          pw.Text(education.institution),
          if (education.fieldOfStudy.isNotEmpty)
            pw.Text('Field of Study: ${education.fieldOfStudy}'),
          if (education.gpa.isNotEmpty) pw.Text('GPA: ${education.gpa}'),
        ],
      ),
    );
  }

  pw.Widget _buildSkillsList(List<String> skills) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 4,
      children: skills
          .map(
            (skill) => pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(skill, style: const pw.TextStyle(fontSize: 10)),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _buildBulletList(List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items
          .map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text('• $item'),
            ),
          )
          .toList(),
    );
  }
}
