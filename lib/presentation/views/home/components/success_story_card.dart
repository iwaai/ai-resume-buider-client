import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/stories_model.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class SucessStoryCard extends StatefulWidget {
  const SucessStoryCard({super.key, required this.storyModel});

  final StoryModel storyModel;

  @override
  State<SucessStoryCard> createState() => _SucessStoryCardState();
}

class _SucessStoryCardState extends State<SucessStoryCard> {
  bool _toggler = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.ontap,
      onLongPress: _onFlipCardPressed,
      child: FlipCard(
          toggler: _toggler, backCard: _backCard(), frontCard: _frontCard()),
    );
  }

  Widget _backCard() {
    return SizedBox(
      width: double.infinity,
      height: 192.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: 145.h,
            decoration: BoxDecoration(
                color: const Color(0xFFF2F7FF),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.horizontalPadding / 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _launchURL(widget.storyModel.youtubeLink),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.redColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.asset(
                          AssetConstants.youtubeIcon,
                          width: 65.w,
                          height: 16.h,
                        )),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Quote: ${widget.storyModel.pieceOfAdvice}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2.h),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(widget.storyModel.linkedIn),
                    child: Image.asset(
                      AssetConstants.linkedin,
                      height: 24,
                      width: 24,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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

  Widget _frontCard() {
    return Container(
      width: double.infinity.w,
      height: 192.h,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity.w,
            height: 145.h,
            decoration: BoxDecoration(
                color: const Color(0xFFF2F7FF),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.horizontalPadding / 2.h),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    widget.storyModel.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'First Shot: ${widget.storyModel.profession}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2.h),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Second Shot: ${widget.storyModel.profession2}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2.h),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'School: ${widget.storyModel.school}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.2.h),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 94.w, // Image width
              height: 94.h, // Image height
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.whiteColor, width: 0.5.w),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      widget.storyModel.profileImg.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onFlipCardPressed() {
    setState(() {
      _toggler = !_toggler;
    });
  }
}

class FlipCard extends StatelessWidget {
  final bool toggler;
  final Widget frontCard;
  final Widget backCard;

  const FlipCard({
    required this.toggler,
    required this.backCard,
    required this.frontCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease.flipped,
        child: toggler
            ? SizedBox(key: const ValueKey('front'), child: frontCard)
            : SizedBox(key: const ValueKey('back'), child: backCard),
      ),
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnimation = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnimation,
      child: widget,
      builder: (context, widget) {
        final isFront = ValueKey(toggler) == widget!.key;
        final rotationY = isFront
            ? rotateAnimation.value
            : min(rotateAnimation.value, pi * 0.5);
        return Transform(
          transform: Matrix4.rotationY(rotationY)..setEntry(3, 0, 0),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
