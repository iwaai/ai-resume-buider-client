import 'package:flutter/material.dart';
import 'package:second_shot/utils/extensions.dart';

class TakeAssessmentQuestion extends StatelessWidget {
  final String question;
  const TakeAssessmentQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Text(
      question,
      textAlign: TextAlign.left,
      style: context.textTheme.titleMedium,
    );
  }
}
