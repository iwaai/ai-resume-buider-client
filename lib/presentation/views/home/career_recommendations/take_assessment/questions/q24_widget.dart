import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/common_dialogue_2.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';

class Q24Widget extends StatelessWidget {
  const Q24Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TakeAssessmentBloc, TakeAssessmentState>(
        listener: (context, state) {
      if (state.result.status == ResultStatus.successful &&
          state.result.event is Save) {
        CommonDialog(
          title: 'You have successfully completed the assessment',
          body:
              '''You’ve been matched with five potential careers! Take a moment to click through each one and explore sample job titles, career pathways, and recommended education.

Be sure to mark your favorites so you can save them in your library. This way, you’ll have easy access to revisit and review them later.

If you’re interested in exploring even more career options, you can always retake the assessment for additional matches.''',
          image: AssetConstants.assessmentCompleteDialog,
          okBtnText: 'Explore Career Recommendations',
          barrierDismissible: false,
          okBtnFunction: () {
            context.read<TakeAssessmentBloc>().add(Reset());
            context
                .read<TakeAssessmentBloc>()
                .careerRecommendationsBloc
                .add(GetCareerRecommendations());
            context.pushReplacement(AppRoutes.careerRecommendationsDetails,
                extra: context
                    .read<TakeAssessmentBloc>()
                    .careerRecommendationsBloc);
          },
          imageHeight: 104.h,
          additionalButton: PrimaryButton(
            onPressed: () {
              context.read<TakeAssessmentBloc>().add(Reset());
              context.pop();
            },
            text: 'Retake Assessment',
            textColor: AppColors.primaryColor,
            buttonColor: AppColors.buttonGrey,
          ),
        ).showCustomDialog(context);
      }
      if (state.result.status == ResultStatus.error &&
          state.result.event is Save) {
        SnackbarsType.error(context, state.result.message);
      }
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[23].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: List.generate(
              5,
              (index) {
                int i = index + 1;
                return Expanded(
                  child: DialogSelectionTile(
                    text: i.toString(),
                    selected: state.answers[
                            state.careerRecommendationQuestions[23].id] ==
                        i,
                    onTap: () {
                      context.read<TakeAssessmentBloc>().add(SetAnswer(
                          state.careerRecommendationQuestions[23].id, i));
                    },
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          PrimaryButton(
              loading: state.loading,
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[23].id] !=
                    null) {
                  context.read<TakeAssessmentBloc>().add(Save());
                } else {
                  SnackbarsType.error(context, 'Please Select an Answer');
                }
              },
              text: 'Next')
        ],
      );
    });
  }
}
