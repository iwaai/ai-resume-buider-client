import 'package:flutter/material.dart';
import 'package:second_shot/utils/extensions.dart';

class RegistrationStepQuestionsText extends StatelessWidget {
  final String text;
  const RegistrationStepQuestionsText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleMedium,
    );
  }
}
