import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';

class Q10Widget extends StatelessWidget {
  const Q10Widget({super.key});

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
              text: 'Please list your desired career.',
            ),
            SizedBox(
              height: 8.h,
            ),
            PrimaryTextField(
              characterLimit: 150,
              maxLines: 6,
              hintText: 'Enter Your Answer',
              onChanged: (v) {
                context
                    .read<RegistrationQuestionsBloc>()
                    .add(UpdateQ10CareerEvent(v));
              },
              initialValue: state.q10Career,
            ),
            SizedBox(
              height: 20.h,
            ),
            PrimaryButton(
                text: 'Finish',
                loading: state.loading && state.q10Career != null,
                onPressed: () {
                  if (state.q10Career != null && state.q10Career!.isNotEmpty) {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(SubmitEvent());
                  } else {
                    SnackbarsType.error(context, 'Please select your answers!');
                  }
                })
          ],
        );
      },
    );
  }
}
