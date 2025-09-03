import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:second_shot/models/get_resume_model.dart';

import '../utils/constants/constant.dart';

Future<File?> generateAndDownloadPdf(ResumeModel model,
    {bool isEmail = false}) async {
  final pdf = pw.Document();
  
  // Load font with proper error handling
  pw.Font? customFont;
  try {
    customFont = pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf'));
  } catch (e) {
    print('Could not load custom font, using default font: $e');
    // customFont will remain null and pdf will use default font
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      theme: customFont != null 
          ? pw.ThemeData.withFont(base: customFont)
          : pw.ThemeData(), // Use default theme if custom font fails
      build: (pw.Context context) => [
        _buildHeader(model.fullName ?? "", model.email ?? "", model.phone ?? "",
            model.address ?? ""),
        if (model.objective?.description != null &&
            model.objective!.description!.isNotEmpty)
          _buildSection(
              title: 'Objective', items: [model.objective!.description!]),
        if (model.education != null &&
            model.education!.isNotEmpty &&
            model.education!.any((edu) =>
                (edu.institution?.isNotEmpty ?? false) ||
                (edu.startYear != null) ||
                (edu.endYear != null)))
          _buildEducationSection(model.education!),
        if (model.licensesAndCertifications != null &&
            model.licensesAndCertifications!.isNotEmpty &&
            model.licensesAndCertifications!.any((cert) =>
                (cert.certificationName?.isNotEmpty ?? false) ||
                (cert.issueDate != null) ||
                (cert.expirationDate != null)))
          _buildCertificationsSection(model.licensesAndCertifications!),
        if (model.softSkills != null && model.softSkills!.isNotEmpty)
          _buildSection(
            title: 'Soft Skills',
            items: model.softSkills!,
          ),
        if (model.technicalSkills != null && model.technicalSkills!.isNotEmpty)
          _buildSection(
            title: 'Technical Skills',
            items: model.technicalSkills!,
          ),
        if (model.experience != null &&
            model.experience!.isNotEmpty &&
            model.experience!.any((exp) =>
                (exp.company?.isNotEmpty ?? false) ||
                (exp.startDate != null) ||
                (exp.endDate != null)))
          _buildExperienceSection(model.experience!),
        if (model.volunteerExperience != null &&
            model.volunteerExperience!.isNotEmpty &&
            model.volunteerExperience!.any((vol) =>
                (vol.organizationName?.isNotEmpty ?? false) ||
                (vol.startYear != null) ||
                (vol.endYear != null)))
          _buildVolunteerSection(model.volunteerExperience!),
        if (model.honorsAndAwards != null &&
            model.honorsAndAwards!.isNotEmpty &&
            model.honorsAndAwards!.any((honor) =>
                (honor.awardName?.isNotEmpty ?? false) ||
                (honor.dateReceived != null)))
          _buildHonorsSection(model.honorsAndAwards!),
      ],
    ),
  );

  return await _saveAndDownloadPdf(pdf, isEmail);
}

// Function to save the PDF file
Future<File?> _saveAndDownloadPdf(pw.Document pdf, bool isEmail) async {
  try {
    Directory? directory;

    if (Platform.isAndroid) {
      directory =
          Directory('/storage/emulated/0/Download'); // Android Downloads folder
    } else if (Platform.isIOS) {
      directory =
          await getApplicationDocumentsDirectory(); // iOS documents directory
    }

    if (directory != null) {
      String timestamp = DateFormat('d-MMMM-yyyy_HH-mm-ss')
          .format(DateTime.now()); // Add time to filename
      final filePath = '${directory.path}/resume_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print('PDF saved at $filePath');

      // Return the file if isEmail is true OR always return it for UI purposes
      return file; // Always return the file so UI can show success
    }
  } catch (e) {
    print('Error while saving PDF: $e');
  }
  return null;
}

