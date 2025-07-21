import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/career_recomm_models.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class CareerRecommendationCard extends StatelessWidget {
  final CareerRecommendation careerRecommendation;
  final bool isLibrary;
  final Function() onTapFwd;
  final Function() onTapLike;

  const CareerRecommendationCard({
    super.key,
    required this.careerRecommendation,
    required this.isLibrary,
    required this.onTapFwd,
    required this.onTapLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Career\nRecommendations',
                  style: context.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: onTapLike,
                  icon: Image.asset(
                      color: careerRecommendation.isFavorite
                          ? AppColors.secondaryColor
                          : AppColors.grey,
                      height: 27.h,
                      width: 20.w,
                      AssetConstants.favouriteStartIcon),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
                children: List.generate(
                    careerRecommendation.careers.length,
                    (i) => RecommendationTextBox(
                        recommendationText:
                            careerRecommendation.careers[i].career.name))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDate(careerRecommendation.createdAt),
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ),
                  GestureDetector(
                    onTap: onTapFwd,
                    child: Container(
                      padding: EdgeInsets.all(15.sp),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Icon(
                        size: 15.sp,
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecommendationTextBox extends StatelessWidget {
  const RecommendationTextBox({
    super.key,
    required this.recommendationText,
  });

  final String recommendationText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.18),
        ),
      ),
      child: Text(
        recommendationText,
        style:
            context.textTheme.bodySmall?.copyWith(color: AppColors.blackColor),
      ),
    );
  }
}
