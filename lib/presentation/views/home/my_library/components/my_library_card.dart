import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/career_recomm_models.dart';
import 'package:second_shot/models/library_model.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../../blocs/home/my_library/my_library_bloc.dart';
import '../../../../../blocs/home/transferable_skills/transferable_skills_bloc.dart';
import '../../../../../utils/constants/assets.dart';
import '../../../../components/career_recommendation_card.dart';
import '../../../../theme/theme_utils/app_colors.dart';

class MyLibraryCard extends StatelessWidget {
  const MyLibraryCard(
      {super.key, this.isCareer = true, this.model, this.careerRecommendation});

  final bool isCareer;
  final CustomLibraryModel? model;
  final CareerRecommendation? careerRecommendation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Card(
        color: AppColors.lightCream,
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
                  Expanded(
                    child: Text(
                      isCareer ? 'Career\nRecommendations' : '${model?.title}',
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (isCareer) {
                        } else {
                          context.read<MyLibraryBloc>().add(
                                LibraryToggleLikeEvent(
                                  nodeId: model?.nodeId ?? 'node_id',
                                  descriptionId:
                                      model?.descriptionId ?? 'node_id',
                                  nodeName: model?.nodeName ?? ShowNode.none,
                                  // nodeName: model?.nodeName ?? 'node_name',
                                ),
                              );
                        }
                      },
                      icon: Image.asset(
                        color: AppColors.secondaryColor,
                        height: 27.h,
                        width: 20.w,
                        AssetConstants.favouriteStartIcon,
                      ))
                ],
              ),
              SizedBox(height: isCareer ? 16.h : null),
              isCareer && careerRecommendation != null
                  ? Wrap(
                      children: List.generate(
                          careerRecommendation!.careers.length,
                          (i) => RecommendationTextBox(
                              recommendationText: careerRecommendation!
                                  .careers[i].career.name)))
                  : Text(
                      softWrap: true,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.blackColor,
                      ),
                      '${model?.description}. '),
              SizedBox(height: isCareer ? 0 : 10.h),
              if (isCareer && careerRecommendation != null)
                Text(
                  formatDate(careerRecommendation!.createdAt),
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                )

              /// Use This Container Arrow Box In Career Recommendations Section
              // Container(
              //   padding: EdgeInsets.all(15.sp),
              //   margin: EdgeInsets.only(top: 14.h),
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //       gradient: AppColors.primaryGradient,
              //       borderRadius: BorderRadius.circular(8.r)),
              //   child: Icon(
              //     size: 15.sp,
              //     Icons.arrow_forward_ios_outlined,
              //     color: AppColors.whiteColor,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
