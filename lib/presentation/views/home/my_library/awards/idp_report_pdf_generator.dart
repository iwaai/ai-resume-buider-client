import 'dart:io';

// import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:second_shot/models/AwardAnswerModel.dart';
import 'package:second_shot/models/get_resume_model.dart';
import 'package:second_shot/models/transferable_skills_model.dart';

import '../../../../../utils/constants/assets.dart';
import '../../../../../utils/constants/constant.dart';

Future<File?> generateAwardPDF(
    {bool openFile = false,
    required int index,
    required List<AwardAnswerModel> awardAnswerModels}) async {
  final pdf = pw.Document();
  final timesFont =
      pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf'));
  final List<pw.MemoryImage> awardImages = [
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.rookieAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.gameAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.mvpAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.careerAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.hallOfFame)).buffer.asUint8List(),
    ),
  ];
  final String? singleAnswer = awardAnswerModels[index].singleAnswer;
  final List<String>? listAnswer = awardAnswerModels[index].listAnswer;
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      theme: pw.ThemeData.withFont(base: timesFont),
      build: (pw.Context context) => [
            pw.Text(
              '(IDP)',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.Divider(color: PdfColors.black, thickness: 2),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  /// Award Image
                  pw.Image(awardImages[index], width: 100, height: 100),
                  pw.SizedBox(width: 30),
                  pw.Container(
                      width: 400,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          /// Question No
                          pw.Text('Question ${index + 1}:',
                              style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 7),
                          pw.Text(
                            awardAnswerModels[index].question?.question ?? '',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.SizedBox(height: 10),

                          /// Answer
                          pw.Text('Answer:',
                              style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 7),
                          if (listAnswer != null)
                            ...List.generate(listAnswer.length, (index) {
                              return pw.Text('• ${listAnswer[index]} ');
                            }),
                          if (singleAnswer != null)
                            pw.Text(
                              '• $singleAnswer',
                            ),
                          pw.SizedBox(height: 50),
                        ],
                      ))
                ])
          ]));
  final file = await _saveAndDownloadPdf(pdf, 'Second Shot IDP');

  if (file != null && openFile == true) {
    OpenFile.open(file.path);
  }

  return file;
}

