import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class Q19Widget extends StatelessWidget {
  const Q19Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[18].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Expanded(
                child: DialogSelectionTile(
                  text: 'Physical challenge',
                  selected: state.answers[
                          state.careerRecommendationQuestions[18].id] ==
                      "Physical challenge",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[18].id,
                        'Physical challenge'));
                  },
                ),
              ),
              Expanded(
                child: DialogSelectionTile(
                  text: 'Mental challenge',
                  selected: state.answers[
                          state.careerRecommendationQuestions[18].id] ==
                      "Mental challenge",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[18].id,
                        'Mental challenge'));
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[18].id] !=
                    null) {
                  context.read<TakeAssessmentBloc>().add(NextStep());
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
