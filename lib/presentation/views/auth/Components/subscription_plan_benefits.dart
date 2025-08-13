import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme_utils/app_colors.dart';

class SubscriptionPlanBenefits extends StatelessWidget {
  const SubscriptionPlanBenefits({
    super.key,
    required this.selectedPlanIndex,
    required this.duration,
  });

  final int selectedPlanIndex;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(selectedPlanIndex, (i) {
        return Row(
          children: [
            Icon(
              Icons.check,
              color: AppColors.secondaryColor,
              size: 18.sp,
            ),
            SizedBox(width: 6.w),
            Expanded(
                child: Text(
              _planBenefits(i),
              style: const TextStyle(color: AppColors.whiteColor),
            ))
          ],
        );
      }),
    );
  }

  String _planBenefits(int index) {
    switch (index) {
      case 0:
        return "Discover Your Transferable Skills";
      case 1:
        return "Find Your Career Match";
      case 2:
        return "Build Your Resume";
      case 3:
        return "Establish Clear and Actionable Goals";
      case 4:
        return "View Success Stories";
      case 5:
        return "Individual Development Plan";
      case 6:
        return "$duration Access";
      default:
        return "";
    }
  }
}
