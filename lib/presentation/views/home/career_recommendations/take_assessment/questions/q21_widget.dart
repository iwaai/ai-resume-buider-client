import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class Q21Widget extends StatelessWidget {
  const Q21Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[20].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Expanded(
                child: DialogSelectionTile(
                  text: 'Keep trying',
                  selected: state.answers[
                          state.careerRecommendationQuestions[20].id] ==
                      "Keep trying",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[20].id,
                        'Keep trying'));
                  },
                ),
              ),
              Expanded(
                child: DialogSelectionTile(
                  text: 'Try something else',
                  selected: state.answers[
                          state.careerRecommendationQuestions[20].id] ==
                      "Try something else",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[20].id,
                        'Try something else'));
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[20].id] !=
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
