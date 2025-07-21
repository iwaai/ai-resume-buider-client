import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_dropdown.dart';
import 'package:second_shot/utils/enums.dart';
import 'package:second_shot/utils/extensions.dart';

class Q1Widget extends StatelessWidget {
  Q1Widget({super.key});
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
          Text(
            'Select your current grade level or professional level.',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          PrimaryDropdown(
            hintText: 'Select your answer',
            options: Education.values.map((e) => e.toString()).toList(),
            initialValue: state.selectedEducation?.toString(),
            onChanged: (newValue) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(UpdateQ1EducationEvent(newValue));
            },
          ),

          ///Widget removed for permanent removal later
          // if (state.selectedEducation != null) ...[
          //   Text(
          //     state.selectedEducation == Education.middleSchool.toString() ||
          //             state.selectedEducation == Education.highSchool.toString()
          //         ? 'Choose the major, trade school, or military branch you are most interested in pursuing after school.'
          //         : 'Select the major that is closely related to the one you pursued or are pursuing in college.',
          //     style: context.textTheme.titleMedium,
          //   ),
          //   const SizedBox(
          //     height: 8,
          //   ),
          //   Container(
          //     padding: EdgeInsets.symmetric(vertical: 8.h)
          //         .copyWith(right: 4.w, left: 12.w),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(
          //         color: AppColors.borderGrey,
          //         width: 1.0,
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         state.educationalExpertise != null &&
          //                 state.educationalExpertise!.isNotEmpty
          //             ? Flexible(
          //                 child: SelectedOption(
          //                     title: state.educationalExpertise.toString(),
          //                     onDelete: () {
          //                       context
          //                           .read<RegistrationQuestionsBloc>()
          //                           .add(UpdateQ1ExpertiseEvent(''));
          //                     }),
          //               )
          //             : const Text(
          //                 'Select Your Answer',
          //               ),
          //         SizedBox(
          //           width: 16.w,
          //         ),
          //         AddIconButton(
          //           onTap: () {
          //             showDialog(
          //                 context: context,
          //                 builder: (_) {
          //                   return BlocProvider.value(
          //                     value: context.read<RegistrationQuestionsBloc>(),
          //                     child: const EducationalExpertiseDialog(),
          //                   );
          //                 });
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
            text: 'Next',
            onPressed: () {
              /// Old Condition
              //if (state.selectedEducation != null &&
              //                   state.educationalExpertise != null &&
              //                   state.educationalExpertise!.isNotEmpty)
              if (state.selectedEducation != null) {
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
