part of '../components/library_resume_builder.dart';

class Step6Experience extends StatefulWidget {
  const Step6Experience({
    super.key,
  });

  @override
  State<Step6Experience> createState() => _Step6ExperienceState();
}

class _Step6ExperienceState extends State<Step6Experience> {
  final List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  List<TextEditingController> job = [];
  List<TextEditingController> company = [];
  List<TextEditingController> startMonth = [];
  List<TextEditingController> startYear = [];
  List<TextEditingController> endMonth = [];
  List<TextEditingController> endYear = [];
  List<TextEditingController> description = [];
  bool _isDataFilled = false;

  String getMonthName(DateTime? date) {
    String? monthName;
    if (date != null) {
      monthName = DateFormat('MMMM').format(date);
    }
    return monthName ?? 'Month';
  }

  String getYear(DateTime? date) {
    String? monthName;
    if (date != null) {
      monthName = DateFormat('yyyy').format(date);
    }
    return monthName ?? 'Year';
  }

  void updateDateTime({
    String? month,
    String? year,
    bool isEndDate = false,
    required ResumeModel model,
    required int i,
    required List<Experience> expList,
  }) {
    if (isEndDate) {
      if (month != null) {
        endMonth[i].text = month;
      }
      if (year != null) {
        endYear[i].text = year.replaceAll(RegExp(r'[^0-9]'), '').trim();
      }

      if (endMonth[i].text.isNotEmpty &&
          endYear[i].text.isNotEmpty &&
          endMonth[i].text != "Month" &&
          endYear[i].text != "Year") {
        DateTime selectedDate = DateFormat('MMMM yyyy')
            .parse('${endMonth[i].text} ${endYear[i].text}');

        expList[i] = expList[i].copyWith(endDate: selectedDate);
        ResumeModel updatedModel = model.copyWith(experience: expList);

        _updateResumeModel(updatedModel, context, i);
      }
    } else {
      if (month != null) {
        startMonth[i].text = month;
      }
      if (year != null) {
        startYear[i].text = year.replaceAll(RegExp(r'[^0-9]'), '').trim();
      }

      if (startMonth[i].text.isNotEmpty &&
          startYear[i].text.isNotEmpty &&
          startMonth[i].text != "Month" &&
          startYear[i].text != "Year") {
        DateTime selectedDate = DateFormat('MMMM yyyy')
            .parse('${startMonth[i].text} ${startYear[i].text}');

        expList[i] = Experience(
            jobTitle: expList[i].jobTitle,
            company: expList[i].company,
            startDate: selectedDate,
            endDate: null);
        // expList[i] = expList[i].copyWith(
        //   startDate: selectedDate,
        //   endDate: null,
        // );

        ResumeModel updatedModel = model.copyWith(experience: expList);
        _updateResumeModel(updatedModel, context, i);

        Future.delayed(const Duration(milliseconds: 50), () {
          endMonth[i].text = 'Month';
          endYear[i].text = 'Year';
        });
      }
    }
  }

  // void _clearFields() {
  //   job.clear();
  //   company.clear();
  //   startMonth.clear();
  //   startYear.clear();
  //   endMonth.clear();
  //   endYear.clear();
  //   description.clear();
  // }

