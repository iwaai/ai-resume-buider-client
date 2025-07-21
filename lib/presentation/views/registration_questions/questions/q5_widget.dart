import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_dropdown.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';
import 'package:second_shot/presentation/views/registration_questions/components/add_icon_button.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/presentation/views/registration_questions/components/selected_option.dart';
import 'package:second_shot/presentation/views/registration_questions/components/sports_dialog.dart';
import 'package:second_shot/utils/enums.dart';
import 'package:second_shot/utils/extensions.dart';

class Q5Widget extends StatelessWidget {
  const Q5Widget({super.key});

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
                  'Are you an athlete, former athlete, or consider yourself athletic?',
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.Yes.name,
                    selected: state.q5Answer == true,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ5AnswerEvent(true));
                    },
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.No.name,
                    selected: state.q5Answer == false,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ5AnswerEvent(false));
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ5SportEvent(SportsModel.idle()));
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ5PositionEvent(null));
                    },
                  ),
                ),
              ],
            ),
            if (state.q5Answer == true) ...[
              SizedBox(
                height: 20.h,
              ),
              Text(
                'What is your primary sport and primary position?',
                style: context.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8.h,
              ),
              const RegistrationStepQuestionsText(
                text: 'Primary Sport',
              ),
              SizedBox(
                height: 8.h,
              ),
              PrimaryDropdownForObjects(
                hintText: 'Select your answer',
                options: context.read<RegistrationQuestionsBloc>().sports,
                initialValue: state.q5Sport?.id,
                onChanged: (newValue) {
                  context
                      .read<RegistrationQuestionsBloc>()
                      .add(UpdateQ5SportEvent(newValue!));
                },
              ),
              ...[
                SizedBox(
                  height: 16.h,
                ),
                const RegistrationStepQuestionsText(
                  text: 'Primary Position',
                ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h)
                      .copyWith(right: 4.w, left: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.borderGrey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.q5position != null &&
                          (state.q5position?.id.isNotEmpty ?? false))
                        Flexible(
                          child: SelectedOption(
                            title: state.q5position!.name.toString(),
                            onDelete: () {
                              context.read<RegistrationQuestionsBloc>().add(
                                  UpdateQ5PositionEvent(
                                      SportsPositionsModel.idle()));
                            },
                          ),
                        )
                      else
                        const Text('Select Your Answer'),
                      SizedBox(
                        width: 16.w,
                      ),
                      AddIconButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return BlocProvider.value(
                                  value:
                                      context.read<RegistrationQuestionsBloc>(),
                                  child: const SportsPositionDialog(),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              ]
            ],
            SizedBox(
              height: 20.h,
            ),
            PrimaryButton(
                text: 'Next',
                onPressed: () {
                  if (state.q5Answer != null) {
                    if (state.q5Answer == false) {
                      print('1st');
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(NextStepEvent());
                    } else if (state.q5Sport != null &&
                        state.q5position != null &&
                        state.q5Sport!.id.isNotEmpty &&
                        state.q5position!.id.isNotEmpty) {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(NextStepEvent());
                    } else {
                      SnackbarsType.error(
                          context, 'Please select your answers!');
                    }
                  } else {
                    SnackbarsType.error(context, 'Please pick a choice!');
                  }
                })
          ],
        );
      },
    );
  }
}
