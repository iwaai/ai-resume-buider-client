import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/assessment_stepper.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions_renderer.dart';
import 'package:second_shot/utils/extensions.dart';

class TakeAssessmentScreen extends StatelessWidget {
  const TakeAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CareerRecommendationsBloc careerRecommendationsBloc =
        GoRouter.of(context).state!.extra as CareerRecommendationsBloc;
    return BlocProvider(
      create: (context) => TakeAssessmentBloc(careerRecommendationsBloc)
        ..add(GetCareerRecommendationQuestions()),
      child: BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
          builder: (context, state) {
        return IgnorePointer(
          ignoring: state.loading,
          child: ScaffoldWrapper(
            child: Scaffold(
              appBar: const CustomAppBar(
                titleSpacing: 0,
                title: 'Career Recommendation Assessment',
                // onClick: () {
                //   if (state.step == 1) {
                //     // Navigate to previous screen
                //     context.pop();
                //   } else {}
                // },
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w)
                    .copyWith(bottom: 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please answer a few questions to help us tailor our services to your needs. You may feel like you align to multiple answers. Choose the answer that feels most like you. It\'s usually your first thought.',
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    const AssessmentStepper(),
                    SizedBox(
                      height: 16.h,
                    ),
                    Expanded(
                        child: state.loading &&
                                state.careerRecommendationQuestions.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const QuestionsRenderer()),
                    SizedBox(
                      height: 16.h,
                    ),
                    if (state.step > 1)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<TakeAssessmentBloc>()
                                .add(PreviousStep());
                          },
                          child: Text(
                            'Back',
                            style: context.textTheme.bodyMedium!.copyWith(
                              decorationThickness: 0.6,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                              decorationColor: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
