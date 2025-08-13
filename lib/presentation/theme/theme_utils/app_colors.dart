import 'package:flutter/material.dart';

final class AppColors {
  static const Color primaryColor = Color(0xff3F51B5); // Deep Indigo
  static const Color secondaryColor = Color(0xff00BCD4); // Cyan
  static const Color accentColor = Color(0xff00BCD4); // Cyan
  static const Color backgroundColor = Color(0xffF4F6F8);
  static const Color blackColor = Color(0xff000000);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color lightBlueColor = Color(0xff0A84FF);
  static const Color greyishBlueColor = Color(0xff283F55);
  static const Color redColor = Color(0xffEB001B);
  static const Color yellowColor = Color(0xffF0C000);
  static const Color lightYellow = Color(0xffFBEFBD);
  static const Color primaryBlue = Color(0xff0081FF);
  static const Color resumeBoxColor = Color(0xffE8F5EA);
  static const Color homeCardButtonColor = Color(0xff9CA3AF);

  ///Use with primary
  static Color buttonGradient = const Color(0xff061523);

  /// Use with secondary as 2nd color
  static const LinearGradient scaffoldGradient = LinearGradient(
    colors: [
      Color(0xff0554A4),
      Color(0xff00BCD4)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );


  /// Home card gradient colors
  static const Color transferableSkillsDark = Color(0xff25314F);
  static const Color transferableSkillsLight = Color(0xff5470B5);
  static const Color myLibraryDark = Color(0xffD39100);
  static const Color myLibraryLight = Color(0xffFFDF9B);
  static const Color careerRecommDark = Color(0xffED3283);
  static const Color careerRecommLight = Color(0xffFF6CAC);
  static const Color goalSettingLight = Color(0xff3893A7);
  static const Color goalSettingDark = Color(0xff00303A);
  static const Color resumeBuilderDark = Color(0xff9156A2);
  static const Color resumeBuilderLight = Color(0xffDE6CFF);
  static const Color successStoriesLight = Color(0xffA8EA51);
  static const Color successStoriesDark = Color(0xff5A8D15);

  static Color borderGrey = const Color(0xffD9d9d9);
  static Color cancelGrey = const Color(0xffdddddd);
  static Color borderColor = const Color(0xffEFEFEF);
  static Color textGrey = const Color(0xff3E414C);
  static Color chatTextFieldColor = const Color(0xffE1E3E7);
  static Color grey = const Color(0xff9A9A9A);
  static Color lightGrey = const Color(0xff02274B).withOpacity(.15);
  static Color bulletGrey = const Color(0xff02274B).withOpacity(.15);
  static Color primaryGrey = const Color(0xffededed);
  static Color chatWhite = const Color(0xffF8F8F8);
  static Color buttonGrey = const Color(0xffE5EAED);

  static Color paleBlue = const Color(0xFFF4FDFF);
  static Color lightPurple = const Color(0xFFFAF5FF);
  static Color palePink = const Color(0xFFFFF2F7);
  static Color homeCardGreen = const Color(0xFF01A01A);
  static Color lightCream = const Color(0xFFFFFBF1);
  static Color softBlue = const Color(0xFFF2F7FF);
  static Color pureRed = const Color(0xFFFF0000);
  static Color lightPink = const Color(0xFFFFBCBC);
  static Color veryLightGreen = const Color(0xFFEAF4E8);
  static Color brightGreen = const Color(0xFF3FC600);
  static Color textGray = const Color(0xFF636363);
  static Color textBlack = const Color(0xFF222222);
  static Color profileText = const Color(0xFF5C5C5C);
  static Color dividerColor = const Color(0xFFC6C6C6);
  static Color editButtonColor = const Color(0xFF02264A);
  static Color uploadButtonColor = const Color(0xFF0E73D0);
  static Color stepsSelectedColor = const Color(0xFF375979);
  static Color stepsNonSelectedColor = const Color(0xFF969696);
  static Color tSkillsButtonGrey = const Color(0xffF6F6F6);
  static Color tSkillsTextGrey = const Color(0xff737373);
  static Color userBackgroundGreenColor = const Color(0xffB8FD98);
  static Color skillPopupColor = const Color(0xffD4FFC2);
  static Color rookieAwardColor1 = const Color(0xff5470B5);
  static Color rookieAwardColor2 = const Color(0xff25314F);
  static Color playbookAwardColor1 = const Color(0xffED3283);
  static Color playbookAwardColor2 = const Color(0xffFF6CAC);
  static Color gameAwardColor1 = const Color(0xff3893A7);
  static Color gameAwardColor2 = const Color(0xff00303A);
  static Color careerAwardColor1 = const Color(0xff0A66C2);
  static Color careerAwardColor2 = const Color(0xff0080FF);
  static Color hallOfFameAwardColor1 = const Color(0xffDE6CFF);
  static Color hallOfFameAwardColor2 = const Color(0xffDE6CFF);

  // static Color previousStepsColor = const Color(0xFF969696);

  static LinearGradient primaryGradient = LinearGradient(
      colors: [buttonGradient, primaryColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight);

  static LinearGradient communityServiceGradient = const LinearGradient(
      colors: [Color(0xffC1272D), Color(0xffD3572A), Color(0xffF7941D)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);

  static LinearGradient mockInterviewGradient = const LinearGradient(
      colors: [Color(0xff911E2D), Color(0xffCB2128), Color(0xffED2024)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);

  static LinearGradient entrepreneurshipGradient = const LinearGradient(
      colors: [Color(0xff5B2D90), Color(0xff7D3895), Color(0xffB9529F)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);

  static LinearGradient homeGradient(
          {Color color1 = Colors.transparent,
          Color color2 = Colors.transparent,
          List<Color>? colors}) =>
      LinearGradient(
          colors: colors ??
              [
                color1,
                color2,
              ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight);

  static LinearGradient appBarGradient(Color color1, Color color2) =>
      LinearGradient(colors: [
        color1,
        color2,
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  // static LinearGradient awardCardGradient({required List<Color> colors}) =>
  //     LinearGradient(
  //         colors: colors,
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter);
}
