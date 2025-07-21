import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/models/get_resume_model.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
// import 'package:second_shot/services/pdf_generation.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../services/resume_pdf_generator.dart';
import '../../utils/constants/assets.dart';
import '../theme/theme_utils/app_colors.dart';
import 'custom_snackbar.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({
    super.key,
    required this.resumeModel,
  });

  final ResumeModel resumeModel;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Choose Your File Format',
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
            children: List.generate(
          2,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex != index) {
                    selectedIndex = index;
                  } else {
                    selectedIndex = -1;
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: index.isEven
                    ? EdgeInsets.only(right: 5.w)
                    : EdgeInsets.only(left: 5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                      color: selectedIndex == index
                          ? AppColors.primaryColor
                          : AppColors.borderGrey.withOpacity(0.7)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: 24.h,
                        width: 24.w,
                        padding: EdgeInsets.all(3.sp),
                        margin: EdgeInsets.all(3.sp),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedIndex == index
                                    ? Colors.transparent
                                    : AppColors.borderGrey.withOpacity(0.7)),
                            shape: BoxShape.circle,
                            color: selectedIndex == index
                                ? AppColors.primaryColor
                                : Colors.transparent),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: selectedIndex == index
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.whiteColor,
                                  size: 16.sp,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(24.sp).copyWith(top: 12.h),
                      child: Column(
                        children: [
                          Image.asset(
                            AssetConstants.resumeDoc,
                            color: AppColors.primaryColor,
                            scale: 2,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                              overflow: TextOverflow.ellipsis,
                              index.isEven
                                  ? 'Word (Doc) File'
                                  : 'PDF (Doc) File',
                              style: context.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.blackColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
        SizedBox(
          height: 10.h,
        ),
        PrimaryButton(
            onPressed: () async {
              if (selectedIndex == 0) {
                // Code to download Word file
                // generateWordDocument(widget.resumeModel);
                // context.pop();
              } else if (selectedIndex == 1) {
                await generateAndDownloadPdf(widget.resumeModel);
                SnackbarsType.success(
                    context, 'Resume Downloaded Successfully!');
                context.pop();
              } else {
                SnackbarsType.error(context, 'Please select your file format!');
              }
            },
            text: 'Download')
      ],
    );
  }
}
