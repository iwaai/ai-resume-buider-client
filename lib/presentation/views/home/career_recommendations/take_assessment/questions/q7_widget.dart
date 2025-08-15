import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class Q7Widget extends StatelessWidget {
  const Q7Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[6].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Expanded(
                child: DialogSelectionTile(
                  text: 'Science',
                  selected: state
                          .answers[state.careerRecommendationQuestions[6].id] ==
                      "Science",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[6].id, 'Science'));
                  },
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: DialogSelectionTile(
                  text: 'History',
                  selected: state
                          .answers[state.careerRecommendationQuestions[6].id] ==
                      "History",
                  onTap: () {
                    context.read<TakeAssessmentBloc>().add(SetAnswer(
                        state.careerRecommendationQuestions[6].id, 'History'));
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[6].id] !=
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
