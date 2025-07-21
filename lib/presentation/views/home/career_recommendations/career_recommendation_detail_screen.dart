import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/career_category_tile.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/career_details_texts.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerRecommendationDetailScreen extends StatelessWidget {
  const CareerRecommendationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = GoRouter.of(context).state.extra as CareerRecommendationsBloc;
    return BlocProvider.value(
      value: args,
      child: ScaffoldWrapper(
        showChatbot: true,
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Your Recommended Careers',
            bottomWidget: PreferredSize(
              preferredSize: Size(0, 50.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.h),
                child: const Text(
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    'There are your recommended careers in no particular order.'),
              ),
            ),
          ),
          body: BlocConsumer<CareerRecommendationsBloc,
              CareerRecommendationsState>(listener: (context, state) {
            if (state.result != null) {
              if (state.result!.event is MarkACareerFavorite &&
                  state.result!.status == ResultStatus.successful) {
                SnackbarsType.success(context, state.result!.message);
              }
            }
          }, builder: (context, state) {
            final selectedRecommendation = state.selectedRecommendation;
            final selectedCareer = state.selectedCareer.career;
            final selectedCareerPoint = state.selectedCareer;
            return state.detailsLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp)
                            .copyWith(bottom: 16.h, top: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CareerCategoryTile(
                                        title: selectedRecommendation
                                            .careers[i].career.name,
                                        selected: selectedCareer.name ==
                                            selectedRecommendation
                                                .careers[i].career.name,
                                        onTap: () {
                                          context
                                              .read<CareerRecommendationsBloc>()
                                              .add(OnSelectACareerInViewDetails(
                                                  career: selectedRecommendation
                                                      .careers[i]));
                                        }),
                                  );
                                },
                                itemCount:
                                    selectedRecommendation.careers.length,
                                separatorBuilder: (c, i) {
                                  return SizedBox(width: 8.w);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                              child: Divider(
                                color: AppColors.blackColor,
                                thickness: 1.sp,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Swipe to see more careers'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CareerDetailsHeading(
                                        title: selectedCareer.name,
                                      ),
                                      Text(
                                        formatDate(
                                            selectedRecommendation.createdAt),
                                        style: context.textTheme.titleMedium!
                                            .copyWith(
                                                color:
                                                    AppColors.secondaryColor),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    args.add(MarkACareerFavorite(
                                        careerRecommendationId:
                                            selectedRecommendation
                                                .recommendationId,
                                        careerId: selectedCareerPoint.career.id,
                                        fromLibrary:
                                            selectedRecommendation.favoriteID !=
                                                null));
                                    if (selectedRecommendation.careers.length ==
                                        1) {
                                      context.pop();
                                    }
                                    // Recommendation Would Disappear from favourite list
                                  },
                                  icon: Image.asset(
                                      color: selectedCareerPoint.isFavorite
                                          ? AppColors.secondaryColor
                                          : AppColors.grey,
                                      height: 27.h,
                                      width: 20.w,
                                      AssetConstants.favouriteStartIcon),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CareerDetailsGreyText(
                                text: selectedCareer.description ?? ""),
                            SizedBox(
                              height: 16.h,
                              child: Divider(
                                color: AppColors.blackColor.withOpacity(.1),
                                thickness: 1.sp,
                              ),
                            ),
                            const CareerDetailsHeading(
                              title: 'Sample Job Titles',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (c, i) {
                                  return CareerBulletedText(
                                      text: selectedCareer.sampleJobTitles[i]);
                                },
                                separatorBuilder: (c, i) {
                                  return SizedBox(
                                    height: 8.h,
                                  );
                                },
                                itemCount:
                                    selectedCareer.sampleJobTitles.length),
                            SizedBox(
                              height: 16.h,
                              child: Divider(
                                color: AppColors.blackColor.withOpacity(.1),
                                thickness: 1.sp,
                              ),
                            ),
                            const CareerDetailsHeading(
                              title: 'Career Pathways',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (c, i) {
                                  return CareerBulletedText(
                                      text: selectedCareer.careerPathways[i]);
                                },
                                separatorBuilder: (c, i) {
                                  return SizedBox(
                                    height: 8.h,
                                  );
                                },
                                itemCount:
                                    selectedCareer.careerPathways.length),
                            SizedBox(
                              height: 16.h,
                              child: Divider(
                                color: AppColors.blackColor.withOpacity(.1),
                                thickness: 1.sp,
                              ),
                            ),
                            const CareerDetailsHeading(
                              title: 'Education & Training',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            const CareerDetailsGreyText(
                              text:
                                  'Depending on specific path, individual can peruse various level of education and training, such as.',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (c, i) {
                                  return CareerBulletedText(
                                      text:
                                          selectedCareer.educationTraining[i]);
                                },
                                separatorBuilder: (c, i) {
                                  return SizedBox(
                                    height: 8.h,
                                  );
                                },
                                itemCount:
                                    selectedCareer.educationTraining.length),
                            SizedBox(
                              height: 16.h,
                              child: Divider(
                                color: AppColors.blackColor.withOpacity(.1),
                                thickness: 1.sp,
                              ),
                            ),
                            const CareerDetailsHeading(
                              title: 'Career Growth and Opportunities',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            CareerDetailsGreyText(
                                text:
                                    selectedCareer.careerGrowthOpportunities ??
                                        ''),
                            SizedBox(
                              height: 8.h,
                            ),
                            const CareerDetailsHeading(
                              title: 'Explore More',
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchURL(selectedCareer.careerLink);
                              },
                              child: Text(
                                selectedCareer.careerLink ?? "",
                                style: context.textTheme.titleMedium!.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppColors.uploadButtonColor,
                                    color: AppColors.uploadButtonColor),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
          }),
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
