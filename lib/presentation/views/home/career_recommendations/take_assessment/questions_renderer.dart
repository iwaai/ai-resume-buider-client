import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/take_assessment/take_assessment_bloc.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q10_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q11_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q12_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q13_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q14_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q15_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q16_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q17_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q18_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q19_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q1_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q20_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q21_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q22_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q23_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q24_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q2_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q3_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q4_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q5_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q6_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q7_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q8_widget.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/take_assessment/questions/q9_widget.dart';

class QuestionsRenderer extends StatelessWidget {
  const QuestionsRenderer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakeAssessmentBloc, TakeAssessmentState>(
        builder: (context, state) {
      switch (state.step) {
        case 1:
          return const Q1Widget();
        case 2:
          return const Q2Widget();
        case 3:
          return const Q3Widget();
        case 4:
          return const Q4Widget();
        case 5:
          return const Q5Widget();
        case 6:
          return const Q6Widget();
        case 7:
          return const Q7Widget();
        case 8:
          return const Q8Widget();
        case 9:
          return const Q9Widget();
        case 10:
          return const Q10Widget();
        case 11:
          return const Q11Widget();
        case 12:
          return const Q12Widget();
        case 13:
          return const Q13Widget();
        case 14:
          return const Q14Widget();
        case 15:
          return const Q15Widget();
        case 16:
          return const Q16Widget();
        case 17:
          return const Q17Widget();
        case 18:
          return const Q18Widget();
        case 19:
          return const Q19Widget();
        case 20:
          return const Q20Widget();
        case 21:
          return const Q21Widget();
        case 22:
          return const Q22Widget();
        case 23:
          return const Q23Widget();
        case 24:
          return const Q24Widget();
        default:
          return const SizedBox();
      }
    });
  }
}
