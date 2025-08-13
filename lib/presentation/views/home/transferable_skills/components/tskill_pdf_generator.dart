import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:second_shot/models/transferable_skills_model.dart';

Future<File?> generateTSkillPDF(
    {bool isSupportPeople = false,
    required Uint8List screenShot,
    required String userName,
    required TransferableSkillsModel model}) async {
  final pdf = pw.Document();

  final logoData = await rootBundle.load('assets/images/app_logo.png');
  final topLogo = pw.MemoryImage(logoData.buffer.asUint8List());

  final screenshotImage = pw.MemoryImage(screenShot);

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
                      '\t\t${topic.description?.replaceAll(RegExp(r"[‘’]"), "'") ?? ''}',
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

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) => [
        pw.Center(
          child: pw.Image(topLogo, width: 100, height: 100),
        ),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text(
            'Second Shot Career Prep Toolbox Report',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Center(
          child: pw.Text(
            'Prepared for: $userName',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Transferable Skills Report',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Center(child: pw.Image(screenshotImage, fit: pw.BoxFit.contain)),
        pw.NewPage(),
        buildSkillSection(
          showSection: model.isAthlete ?? true,
          'Primary Sport: ${model.athlete?.primarySport?.sportName}',
          model.athlete?.primarySport?.topics ?? [],
        ),
        buildSkillSection(
          showSection: model.isAthlete ?? true,
          'Sport Position: ${model.athlete?.sportPosition?.positionName}',
          model.athlete?.sportPosition?.topics ?? [],
        ),
        buildSkillSection(
          'Favourite School Subject: ${model.favoriteMiddleSchoolSubject?.subjectName}',
          model.favoriteMiddleSchoolSubject?.topics ?? [],
        ),
        buildSkillSection(
          'Favourite Hobby 1: ${model.favoriteHobby1?.hobbieName}',
          model.favoriteHobby1?.topics ?? [],
        ),
        buildSkillSection(
          'Favourite Hobby 2: ${model.favoriteHobby2?.hobbieName}',
          model.favoriteHobby2?.topics ?? [],
        ),
        // buildSkillSection(
        //   showSection: model.hasMilitaryService ?? true,
        //   'Military: ${model.military?.rank?.rankName}',
        //   model.military?.rank?.topics ?? [],
        // ),
      ],
    ),
  );
  return await _savePDF(pdf: pdf, isSupportPeople: isSupportPeople);
}

Future<File?> _savePDF(
    {required pw.Document pdf, required bool isSupportPeople}) async {
  try {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null) {
      String timestamp =
          DateFormat('d-MMMM-yyyy_HH-mm-ss').format(DateTime.now());
      final filePath =
          '${directory.path}/Transferable Skills Report $timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      if (!isSupportPeople) OpenFile.open(filePath);

      return file;
    }
  } catch (e) {
    log('Error while saving/opening PDF: $e');
  }
  return null;
}
