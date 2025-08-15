import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';

class Q2Widget extends StatelessWidget {
  const Q2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.h,
          ),
          const RegistrationStepQuestionsText(
            text: 'What is your highest level of degree completion?',
          ),
          SizedBox(
            height: 8.h,
          ),
          PrimaryTextField(
            characterLimit: 150,
            initialValue: state.q2Answer,
            hintText: 'Describe Here',
            maxLines: 6,
            onChanged: (v) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(UpdateQ2AnswerEvent(v));
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          PrimaryButton(
            text: 'Next',
            onPressed: () {
              if (state.q2Answer != null && state.q2Answer!.isNotEmpty) {
                print(state.q2Answer);
                context.read<RegistrationQuestionsBloc>().add(NextStepEvent());
              } else {
                SnackbarsType.error(context, 'Please select your answers!');
              }
            },
          ),
        ],
      );
    });
  }
}
