import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';

class AppTheme {
  final lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: _gSansTextTheme,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'General Sans',
    primaryColor: AppColors.primaryColor,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.secondaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90.r),
      ),
    ),
  );
}

TextTheme get _gSansTextTheme => TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 96.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: AppColors.blackColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 60.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: AppColors.blackColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 48.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        color: AppColors.blackColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 34.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.blackColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 24.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        color: AppColors.blackColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.blackColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: AppColors.blackColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.blackColor,
      ),
      titleSmall: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.blackColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.blackColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.blackColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
      labelLarge: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
        color: AppColors.blackColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
      labelSmall: TextStyle(
        fontFamily: 'General Sans',
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: Colors.grey,
      ),
    );

// pw.TextStyle get pdfTextTheme => pw.TextStyle(
//     font: pw.Font.ttf(await rootBundle.load("assets/fonts/GeneralSans.ttf")),
// );

class AppPdfTextStyles {
  static final displayLarge = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 96,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: -1.5,
    color: PdfColors.black,
  );

  static final displayMedium = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 60,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: -0.5,
    color: PdfColors.black,
  );

  static final displaySmall = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 48,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 0.0,
    color: PdfColors.black,
  );

  static final headlineLarge = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 34,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 0.25,
    color: PdfColors.black,
  );

  static final headlineMedium = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 24,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 0.0,
    color: PdfColors.black,
  );

  static final headlineSmall = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 20,
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 0.15,
    color: PdfColors.black,
  );

  static final titleLarge = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 16,
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 0.15,
    color: PdfColors.black,
  );

  static final titleMedium = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 0.1,
    color: PdfColors.black,
  );

  static final titleSmall = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 0.1,
    color: PdfColors.black,
  );

  static final bodyLarge = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 16,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 0.5,
    color: PdfColors.black,
  );

  static final bodyMedium = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 14,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 0.25,
    color: PdfColors.black,
  );

  static final bodySmall = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 12,
    fontWeight: pw.FontWeight.normal,
    color: PdfColors.grey,
  );

  static final labelLarge = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 1,
    color: PdfColors.black,
  );

  static final labelMedium = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 12,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey,
  );

  static final labelSmall = pw.TextStyle(
    // font: pdfTextTheme.font,
    fontSize: 10,
    fontWeight: pw.FontWeight.normal,
    letterSpacing: 1.5,
    color: PdfColors.grey,
  );
}
