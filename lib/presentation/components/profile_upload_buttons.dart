import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';

class CustomPickerButton extends StatelessWidget {
  const CustomPickerButton(
      {super.key,
      required this.title,
      required this.ontap,
      this.bottomLeft,
      this.bottomRight,
      this.topLeft,
      this.topRight});
  final String title;

  final VoidCallback ontap;
  final double? topLeft;
  final double? topRight;
  final double? bottomRight;
  final double? bottomLeft;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeft ?? 0),
                  topRight: Radius.circular(topRight ?? 0),
                  bottomLeft: Radius.circular(bottomLeft ?? 0),
                  bottomRight: Radius.circular(bottomRight ?? 0)),
              color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.lightBlueColor,
                fontSize: 20.sp,
              ),
            ),
          ),
        ));
  }
}