Future<File?> generateCombinedPDF({
  required String userName,
  required BuildContext context,
  required ResumeModel? resumeModel,
  required TransferableSkillsModel? tSkillModel,
  required List<AwardAnswerModel> awardAnswerModels,
  bool openFile = false,
}) async {
  final pdf = pw.Document();
  final timesFont =
      pw.Font.ttf(await rootBundle.load('assets/fonts/times.ttf'));
  pw.Widget buildSkillSection(String heading, List<Topic> topics,
      {bool showSection = true}) {
    return showSection
        ? pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                heading,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 8),
              ...topics.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final topic = entry.value;
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '\t$index. ${topic.title}',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '     a. \t\t${topic.description?.replaceAll(RegExp(r"[‘’]"), "'") ?? ''}',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 12),
                  ],
                );
              }),
            ],
          )
        : pw.SizedBox.shrink();
  }

  final logoImage = pw.MemoryImage(
      (await rootBundle.load(AssetConstants.appLogo)).buffer.asUint8List());
  final List<pw.MemoryImage> awardImages = [
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.rookieAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.gameAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.mvpAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.careerAward)).buffer.asUint8List(),
    ),
    pw.MemoryImage(
      (await rootBundle.load(AssetConstants.hallOfFame)).buffer.asUint8List(),
    ),
  ];

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      theme: pw.ThemeData.withFont(base: timesFont),
      build: (pw.Context context) => [
        /// Initial
        ...[
          pw.Center(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(logoImage, width: 200, height: 200),
                  pw.Text(
                    'Second Shot Full Report',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Prepared for: $userName',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ]),
          ),
          pw.SizedBox(height: 10),
        ],

        /// IDP
        ...[
          pw.Text(
            'Individual Development Plan',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(color: PdfColors.black, thickness: 2),
          pw.SizedBox(height: 20),
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(5, (index) {
                final String? singleAnswer =
                    awardAnswerModels[index].singleAnswer;
                final List<String>? listAnswer =
                    awardAnswerModels[index].listAnswer;
                return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      /// Award Image
                      pw.Image(awardImages[index], width: 100, height: 100),
                      pw.SizedBox(width: 30),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          /// Question No
                          pw.Text('Question ${index + 1}:',
                              style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 7),
                          pw.Text(
                            '${awardAnswerModels[index].question?.question}',
                          ),
                          pw.SizedBox(height: 10),

                          /// Answer
                          pw.Text('Answer:',
                              style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 7),
                          if (listAnswer != null)
                            ...List.generate(listAnswer.length, (index) {
                              return pw.Text('• ${listAnswer[index]} ');
                            }),
                          if (singleAnswer != null)
                            pw.Text(
                              '• $singleAnswer',
                            ),
                          pw.SizedBox(height: 50),
                        ],
                      )
                    ]);
              }))
        ],

        /// Resume Section
        if (resumeModel != null) ...[
          pw.NewPage(),
          pw.Text(
            'RESUME',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(color: PdfColors.black, thickness: 2),
          _buildHeader(resumeModel.fullName ?? "", resumeModel.email ?? "",
              resumeModel.phone ?? "", resumeModel.address ?? ""),
          if (resumeModel.objective?.description != null &&
              resumeModel.objective!.description!.isNotEmpty)
            _buildSection(
                title: 'Objective',
                items: [resumeModel.objective!.description!]),
          if (resumeModel.education != null &&
              resumeModel.education!.isNotEmpty &&
              resumeModel.education!.any((edu) =>
                  (edu.institution?.isNotEmpty ?? false) ||
                  (edu.startYear != null) ||
                  (edu.endYear != null)))
            _buildEducationSection(resumeModel.education!),
          if (resumeModel.licensesAndCertifications != null &&
              resumeModel.licensesAndCertifications!.isNotEmpty &&
              resumeModel.licensesAndCertifications!.any((cert) =>
                  (cert.certificationName?.isNotEmpty ?? false) ||
                  (cert.issueDate != null) ||
                  (cert.expirationDate != null)))
            _buildCertificationsSection(resumeModel.licensesAndCertifications!),
          if (resumeModel.softSkills != null &&
              resumeModel.softSkills!.isNotEmpty)
            _buildSection(
              title: 'Soft Skills',
              items: resumeModel.softSkills!,
            ),
          if (resumeModel.technicalSkills != null &&
              resumeModel.technicalSkills!.isNotEmpty)
            _buildSection(
              title: 'Technical Skills',
              items: resumeModel.technicalSkills!,
            ),
          if (resumeModel.experience != null &&
              resumeModel.experience!.isNotEmpty &&
              resumeModel.experience!.any((exp) =>
                  (exp.company?.isNotEmpty ?? false) ||
                  (exp.startDate != null) ||
                  (exp.endDate != null)))
            _buildExperienceSection(resumeModel.experience!),
          if (resumeModel.volunteerExperience != null &&
              resumeModel.volunteerExperience!.isNotEmpty &&
              resumeModel.volunteerExperience!.any((vol) =>
                  (vol.organizationName?.isNotEmpty ?? false) ||
                  (vol.startYear != null) ||
                  (vol.endYear != null)))
            _buildVolunteerSection(resumeModel.volunteerExperience!),
          if (resumeModel.honorsAndAwards != null &&
              resumeModel.honorsAndAwards!.isNotEmpty &&
              resumeModel.honorsAndAwards!.any((honor) =>
                  (honor.awardName?.isNotEmpty ?? false) ||
                  (honor.dateReceived != null)))
            _buildHonorsSection(resumeModel.honorsAndAwards!),
        ],

        /// Transferable Skills Section
        if (tSkillModel != null) ...[
          pw.NewPage(),
          pw.Text(
            'User Profile & Resume',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 14),
          pw.Text(
            'USER PROFILE',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(color: PdfColors.black, thickness: 2),
          pw.SizedBox(height: 20),
          buildSkillSection(
            showSection: tSkillModel.isAthlete ?? true,
            'Athlete: ${tSkillModel.athlete?.primarySport?.sportName}',
            tSkillModel.athlete?.primarySport?.topics ?? [],
          ),
          buildSkillSection(
            showSection: tSkillModel.isAthlete ?? true,
            'Athlete: ${tSkillModel.athlete?.sportPosition?.positionName}',
            tSkillModel.athlete?.sportPosition?.topics ?? [],
          ),
          buildSkillSection(
            'Favourite School Subject: ${tSkillModel.favoriteMiddleSchoolSubject?.subjectName}',
            tSkillModel.favoriteMiddleSchoolSubject?.topics ?? [],
          ),
          buildSkillSection(
            'Favourite Hobby 1: ${tSkillModel.favoriteHobby1?.hobbieName}',
            tSkillModel.favoriteHobby1?.topics ?? [],
          ),
          buildSkillSection(
            'Favourite Hobby 2: ${tSkillModel.favoriteHobby2?.hobbieName}',
            tSkillModel.favoriteHobby2?.topics ?? [],
          ),

          // buildSkillSection(
          //   showSection: tSkillModel.hasMilitaryService ?? true,
          //   'Military: ${tSkillModel.military?.rank?.rankName}',
          //   tSkillModel.military?.rank?.topics ?? [],
          // ),
        ],
      ],
    ),
  );

  final file = await _saveAndDownloadPdf(pdf, 'Second Shot Full Report');

  if (file != null && openFile == true) {
    OpenFile.open(file.path);
  }

  return file;
}

// Function to save the PDF file
Future<File?> _saveAndDownloadPdf(pw.Document pdf, String docName) async {
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
      final filePath = '${directory.path}/$docName-$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print('PDF saved at $filePath');

      return file;
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
