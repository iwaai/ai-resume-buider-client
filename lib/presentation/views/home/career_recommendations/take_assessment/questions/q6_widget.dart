import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class Q6Widget extends StatelessWidget {
  const Q6Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[5].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Expanded(
                child: DialogSelectionTile(
                  text: 'Reading',
                  selected: state
                          .answers[state.careerRecommendationQuestions[5].id] ==
                      "Reading",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[5].id, 'Reading'));
                  },
                ),
              ),
              Expanded(
                child: DialogSelectionTile(
                  text: 'Math',
                  selected: state
                          .answers[state.careerRecommendationQuestions[5].id] ==
                      "Math",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[5].id, 'Math'));
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[5].id] !=
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
