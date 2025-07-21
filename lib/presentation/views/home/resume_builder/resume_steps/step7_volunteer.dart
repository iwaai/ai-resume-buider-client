part of '../components/library_resume_builder.dart';

class Step7Volunteer extends StatefulWidget {
  const Step7Volunteer({
    super.key,
  });

  @override
  State<Step7Volunteer> createState() => _Step7VolunteerState();
}

class _Step7VolunteerState extends State<Step7Volunteer> {
  List<TextEditingController> organization = [];
  List<TextEditingController> role = [];
  List<TextEditingController> startYear = [];
  List<TextEditingController> endYear = [];
  List<TextEditingController> description = [];
  bool _isDataFilled = false;

  void _fillData(List<VolunteerExperience> volunteerList) {
    for (var i = 0; i < volunteerList.length; i++) {
      organization
          .add(TextEditingController(text: volunteerList[i].organizationName));
      role.add(TextEditingController(text: volunteerList[i].role));
      startYear.add(TextEditingController(text: volunteerList[i].role));
      endYear.add(TextEditingController(text: volunteerList[i].role));
      description
          .add(TextEditingController(text: volunteerList[i].description));
    }
    _isDataFilled = true;
  }

  void _clearFields() {
    organization.clear();
    role.clear();
    startYear.clear();
    endYear.clear();
  }

