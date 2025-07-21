import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/views/registration_questions/components/searchable_dialog.dart';

class HobbiesDialog extends StatelessWidget {
  final bool isSecondHobby;
  const HobbiesDialog({super.key, required this.isSecondHobby});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
      builder: (context, state) {
        return SearchableDialogForObjects(
            onTap: (e) {
              isSecondHobby
                  ? context
                      .read<RegistrationQuestionsBloc>()
                      .add(UpdateQ7HobbyEvent(e))
                  : context
                      .read<RegistrationQuestionsBloc>()
                      .add(UpdateQ6HobbyEvent(e));
            },
            options: state.hobbiesList,
            onSave: () {
              context.read<RegistrationQuestionsBloc>().add(isSecondHobby
                  ? ResetSecondHobbiesEvent()
                  : ResetHobbiesEvent());
              context.pop();
            },
            onSearch: (String? v) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(SearchHobbiesEvent(v));
            },
            selectedObject: isSecondHobby ? state.q7Hobby : state.q6Hobby);
      },
    );
  }
}
