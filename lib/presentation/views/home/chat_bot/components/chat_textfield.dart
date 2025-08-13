import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/constants/assets.dart';
import '../../../../theme/theme_utils/app_colors.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {super.key, required this.onSend, required this.controller});

  final Function() onSend;
  final TextEditingController controller;
  final outlinedBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(28)));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0.sp).copyWith(bottom: 20.h),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onSend,
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Image.asset(
                AssetConstants.sendButtonIcon,
                height: 38.h,
                width: 38.w,
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(18.0.sp),
          hintText: 'Type here...',
          hintStyle: TextStyle(color: AppColors.blackColor.withOpacity(0.5)),
          filled: true,
          fillColor: AppColors.chatTextFieldColor.withOpacity(0.5),
          border: outlinedBorder,
          focusedBorder: outlinedBorder,
          enabledBorder: outlinedBorder,
        ),
      ),
    );
  }
}
