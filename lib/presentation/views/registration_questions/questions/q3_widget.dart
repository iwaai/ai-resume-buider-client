import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/utils/enums.dart';

class Q3Widget extends StatelessWidget {
  const Q3Widget({super.key});

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
            text: 'Are you over 18 years or older?',
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Expanded(
                child: DialogSelectionTile(
                  text: ConfirmationStatus.Yes.name,
                  selected: state.q3Answer == true,
                  onTap: () {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(UpdateQ3AnswerEvent(true));
                  },
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: DialogSelectionTile(
                  text: ConfirmationStatus.No.name,
                  selected: state.q3Answer == false,
                  onTap: () {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(UpdateQ3AnswerEvent(false));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          PrimaryButton(
            text: 'Next',
            onPressed: () {
              if (state.q3Answer != null) {
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
