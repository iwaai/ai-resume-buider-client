import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class SubjectsDialog extends StatelessWidget {
  const SubjectsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
          builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(Icons.close)),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .5,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: context
                        .read<RegistrationQuestionsBloc>()
                        .subjects
                        .map((e) => DialogSelectionTile(
                            onTap: () {
                              context
                                  .read<RegistrationQuestionsBloc>()
                                  .add(UpdateQ8SubjectEvent(e));
                            },
                            text: e.name.toString(),
                            selected:
                                state.q8subject?.id.toString().toLowerCase() ==
                                    e.id.toString().toLowerCase()))
                        .toList(),
                  ),
                ),
              ),
              PrimaryButton(
                text: 'Save',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