pw.Widget _buildHeader(
    String name, String email, String phone, String address) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Text(name,
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(email, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(width: 10),
          pw.Text(phone, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(width: 10),
          pw.Text(address, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
      pw.SizedBox(height: 10),
    ],
  );
}

pw.Widget _buildSection({
  required String title,
  required List<String> items,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      pw.Wrap(
        spacing: 10,
        runSpacing: 5,
        children: items
            .map(
              (item) => pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (title != 'Objective')
                      pw.Container(
                          height: 6,
                          width: 6,
                          decoration: const pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              color: PdfColors.black)),
                    pw.Text(
                      ' $item',
                      style: const pw.TextStyle(fontSize: 12),
                    )
                  ]),
            )
            .toList(),
      ),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 10),
    ],
  );
}

pw.Widget _buildEducationSection(List<Education> educationList) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Education',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      ...educationList.map((edu) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(edu.institution ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('(${edu.startYear} - ${edu.endYear})'),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Wrap(
              children: [
                pw.Bullet(
                  bulletMargin: const pw.EdgeInsets.only(
                      top: 1.5 * PdfPageFormat.mm,
                      right: 2.0 * PdfPageFormat.mm,
                      left: 0),
                  text: edu.degree,
                ),
              ],
            ),
            pw.SizedBox(height: 6),
          ])),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 10),
    ],
  );
}

// Function to build certifications section
pw.Widget _buildCertificationsSection(List<LicensesAndCertification> certs) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Certificates',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      ...certs.map((cert) => pw.Column(children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(cert.certificationName ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    '${cert.issueDate != null ? formatDate(cert.issueDate!) : "N/A"} - '
                    '${cert.expirationDate != null ? formatDate(cert.expirationDate!) : "N/A"}'),
              ],
            ),
            pw.Wrap(
              children: [
                pw.Bullet(
                  bulletMargin: const pw.EdgeInsets.only(
                      top: 1.5 * PdfPageFormat.mm,
                      right: 2.0 * PdfPageFormat.mm,
                      left: 0),
                  text: cert.issuingOrganization,
                ),
              ],
            ),
            pw.SizedBox(height: 10),
          ])),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 10),
    ],
  );
}

// Function to build work experience section
pw.Widget _buildExperienceSection(List<Experience> experienceList) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Work Experience',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      ...experienceList.map((exp) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(exp.company ?? "",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      '${exp.startDate != null ? formatDate(exp.startDate!) : "N/A"} - '
                      '${exp.endDate != null ? formatDate(exp.endDate!) : "Present"}'),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Text(exp.jobTitle ?? "",
                  style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 6),
              pw.Wrap(children: [
                pw.Bullet(
                    bulletMargin: const pw.EdgeInsets.only(
                        top: 1.5 * PdfPageFormat.mm,
                        right: 2.0 * PdfPageFormat.mm,
                        left: 0),
                    text: exp.description)
              ]),
              pw.Divider(color: PdfColors.grey300),
            ],
          )),
      pw.SizedBox(height: 10),
    ],
  );
}

// Function to build volunteer experience section
pw.Widget _buildVolunteerSection(List<VolunteerExperience> volunteerList) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Volunteer Service',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      ...volunteerList.map((vol) => pw.Column(children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(vol.organizationName ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('(${vol.startYear} - ${vol.endYear})'),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Wrap(children: [
              pw.Bullet(
                  bulletMargin: const pw.EdgeInsets.only(
                      top: 1.5 * PdfPageFormat.mm,
                      right: 2.0 * PdfPageFormat.mm,
                      left: 0),
                  text: vol.description)
            ]),
          ])),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 10),
    ],
  );
}

// Function to build honors and awards section
pw.Widget _buildHonorsSection(List<HonorsAndAward> honorsList) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Honors & Awards',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 5),
      ...honorsList.map((honor) => pw.Column(children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(honor.awardName ?? '',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    '(${honor.dateReceived != null ? formatDate(honor.dateReceived!) : "N/A"})'),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Wrap(children: [
              pw.Bullet(
                  bulletMargin: const pw.EdgeInsets.only(
                      top: 1.5 * PdfPageFormat.mm,
                      right: 2.0 * PdfPageFormat.mm,
                      left: 0),
                  text: honor.awardingOrganization)
            ]),
          ])),
      pw.SizedBox(height: 10),
    ],
  );
}