  void _updateResumeModel(ResumeModel model, BuildContext context, int i) {
    context
        .read<CreateResumeBloc>()
        .add(UpdateResumeDataEvent(createResumeModel: model));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        List<VolunteerExperience> volunteerList =
            List<VolunteerExperience>.from(
                state.createResumeModel.volunteerExperience ?? []);
        if (!_isDataFilled) _fillData(volunteerList);
        return Column(
          children: List.generate(
              state.createResumeModel.volunteerExperience?.length ?? 0,
              (i) => Column(
                    children: [
                      if (i > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Divider(
                              color: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                // _isDataFilled = false;
                                organization.removeAt(i);
                                role.removeAt(i);
                                startYear.removeAt(i);
                                endYear.removeAt(i);
                                context
                                    .read<CreateResumeBloc>()
                                    .add(RemoveAFieldEvent(index: i));
                              },
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      EditProfileTextfield(
                        characterLimit: 50,
                        validator: (value) =>
                            validateFieldName(value, 'Organization Name'),
                        controller: organization[i]
                          ..text = volunteerList[i].organizationName ?? '',
                        title: 'Organization Name',
                        hintText: 'Enter Organization Name',
                        onChanged: (v) {
                          volunteerList[i] =
                              volunteerList[i].copyWith(organizationName: v);
                          final model = state.createResumeModel
                              .copyWith(volunteerExperience: volunteerList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      EditProfileTextfield(
                        characterLimit: 50,
                        validator: (value) =>
                            validateFieldName(value, 'Volunteer Role/Title'),
                        controller: role[i]..text = volunteerList[i].role ?? '',
                        title: 'Volunteer Role/Title',
                        hintText: 'Enter Volunteer Role',
                        onChanged: (v) {
                          volunteerList[i] = volunteerList[i].copyWith(role: v);
                          final model = state.createResumeModel
                              .copyWith(volunteerExperience: volunteerList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      DateSelectionDropdowns(
                        isEnabled2:
                            volunteerList[i].startYear == null ? false : true,
                        initialValue1: startYear[i].text =
                            volunteerList[i].startYear?.toString() ??
                                'Start Year',
                        initialValue2: endYear[i].text =
                            volunteerList[i].endYear?.toString() ?? 'End Year',
                        titleDropdown1: 'Start Year',
                        titleDropdown2: 'End Year',
                        hintTextDropdown1: 'Select Year',
                        hintTextDropdown2: 'Select Year',
                        onChangedDropdown1: (v) {
                          volunteerList[i] = VolunteerExperience(
                              organizationName:
                                  volunteerList[i].organizationName,
                              role: volunteerList[i].role,
                              startYear: int.tryParse(v ?? ''),
                              endYear: null);
                          volunteerList[i] = volunteerList[i].copyWith(
                              startYear: int.tryParse((v ?? '')),
                              endYear: null);
                          final model = state.createResumeModel
                              .copyWith(volunteerExperience: volunteerList);
                          _updateResumeModel(model, context, i);
                        },
                        onChangedDropdown2: (v) {
                          volunteerList[i] = volunteerList[i]
                              .copyWith(endYear: int.tryParse((v ?? '')));
                          final model = state.createResumeModel
                              .copyWith(volunteerExperience: volunteerList);
                          _updateResumeModel(model, context, i);
                        },
                        optionsDropdown1: [
                          for (int year = 1990; year <= 2025; year++)
                            year.toString()
                        ],
                        optionsDropdown2: [
                          for (int year = 1998; year <= 2040; year++)
                            year.toString()
                        ],
                      ),
                      EditProfileTextfield(
                          controller: description[i]
                            ..text = volunteerList[i].description ?? '',
                          characterLimit: 300,
                          showOptionalText: true,
                          maxLines: 7,
                          title: 'Description',
                          hintText:
                              "Highlight relevant skills acquired or the impact you made during the experience.",
                          onChanged: (v) {
                            volunteerList[i] =
                                volunteerList[i].copyWith(description: v);
                            final model = state.createResumeModel
                                .copyWith(volunteerExperience: volunteerList);
                            _updateResumeModel(model, context, i);
                          }),
                      if (i == (volunteerList.length - 1))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddMoreButton(
                                step: state.step,
                                onTap: () {
                                  // _isDataFilled = false;
                                  List<VolunteerExperience> updatedList =
                                      List.from(state.createResumeModel
                                              .volunteerExperience ??
                                          []);
                                  updatedList.add(
                                      const VolunteerExperience()); // Add a fresh empty object

                                  final model = state.createResumeModel
                                      .copyWith(
                                          volunteerExperience: updatedList);
                                  _updateResumeModel(
                                      model, context, updatedList.length - 1);

                                  // Add new controllers for the new entry to avoid copying values
                                  organization.add(TextEditingController());
                                  role.add(TextEditingController());
                                  startYear.add(TextEditingController());
                                  endYear.add(TextEditingController());
                                  // context
                                  //     .read<CreateResumeBloc>()
                                  //     .add(AddAFieldEvent());
                                }),
                            InkWell(
                              onTap: () {
                                context
                                    .read<CreateResumeBloc>()
                                    .add(StepDecrement());
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TipsWidget(
                              step: state.step,
                            ),
                            SizedBox(height: 8.h),
                            PrimaryButton(
                              onPressed: () {
                                if (organization[i].text.isEmpty ||
                                    role[i].text.isEmpty ||
                                    volunteerList[i].startYear == null ||
                                    volunteerList[i].endYear == null) {
                                  SnackbarsType.error(
                                      context, 'Please fill required fields!');
                                } else {
                                  context
                                      .read<CreateResumeBloc>()
                                      .add(StepIncrement());
                                }
                              },
                              text: 'Next',
                            ),
                            // SizedBox(height: 8.h),
                            // PrimaryButton(
                            //   fontWeight: FontWeight.w600,
                            //   borderColor: AppColors.stepsNonSelectedColor,
                            //   buttonColor: Colors.transparent,
                            //   textColor: AppColors.blackColor,
                            //   onPressed: () {
                            //     volunteerList = [const VolunteerExperience()];
                            //     final model = state.createResumeModel.copyWith(
                            //       volunteerExperience: volunteerList,
                            //     );
                            //     _updateResumeModel(model, context, i);
                            //     _clearFields();
                            //     context
                            //         .read<CreateResumeBloc>()
                            //         .add(StepIncrement());
                            //   },
                            //   text: 'Skip',
                            // ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                    ],
                  )),
        );
      },
    );
  }
}
