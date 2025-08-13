import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/stories_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessProfileDetail extends StatelessWidget {
  const SuccessProfileDetail({super.key, required this.successStory});

  final StoryModel successStory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.h,
              padding: EdgeInsets.only(bottom: 32.h),
              child: CustomTopAppBar(
                storyModel: successStory,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r))),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 16.h),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      "${successStory.profession}",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(8),
                    Text("${successStory.currentProfession}",
                        style: context.textTheme.bodyLarge?.copyWith(
                            fontSize: 14.sp, color: AppColors.blackColor)),
                    Constant.verticalSpace(10.h),
                    const Divider(),
                    Constant.verticalSpace(10.h),
                    Text(
                      "Education",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(8.h),
                    Text(
                      "${successStory.education}",
                      style: context.textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp, color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(10.h),
                    const Divider(),
                    Constant.verticalSpace(10.h),
                    Text(
                      "Experience",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(8.h),
                    Text(
                      "${successStory.experience}",
                      style: context.textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp, color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(10.h),
                    const Divider(),
                    Constant.verticalSpace(10.h),
                    Text(
                      "Can you identify your most valuable transferable skill, and how have you seen it manifest in different areas of your life?\n",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(8.h),
                    Text(
                      "${successStory.mostValuableTransferableSkill}",
                      style: context.textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp, color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(10.h),
                    const Divider(),
                    Constant.verticalSpace(10.h),
                    Text(
                      "If you could give one piece of advice to your younger self, what would it be, and why?\n",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.blackColor),
                    ),
                    Text(
                      "${successStory.pieceOfAdvice}",
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp, color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(20.h),
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}

class AcheiveText extends StatelessWidget {
  const AcheiveText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text. Lorem ipsum dolor sit amet consectetur. Nunc aliquet diam quam vitae non tincidunt turpis.",
      style: context.textTheme.bodyLarge
          ?.copyWith(fontSize: 14.sp, color: AppColors.grey),
    );
  }
}

class CustomTopAppBar extends StatelessWidget {
  const CustomTopAppBar({super.key, required this.storyModel});

  final StoryModel storyModel;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      backIconColor: AppColors.whiteColor,
      titleWidget: Text(
        "Profile Detail",
        style: context.textTheme.titleMedium
            ?.copyWith(fontSize: 16.sp, color: AppColors.whiteColor),
      ),
      bottomWidget: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Constant.horizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 31,
                backgroundImage: NetworkImage("${storyModel.profileImg}"),
              ),
              Constant.horizontalSpace(12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${storyModel.name}",
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge?.copyWith(
                          fontSize: 15.sp, color: AppColors.whiteColor),
                    ),
                    Constant.verticalSpace(6),
                    Text(
                      "${storyModel.profession}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                          fontSize: 12.sp, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
              Constant.horizontalSpace(12.h),
              GestureDetector(
                onTap: () => _launchURL(storyModel.youtubeLink),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppColors.redColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      AssetConstants.youtubeIcon,
                      width: 65.w,
                      height: 16.h,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint("Invalid URL");
      return;
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }
}
