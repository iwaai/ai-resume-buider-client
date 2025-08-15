import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/components/primary_textfields.dart';
import 'package:second_shot/presentation/views/home/components/dialog_selection_tile.dart';

class SearchableDialog extends StatelessWidget {
  final List<dynamic> options;
  final Function() onSave;
  final Function(dynamic e) onTap;
  final Function(String?)? onSearch;
  final dynamic selectedObject;
  final bool search;
  const SearchableDialog(
      {super.key,
      this.search = true,
      required this.options,
      required this.onSave,
      this.onSearch,
      required this.selectedObject,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
          builder: (context, state) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .72,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      SizedBox(
                        height: 12.h,
                      ),
                      if (search)
                        PrimaryTextField(
                          hintText: 'Search',
                          onChanged: onSearch,
                        ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .5,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: options
                                .map(
                                  (e) => DialogSelectionTile(
                                    onTap: () {
                                      onTap(e);
                                    },
                                    text: e.toString(),
                                    selected: (selectedObject ?? "") ==
                                        e.toString().toLowerCase(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          onSave();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SearchableDialogForObjects<T extends RegistrationFormDataModel>
    extends StatelessWidget {
  final List<RegistrationFormDataModel> options;
  final Function() onSave;
  final Function(dynamic e) onTap;
  final Function(String?)? onSearch;
  final RegistrationFormDataModel? selectedObject;
  final bool search;
  const SearchableDialogForObjects(
      {super.key,
      this.search = true,
      required this.options,
      required this.onSave,
      this.onSearch,
      required this.selectedObject,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<RegistrationQuestionsBloc, RegistrationQuestionsState>(
          builder: (context, state) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .72,
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      SizedBox(
                        height: 12.h,
                      ),
                      if (search)
                        PrimaryTextField(
                          hintText: 'Search',
                          onChanged: onSearch,
                        ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .5,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: options
                                .map(
                                  (e) => DialogSelectionTile(
                                    onTap: () {
                                      onTap(e);
                                    },
                                    text: e.name.toString(),
                                    selected: (selectedObject?.id) ==
                                        e.id.toString().toLowerCase(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          onSave();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
