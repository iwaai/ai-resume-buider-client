import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_dropdown.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/components/take_assessment_question.dart';
import 'package:second_shot/utils/enums.dart';

class Q5Widget extends StatelessWidget {
  const Q5Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeAssessmentQuestion(
            question: state.careerRecommendationQuestions[4].question,
          ),
          SizedBox(
            height: 8.h,
          ),
          PrimaryDropdown(
            options: SkillEnums.values.toList(),
            initialValue:
                state.answers[state.careerRecommendationQuestions[4].id],
            hintText: 'Select Your Answer',
            maxHeightAfterOpen: 250.h,
            onChanged: (newValue) {
              context.read<TakeAssessmentBloc>().add(
                    SetAnswer(
                        state.careerRecommendationQuestions[4].id, newValue),
                  );
            },
          ),
          const Spacer(),
          PrimaryButton(
              onPressed: () {
                if (state.answers[state.careerRecommendationQuestions[4].id] !=
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
