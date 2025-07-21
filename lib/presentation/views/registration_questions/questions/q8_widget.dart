import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/registration_questions/components/add_icon_button.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/presentation/views/registration_questions/components/selected_option.dart';
import 'package:second_shot/presentation/views/registration_questions/components/subjects_dialog.dart';

class Q8Widget extends StatelessWidget {
  const Q8Widget({super.key});

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
                  'Please select your favorite subject from when you were in middle school.',
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
                  if (state.q8subject != null && state.q8subject!.id.isNotEmpty)
                    SelectedOption(
                      title: state.q8subject!.name.toString(),
                      onDelete: () {
                        context
                            .read<RegistrationQuestionsBloc>()
                            .add(UpdateQ8SubjectEvent(SubjectModel.idle()));
                      },
                    )
                  else
                    const Text(
                      'Select Your Answer',
                    ),
                  const Spacer(
                    flex: 1,
                  ),
                  AddIconButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<RegistrationQuestionsBloc>(),
                              child: const SubjectsDialog(),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
                text: 'Next',
                onPressed: () {
                  if (state.q8subject != null &&
                      state.q8subject!.id.isNotEmpty) {
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
