import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/registration_questions/components/add_icon_button.dart';
import 'package:second_shot/presentation/views/registration_questions/components/hobbies_dialog.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/presentation/views/registration_questions/components/selected_option.dart';

class Q7Widget extends StatelessWidget {
  const Q7Widget({super.key});

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
              text:
                  'Select your second most favorite hobby or activity you enjoy now or during your childhood.',
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h)
                  .copyWith(right: 4.w, left: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderGrey,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.q7Hobby != null && state.q7Hobby?.id != '')
                    Flexible(
                      child: SelectedOption(
                          title: state.q7Hobby!.name.toString(),
                          onDelete: () {
                            context
                                .read<RegistrationQuestionsBloc>()
                                .add(UpdateQ7HobbyEvent(HobbyModel.idle()));
                          }),
                    )
                  else
                    const Text(
                      'Select Your Answer',
                    ),
                  AddIconButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<RegistrationQuestionsBloc>()
                                ..add(ResetSecondHobbiesEvent()),
                              child: const HobbiesDialog(
                                isSecondHobby: true,
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            PrimaryButton(
                text: 'Next',
                onPressed: () {
                  if (state.q7Hobby != null && state.q7Hobby!.id.isNotEmpty) {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(NextStepEvent());
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
