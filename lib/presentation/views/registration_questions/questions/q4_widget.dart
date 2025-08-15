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
import 'package:second_shot/presentation/views/registration_questions/components/rank_dialog.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_step_questions_text.dart';
import 'package:second_shot/presentation/views/registration_questions/components/selected_option.dart';
import 'package:second_shot/utils/enums.dart';
import 'package:second_shot/utils/extensions.dart';

class Q4Widget extends StatelessWidget {
  const Q4Widget({super.key});

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
              text: 'Have you served in military?',
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.Yes.name,
                    selected: state.q4Answer == true,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ4AnswerEvent(true));
                    },
                  ),
                ),
                SizedBox(
                  width: 8.h,
                ),
                Expanded(
                  child: DialogSelectionTile(
                    text: ConfirmationStatus.No.name,
                    selected: state.q4Answer == false,
                    onTap: () {
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ4AnswerEvent(false));
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ4BranchAnswerEvent(ForceService.idle()));
                      context
                          .read<RegistrationQuestionsBloc>()
                          .add(UpdateQ4RankEvent(ForceRanks.idle()));
                    },
                  ),
                ),
              ],
            ),
            if (state.q4Answer == true) ...[
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Please select the military branch and rank.',
                style: context.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8.h,
              ),
              const RegistrationStepQuestionsText(
                text: 'Branch of Service',
              ),
              SizedBox(
                height: 8.h,
              ),
              // PrimaryDropdown(
              //   hintText: 'Select your answer',
              //   options: BranchOfService.values.toList(),
              //   initialValue: state.q4BranchAnswer,
              //   onChanged: (newValue) {
              //     context
              //         .read<RegistrationQuestionsBloc>()
              //         .add(UpdateQ4BranchAnswerEvent(newValue.toString()));
              //   },
              // ),
              PrimaryDropdownForObjects<ForceService>(
                hintText: 'Select your answer',
                options:
                    context.read<RegistrationQuestionsBloc>().forces.toList(),
                initialValue: state.q4BranchAnswer?.id ?? '',
                onChanged: (newValue) {
                  context
                      .read<RegistrationQuestionsBloc>()
                      .add(UpdateQ4BranchAnswerEvent(newValue));
                },
              ),

              ///Use Dropdowns like this
              ///              PrimaryDropdownForObjects<RegistrationFormDataModel>(
              ///                 hintText: 'Select your answer',
              ///                 options: <RegistrationFormDataModel>[
              ///                   ForceBranch(id: '1', name: 'US AirForce'),
              ///                   ForceBranch(id: '2', name: 'US Army'),
              ///                   ForceBranch(id: '3', name: 'US Navy')
              ///                 ].toList(),
              ///                 initialValue: state.q4BranchAnswer,
              ///                 onChanged: (newValue) {
              ///                   print(newValue);
              ///                   context
              ///                       .read<RegistrationQuestionsBloc>()
              ///                       .add(UpdateQ4BranchAnswerEvent(newValue.toString()));
              ///                 },
              ///               ),
              if (state.q4BranchAnswer != null &&
                  (state.q4BranchAnswer?.id ?? "").isNotEmpty) ...[
                const RegistrationStepQuestionsText(
                  text: 'Rank',
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
                      if (state.q4rank != null &&
                          (state.q4rank?.id.isNotEmpty ?? false))
                        Flexible(
                          child: SelectedOption(
                              title: state.q4rank!.name.toString(),
                              onDelete: () {
                                context
                                    .read<RegistrationQuestionsBloc>()
                                    .add(UpdateQ4RankEvent(ForceRanks.idle()));
                              }),
                        )
                      else
                        const Text(
                          'Select Your Answer',
                        ),
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

                                      ///TODO: Add reset ranks and work ahead
                                      context.read<RegistrationQuestionsBloc>()
                                        ..add(ResetRankListEvent()),
                                  child: const RankDialog(),
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
                if (state.q4Answer != null) {
                  if (state.q4Answer == false) {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(NextStepEvent());
                  } else if (state.q4BranchAnswer != null &&
                      state.q4rank != null &&
                      state.q4BranchAnswer!.id.isNotEmpty &&
                      state.q4rank!.id.isNotEmpty) {
                    context
                        .read<RegistrationQuestionsBloc>()
                        .add(NextStepEvent());
                  } else {
                    SnackbarsType.error(context, 'Please select your answers!');
                  }
                } else {
                  SnackbarsType.error(context, 'Please select your answers!');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
