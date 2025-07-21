import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/AwardAnswerModel.dart';

import '../../../../../utils/constants/assets.dart';
import '../../../../components/primary_button.dart';
import '../../../../theme/theme_utils/app_colors.dart';

class AwardCard extends StatelessWidget {
  final int index;
  final AwardAnswerModel? model;
  final void Function()? buttonOnTap;
  final void Function() onCardTap;

  const AwardCard(
      {super.key,
      required this.index,
      required this.model,
      required this.buttonOnTap,
      required this.onCardTap});

  Map<String, dynamic> getCardDetails(int index) {
    switch (index) {
      case 0:
        {
          return {
            'title': 'Getting in the Game',
            'colors': const Color(0xFF5470B5),
            'image': AssetConstants.rookieAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Rookie Award for identifying her top transferable skills: ${model?.listAnswer?.join(', ')}. Congratulations!"
            // model?.listAnswer,
          };
        }
      case 1:
        {
          return {
            'title': 'Ready to Complete',
            'colors': const Color(0xFF00303A),
            'image': AssetConstants.gameAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Playbook Pro Award for identifying her top Career ${model?.listAnswer?.join(',')}. Congratulations!",
          };
        }
      case 2:
        {
          return {
            'title': 'Most Valuable Player',
            'colors': Colors.pink.shade300,
            'image': AssetConstants.mvpAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Game Time Award for selecting the ${model?.singleAnswer} to further research and apply. Congratulations!",
          };
        }
      case 3:
        {
          return {
            'title': 'Undefeated',
            'colors': const Color(0xFFDE6CFF),
            'image': AssetConstants.careerAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Career Champion Award for ${model?.singleAnswer} completing her LinkedIn Profile",
          };
        }
      case 4:
        {
          return {
            'title': 'The Goat',
            'colors': const Color(0xFF0080FF),
            'image': AssetConstants.hallOfFame,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Hall of Fame Award for completing her Individual ${model?.singleAnswer} Development Plan. Congratulations!",
          };
        }
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = getCardDetails(index)['colors'];
    final String title = getCardDetails(index)['title'];
    final String image = getCardDetails(index)['image'];
    final dynamic answer = getCardDetails(index)['answer'];
    final bool showButton = model != null
        ? index <= 1
            ? model?.listAnswer == null
            : index <= 5
                ? model?.singleAnswer == null
                : false
        : true;
    return GestureDetector(
      onTap: () {
        if (!showButton) {
          print("Clicked");
          onCardTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.grey.withOpacity(0.5)),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 80.h,
              width: 80.w,
              opacity: AlwaysStoppedAnimation(model != null
                  ? index <= 1
                      ? model?.listAnswer == null
                          ? 0.3
                          : 1
                      : model?.singleAnswer == null
                          ? 0.3
                          : 1
                  : 0.3),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: model != null
                    ? index <= 1
                        ? model?.listAnswer == null
                            ? color.withOpacity(0.4)
                            : color
                        : model?.singleAnswer == null
                            ? color.withOpacity(0.4)
                            : color
                    : color.withOpacity(0.4),
              ),
            ),
            SizedBox(height: 16.h),
            if (!showButton)
              Text(
                answer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: color,
                ),
              ),

            Visibility(
              visible: showButton,
              child:
                  PrimaryButton(onPressed: buttonOnTap, text: "Get the Badge"),
            ),
            // Constant.verticalSpace(.h)
          ],
        ),
        // height: 150,
        // width: 50,
      ),
    );
  }
}
