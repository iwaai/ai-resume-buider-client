part of '../components/library_resume_builder.dart';

class Step3Education extends StatefulWidget {
  const Step3Education({super.key});

  @override
  State<Step3Education> createState() => _Step3EducationState();
}

class _Step3EducationState extends State<Step3Education> {
  List<TextEditingController> institute = [];
  List<TextEditingController> degree = [];
  List<TextEditingController> fieldOfStudy = [];
  List<TextEditingController> startYear = [];
  List<TextEditingController> endYear = [];
  bool _isDataFilled = false;

  void _updateResumeModel(ResumeModel model, BuildContext context, int i) {
    context
        .read<CreateResumeBloc>()
        .add(UpdateResumeDataEvent(createResumeModel: model));
  }

  _fillData(List<Education> eduList) {
    for (var i = 0; i < eduList.length; i++) {
      institute.add(TextEditingController(text: eduList[i].institution));
      degree.add(TextEditingController(text: eduList[i].degree));
      fieldOfStudy.add(TextEditingController(text: eduList[i].fieldOfStudy));
      startYear
          .add(TextEditingController(text: eduList[i].startYear.toString()));
      endYear.add(TextEditingController(text: eduList[i].endYear.toString()));
    }
    _isDataFilled = true;
  }

  void _clearFields() {
    institute.clear();
    degree.clear();
    fieldOfStudy.clear();
    startYear.clear();
    endYear.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
        builder: (context, state) {
      List<Education> eduList =
          List<Education>.from(state.createResumeModel.education ?? []);
      if (!_isDataFilled) _fillData(eduList);
      return Column(
        children: List.generate(eduList.length, (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                        context
                            .read<CreateResumeBloc>()
                            .add(RemoveAFieldEvent(index: i));
                        fieldOfStudy.removeAt(i);
                        degree.removeAt(i);
                        institute.removeAt(i);
                        startYear.removeAt(i);
                        endYear.removeAt(i);
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
                  validator: (value) => validateFieldName(value, 'Institution'),
                  controller: institute[i],
                  title: 'Institution',
                  hintText: 'Enter your Institution',
                  onChanged: (v) {
                    final model =
                        state.createResumeModel.copyWith(education: eduList);
                    eduList[i] = eduList[i].copyWith(institution: v);
                    _updateResumeModel(model, context, i);
                  }),
              EditProfileTextfield(
                  characterLimit: 50,
                  validator: (value) => validateFieldName(value, 'Degree'),
                  controller: degree[i],
                  title: 'Degree',
                  hintText: 'Enter your Degree',
                  onChanged: (v) {
                    final model =
                        state.createResumeModel.copyWith(education: eduList);
                    _updateResumeModel(model, context, i);
                    eduList[i] = eduList[i].copyWith(degree: v);
                    _updateResumeModel(model, context, i);
                  }),
              EditProfileTextfield(
                characterLimit: 50,
                validator: (value) =>
                    validateFieldName(value, 'Field of Study'),
                controller: fieldOfStudy[i],
                title: 'Field of Study',
                hintText: 'Enter Field of Study',
                onChanged: (v) {
                  // print(
                  //     'Education ${state.createResumeModel.education?[0].toJson()}');
                  print('END YEAR:::: ${eduList[i].endYear}');
                  eduList[i] = eduList[i].copyWith(fieldOfStudy: v);
                  final model =
                      state.createResumeModel.copyWith(education: eduList);
                  // _updateResumeModel(model, context, i);
                  print('END YEAR:::: ${eduList[i].endYear}');
                },
              ),
              DateSelectionDropdowns(
                isEnabled2: eduList[i].startYear == null ? false : true,
                // // validator1: validateField,
                initialValue1: startYear[i].text =
                    eduList[i].startYear?.toString() ?? 'Start Year',
                initialValue2: endYear[i].text =
                    eduList[i].endYear?.toString() ?? 'End Year',
                showOptionalText2: true,
                titleDropdown1: 'Start Year',
                titleDropdown2: 'End Year',
                hintTextDropdown1: 'Select Year',
                hintTextDropdown2: 'Select Year',
                onChangedDropdown1: (v) {
                  eduList[i] = Education(
                    degree: eduList[i].degree,
                    fieldOfStudy: eduList[i].fieldOfStudy,
                    institution: eduList[i].institution,
                    startYear: int.tryParse(v ?? ''),
                    endYear: null,
                  );
                  final model =
                      state.createResumeModel.copyWith(education: eduList);
                  _updateResumeModel(model, context, i);
                },
                onChangedDropdown2: (v) {
                  if (startYear[i].text == 'Start Year') {
                    SnackbarsType.error(
                        context, 'Please select start year first!');
                  } else {
                    eduList[i] =
                        eduList[i].copyWith(endYear: int.tryParse(v ?? ''));
                    final model =
                        state.createResumeModel.copyWith(education: eduList);
                    _updateResumeModel(model, context, i);
                  }
                },
                optionsDropdown1: [
                  for (int year = 1990; year <= 2025; year++) year.toString()
                ],
                optionsDropdown2: [
                  for (int year =
                          state.createResumeModel.education?[i].startYear ??
                              1990;
                      year <= 2040;
                      year++)
                    year.toString()
                ],
              ),
              if (i == eduList.length - 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddMoreButton(
                        step: state.step,
                        onTap: () {
                          List<Education> updatedList = List.from(
                              state.createResumeModel.education ?? []);
                          updatedList.add(const Education());

                          final model = state.createResumeModel
                              .copyWith(education: updatedList);
                          _updateResumeModel(
                              model, context, updatedList.length - 1);

                          // Add new controllers for the new entry to avoid copying values
                          institute.add(TextEditingController());
                          degree.add(TextEditingController());
                          fieldOfStudy.add(TextEditingController());
                          startYear.add(TextEditingController());
                          endYear.add(TextEditingController());
                        }),
                    InkWell(
                      onTap: () {
                        context.read<CreateResumeBloc>().add(StepDecrement());
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
                        if (institute[i].text.isEmpty ||
                            degree[i].text.isEmpty ||
                            fieldOfStudy[i].text.isEmpty ||
                            eduList[i].startYear == null ||
                            eduList[i].endYear == null) {
                          SnackbarsType.error(
                              context, 'Please fill required fields!');
                        } else {
                          context.read<CreateResumeBloc>().add(StepIncrement());
                        }
                      },
                      text: 'Next',
                    ),
                    SizedBox(height: 8.h),
                    PrimaryButton(
                      fontWeight: FontWeight.w600,
                      borderColor: AppColors.stepsNonSelectedColor,
                      buttonColor: Colors.transparent,
                      textColor: AppColors.blackColor,
                      onPressed: () {
                        eduList = [const Education()];
                        final model = state.createResumeModel.copyWith(
                          education: eduList,
                        );
                        _updateResumeModel(model, context, i);
                        _clearFields();
                        context.read<CreateResumeBloc>().add(StepIncrement());
                      },
                      text: 'Skip',
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
            ],
          );
        }),
      );
    });
  }
}
