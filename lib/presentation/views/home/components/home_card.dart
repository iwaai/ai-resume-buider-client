import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../blocs/home/home_bloc.dart';
import '../../../../utils/constants/assets.dart';
import '../../../router/route_constants.dart';
import '../../../theme/theme_utils/app_colors.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({
    super.key,
    required this.index,
    required this.outerContext,
  });

  final int index;
  final BuildContext outerContext;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Map<String, dynamic> cardContent = {};

  @override
  void initState() {
    super.initState();
    cardContent = _getCardDetails(widget.index);
  }

  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 12.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: cardContent['cardGradient']),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Image
              Container(
                padding: EdgeInsets.all(5.sp),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Image.asset(
                  height: 28.h,
                  width: 32.w,
                  cardContent['logoImage'],
                ),
              ),
              SizedBox(width: 10.w),
              // Title Text
              Text(
                cardContent['title'].toUpperCase(),
                style: context.textTheme.headlineSmall
                    ?.copyWith(color: AppColors.whiteColor, fontSize: 18.sp),
              )
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Description Text
              if (cardContent['description'] != null)
                Expanded(
                  child: Text(
                    textAlign: TextAlign.start,
                    cardContent['description'],
                    style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500),
                    softWrap: true,
                  ),
                ),
              // Image
              Expanded(
                child: Image.asset(
                  height: 130.h,
                  cardContent['image'],
                ),
              )
            ],
          ),
          SizedBox(height: 8.h),
          // Launch Button
          cardButton()
        ],
      ),
    );
  }

  Widget cardButton() {
    return cardContent['isComingSoon']
        ? GestureDetector(
            onTap: () {
              Constant.showComingSoonDialog(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColors.whiteColor.withOpacity(0.25),
              ),
              child: Text(
                'COMING SOON',
                style: context.textTheme.titleSmall?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        : BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  if (context.read<AppBloc>().state.user.isSubscriptionPaid ==
                          false &&
                      cardContent['screen'] != AppRoutes.transferableSkills) {
                    Constant.showSubscriptionDialog(context);
                  } else {
                    context
                        .read<HomeBloc>()
                        .add(Unlock(screen: cardContent['screen']));
                    context.push(cardContent['screen'],
                        extra: cardContent['bloc']);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: state.dialogShown.contains(cardContent['screen']) ==
                                false &&
                            cardContent['screen'] !=
                                AppRoutes.transferableSkills
                        ? AppColors.homeCardButtonColor
                        : AppColors.whiteColor.withOpacity(0.25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!state.dialogShown.contains(cardContent['screen']) ||
                          (context
                                      .read<AppBloc>()
                                      .state
                                      .user
                                      .isSubscriptionPaid ==
                                  false &&
                              cardContent['screen'] !=
                                  AppRoutes.transferableSkills))
                        Image.asset(
                          AssetConstants.lockIcon,
                          scale: 7.sp,
                        ),
                      SizedBox(width: 4.w),
                      Text(
                        getTitle(cardContent, state),
                        style: context.textTheme.titleSmall?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  String getTitle(Map<String, dynamic> cardContent, HomeState state) {
    final screen = cardContent['screen'];
    final isSubscribed = context.read<AppBloc>().state.user.isSubscriptionPaid;

    if (screen == AppRoutes.transferableSkills && !isSubscribed) {
      return 'TRY IT FOR FREE';
    } else if (!state.dialogShown.contains(screen) || !isSubscribed) {
      return 'UNLOCK';
    } else {
      return 'LAUNCH';
    }
  }

  Map<String, dynamic> _getCardDetails(int index) {
    switch (index) {
      // case 0:
      //   return {
      //     'isComingSoon': false,
      //     "title": 'Transferable Skills',
      //     "description":
      //         '''Discover the valuable skills you've acquired. Explore how to use them to shape your future and apply them across different areas of your life.''',
      //     "logoImage": AssetConstants.transferrableSkillsLogo,
      //     "image": AssetConstants.transferrableSkillsImage,
      //     "screen": AppRoutes.transferableSkills,
      //     "cardGradient": AppColors.homeGradient(
      //         color1: AppColors.transferableSkillsDark,
      //         color2: AppColors.transferableSkillsLight)
      //   };
      // case 1:
      //   return {
      //     'isComingSoon': false,
      //     "title": 'Career Recommendation',
      //     "description":
      //         '''Take a short assessment to receive recommended careers, sample job descriptions, and recommended pathways to success. You will receive 5 career matches.''',
      //     "logoImage": AssetConstants.careerRecommendationsLogo,
      //     "image": AssetConstants.careerRecommendationsImage,
      //     "screen": AppRoutes.careerRecommendations,
      //     'bloc': widget.outerContext.read<CareerRecommendationsBloc>(),
      //     "cardGradient": AppColors.homeGradient(
      //         color1: AppColors.careerRecommDark,
      //         color2: AppColors.careerRecommLight),
      //   };
      case 0:
        return {
          'isComingSoon': false,
          "title": 'Resume Builder',
          "description":
              '''Use this template to build your resume and stand out from your competition.''',
          "logoImage": AssetConstants.resumeBuilderLogo,
          "image": AssetConstants.resumeBuilderImage,
          "screen": AppRoutes.resumeBuilder,
          'bloc': widget.outerContext.read<MyLibraryBloc>(),
          "cardGradient": AppColors.homeGradient(
              color1: AppColors.resumeBuilderDark,
              color2: AppColors.resumeBuilderLight),
        };
      // case 3:
      //   return {
      //     'isComingSoon': false,
      //     "title": 'Goal Setting',
      //     'bloc': widget.outerContext.read<GoalsBloc>(),
      //     "description":
      //         '''Establish a clear action plan to turn your goals into reality. This goal setting provides focus, drives motivation, keeps you accountable and offers a roadmap for success.''',
      //     "logoImage": AssetConstants.goalSettingLogo,
      //     "image": AssetConstants.goalSettingImage,
      //     "screen": AppRoutes.goalSettings,
      //     "cardGradient": AppColors.homeGradient(
      //         color1: AppColors.goalSettingDark,
      //         color2: AppColors.goalSettingLight),
      //   };
      // case 4:
      //   return {
      //     'isComingSoon': false,
      //     "title": 'Success Stories',
      //     "description":
      //         '''Explore success stories from individuals who have similar experiences and share your interests.''',
      //     "logoImage": AssetConstants.successStoriesLogo,
      //     "image": AssetConstants.successStoriesImage,
      //     "screen": AppRoutes.successStories,
      //     'bloc': widget.outerContext.read<SuccessStoriesBloc>(),
      //     "cardGradient": AppColors.homeGradient(
      //         color1: AppColors.successStoriesDark,
      //         color2: AppColors.successStoriesLight),
      //   };
      // case 5:
      //   return {
      //     'isComingSoon': false,
      //     "title": 'Personal Plan',
      //     "description":
      //         '''Mark and save your favorite skills and careers for quick reference.''',
      //     "logoImage": AssetConstants.myLibraryLogo,
      //     "image": AssetConstants.myLibraryImage,
      //     "screen": AppRoutes.myLibrary,
      //     'bloc': widget.outerContext.read<MyLibraryBloc>(),
      //     "cardGradient": AppColors.homeGradient(
      //         color1: AppColors.myLibraryDark,
      //         color2: AppColors.myLibraryLight),
      //   };
      // case 6:
      //   return {
      //     'isComingSoon': true,
      //     "title": 'Branding/Nil',
      //     "logoImage": AssetConstants.communityLogo,
      //     "image": AssetConstants.communityImage,
      //     "cardGradient": AppColors.communityServiceGradient,
      //   };
      // case 7:
      //   return {
      //     'isComingSoon': true,
      //     "title": 'Mock Interview',
      //     "logoImage": AssetConstants.mockInterviewLogo,
      //     "image": AssetConstants.mockInterviewImage,
      //     "cardGradient": AppColors.mockInterviewGradient,
      //   };
      // case 8:
      //   return {
      //     'isComingSoon': true,
      //     "title": 'Entrepreneurship',
      //     "logoImage": AssetConstants.entrepreneurshipLogo,
      //     "image": AssetConstants.entrepreneurshipImage,
      //     "cardGradient": AppColors.entrepreneurshipGradient,
      //   };
      default:
        throw Exception("Invalid index: $index");
    }
  }
}
