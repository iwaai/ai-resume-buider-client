import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/presentation/views/registration_questions/components/searchable_dialog.dart';

class RankDialog extends StatelessWidget {
  const RankDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
      builder: (context, state) {
        List<ForceRanks> ranks = state.searchedRanks.isEmpty
            ? state.filteredRanks
            : state.searchedRanks;
        return SearchableDialogForObjects(
            onTap: (e) {
              context
                  .read<RegistrationQuestionsBloc>()
                  .add(UpdateQ4RankEvent(e));
            },
            options: ranks,
            onSave: () {
              context.pop();
            },
            onSearch: (String? v) {
              context.read<RegistrationQuestionsBloc>().add(SearchRankEvent(v));
            },
            selectedObject: state.q4rank);
      },
    );
  }
}
