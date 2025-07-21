part of '../my_library.dart';

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
      padding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 16.5.w),
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
