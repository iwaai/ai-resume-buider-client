import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/utils/enums.dart';

class Q9Widget extends StatelessWidget {
  const Q9Widget({super.key});

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
              text: 'Do you have prior work experience?',
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.Yes.name,
                    selected: state.q9Answer == true,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ9AnswerEvent(true));
                    },
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.No.name,
                    selected: state.q9Answer == false,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ9AnswerEvent(false));
                    },
                  ),
                ),
              ],
            ),
            if (state.q9Answer == true) ...[
              SizedBox(
                height: 20.h,
              ),
              const RegistrationStepQuestionsText(
                text:
                    'Please provide the job title of your most recent position.',
              ),
              SizedBox(
                height: 8.h,
              ),
              PrimaryTextField(
                hintText: 'Enter Your Answer',
                onChanged: (v) {
                  context
                      .read<RegistrationQuestionsBloc>()
                      .add(UpdateQ9JobTitleEvent(v));
                },
                initialValue: state.q9JobTitle,
              ),
            ],
            SizedBox(
              height: 20.h,
            ),
            PrimaryButton(
                loading: state.loading,
                text: 'Submit',
                onPressed: () {
                  if (state.q9Answer == null) {
                    return SnackbarsType.error(
                        context, 'Please select your answers!');
                  }
                  bool isValid = state.q9JobTitle?.trim().isNotEmpty ?? false;

                  if (state.q9Answer == false ||
                      (state.q9Answer == true &&
                          (state.q9JobTitle?.isNotEmpty ?? '') == true && isValid)) {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(SubmitEvent());
                  } else {
                    SnackbarsType.error(context, 'Please enter your answers!');
                  }
                })
          ],
        );
      },
    );
  }
}