  void _fillData(List<Experience> expList) {
    for (int i = 0; i < expList.length; i++) {
      job.add(TextEditingController(text: expList[i].jobTitle));
      company.add(TextEditingController(text: expList[i].company));
      description.add(TextEditingController(text: expList[i].description));
      startMonth
          .add(TextEditingController(text: getMonthName(expList[i].startDate)));
      startYear.add(TextEditingController(text: getYear(expList[i].startDate)));
      endMonth.add(TextEditingController(text: getYear(expList[i].endDate)));
      endYear.add(TextEditingController(text: getYear(expList[i].endDate)));
    }
    _isDataFilled = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        List<Experience> expList =
            List<Experience>.from(state.createResumeModel.experience ?? []);
        if (!_isDataFilled) _fillData(expList);
        return Column(
          children: List.generate(expList.length, (i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          job.removeAt(i);
                          company.removeAt(i);
                          description.removeAt(i);
                          startMonth.removeAt(i);
                          startYear.removeAt(i);
                          endMonth.removeAt(i);
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
                    validator: (value) => validateFieldName(value, 'Job Title'),
                    controller: job[i],
                    title: 'Job Title',
                    hintText: 'Enter Job Title',
                    onChanged: (v) {
                      expList[i] = expList[i].copyWith(jobTitle: v);
                      final model =
                          state.createResumeModel.copyWith(experience: expList);
                      _updateResumeModel(model, context, i);
                    }),
                EditProfileTextfield(
                    characterLimit: 50,
                    validator: (value) => validateFieldName(value, 'Company'),
                    controller: company[i],
                    title: 'Company',
                    hintText: 'Enter Company Name',
                    onChanged: (v) {
                      expList[i] = expList[i].copyWith(company: v);
                      final model =
                          state.createResumeModel.copyWith(experience: expList);
                      _updateResumeModel(model, context, i);
                    }),
                DateSelectionDropdowns(
                  initialValue1: getMonthName(expList[i].startDate),
                  initialValue2: getYear(expList[i].startDate),
                  titleDropdown1: 'Start Date',
                  titleDropdown2: '',
                  hintTextDropdown1: 'Select Month',
                  hintTextDropdown2: 'Select Year',
                  onChangedDropdown1: (v) {
                    updateDateTime(
                        month: v,
                        model: state.createResumeModel,
                        i: i,
                        expList: expList,
                        isEndDate: false);
                  },
                  onChangedDropdown2: (v) {
                    updateDateTime(
                        isEndDate: false,
                        year: v,
                        model: state.createResumeModel,
                        i: i,
                        expList: expList);
                  },
                  optionsDropdown1: monthList,
                  optionsDropdown2: [
                    for (int year = 1990; year <= 2040; year++) year.toString()
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              if (expList[i].isChecked == false) {
                                expList[i] = expList[i]
                                    .copyWith(isChecked: true, endDate: null);
                              } else if (expList[i].isChecked == true) {
                                expList[i] =
                                    expList[i].copyWith(isChecked: false);
                              }
                              final model = state.createResumeModel
                                  .copyWith(experience: expList);
                              _updateResumeModel(model, context, i);
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                margin:
                                    EdgeInsets.only(right: 10.w, bottom: 6.h),
                                alignment: Alignment.center,
                                height: 21.h,
                                width: 21.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: expList[i].isChecked == true
                                          ? Colors.transparent
                                          : AppColors.stepsNonSelectedColor
                                              .withOpacity(0.7)),
                                  color: expList[i].isChecked == true
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Visibility(
                                  visible: expList[i].isChecked == false
                                      ? false
                                      : true,
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.check,
                                    size: 12.sp,
                                  ),
                                ))),
                        Text(
                          textAlign: TextAlign.start,
                          'I am currently in this role',
                          style: context.textTheme.titleMedium,
                        )
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: expList[i].isChecked == true
                          ? const SizedBox.shrink()
                          : DateSelectionDropdowns(
                              isEnabled2:
                                  expList[i].startDate == null ? false : true,
                              isEnabled1:
                                  expList[i].startDate == null ? false : true,
                              initialValue1: getMonthName(expList[i].endDate),
                              initialValue2: getYear(expList[i].endDate),
                              titleDropdown1: 'End Date',
                              titleDropdown2: '',
                              hintTextDropdown1: 'Select Month',
                              hintTextDropdown2: 'Select Year',
                              onChangedDropdown1: (v) {
                                updateDateTime(
                                    isEndDate: true,
                                    month: v,
                                    model: state.createResumeModel,
                                    i: i,
                                    expList: expList);
                              },
                              onChangedDropdown2: (v) {
                                updateDateTime(
                                    isEndDate: true,
                                    year: v,
                                    model: state.createResumeModel,
                                    i: i,
                                    expList: expList);
                              },
                              optionsDropdown1: monthList,
                              optionsDropdown2: [
                                for (int year =
                                        int.tryParse(startYear[i].text) ?? 1990;
                                    year <= 2040;
                                    year++)
                                  year.toString()
                              ],
                            ),
                    ),
                  ],
                ),
                EditProfileTextfield(
                    characterLimit: 300,
                    showOptionalText: true,
                    controller: description[i],
                    maxLines: 7,
                    title: 'Description',
                    hintText: 'Describe your role',
                    onChanged: (v) {
                      expList[i] = expList[i].copyWith(description: v);
                      final model =
                          state.createResumeModel.copyWith(experience: expList);
                      _updateResumeModel(model, context, i);
                    }),
                if (i == (expList.length - 1))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddMoreButton(
                          step: state.step,
                          onTap: () {
                            // _isDataFilled = false;
                            // Get the current list and add a new empty Education object
                            List<Experience> updatedList = List.from(
                                state.createResumeModel.experience ?? []);
                            updatedList.add(const Experience(
                                isChecked: false)); // Add a fresh empty object

                            final model = state.createResumeModel
                                .copyWith(experience: updatedList);
                            _updateResumeModel(
                                model, context, updatedList.length - 1);

                            // Add new controllers for the new entry to avoid copying values
                            job.add(TextEditingController());
                            company.add(TextEditingController());
                            description.add(TextEditingController());
                            startMonth.add(TextEditingController(text: ''));
                            startYear.add(TextEditingController(text: ''));
                            endMonth.add(TextEditingController(text: ''));
                            endYear.add(TextEditingController(text: ''));
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
                          if (job[i].text.isEmpty ||
                              company[i].text.isEmpty ||
                              expList[i].startDate == null) {
                            SnackbarsType.error(
                                context, 'Please fill Required fields!');
                            return;
                          }

                          if (!expList[i].isChecked &&
                              expList[i].endDate == null) {
                            SnackbarsType.error(
                                context, 'Please fill Required fields!');
                            return;
                          }

                          context.read<CreateResumeBloc>().add(StepIncrement());
                        },
                        text: 'Next',
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  void _updateResumeModel(ResumeModel model, BuildContext context, int i) {
    context
        .read<CreateResumeBloc>()
        .add(UpdateResumeDataEvent(createResumeModel: model));
  }
}
