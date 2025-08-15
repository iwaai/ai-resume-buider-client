import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/views/registration_questions/components/searchable_dialog.dart';

class EducationalExpertiseDialog extends StatelessWidget {
  const EducationalExpertiseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
      builder: (context, state) {
        return SearchableDialog(
            onTap: (e) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(UpdateQ1ExpertiseEvent(e));
            },
            options: state.allExpertise,
            onSave: () {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(ResetExpertiseListEvent());
              context.pop();
            },
            onSearch: (String? v) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(SearchEducationEvent(v));
            },
            selectedObject: state.educationalExpertise?.toLowerCase());
      },
    );
  }
}
