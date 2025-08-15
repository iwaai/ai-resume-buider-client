import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class SportsPositionDialog extends StatelessWidget {
  const SportsPositionDialog({super.key});

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
              state.filteredPositions.toList().length < 3
                  ? Row(
                      children: state.filteredPositions
                          .map((e) => Expanded(
                                child: DialogSelectionTile(
                                    onTap: () {
                                      context
                                          .read<RegistrationQuestionsBloc>()
                                          .add(UpdateQ5PositionEvent(e));
                                    },
                                    text: e.name.toString(),
                                    selected: state.q5position?.id ==
                                        e.id.toString().toLowerCase()),
                              ))
                          .toList(),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        children: state.filteredPositions
                            .map((e) => DialogSelectionTile(
                                onTap: () {
                                  context
                                      .read<RegistrationQuestionsBloc>()
                                      .add(UpdateQ5PositionEvent(e));
                                },
                                text: e.name.toString(),
                                selected: state.q5position?.id ==
                                    e.id.toString().toLowerCase()))
                            .toList(),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                text: 'Save',
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
