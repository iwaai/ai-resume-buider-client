part of '../components/library_resume_builder.dart';

class Step8Honors extends StatefulWidget {
  const Step8Honors({
    super.key,
    required this.resumeBuilderBloc,
  });

  final ResumeBuilderBloc resumeBuilderBloc;

  @override
  State<Step8Honors> createState() => _Step8HonorsState();
}

class _Step8HonorsState extends State<Step8Honors> {
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

  final List<String> yearList = [
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];
  List<TextEditingController> award = [];
  List<TextEditingController> organization = [];
  List<String> receivedMonth = [];
  List<String> receivedYear = [];
  bool _isDataFilled = false;

  void updateDateTime({
    String? month,
    String? year,
    required ResumeModel model,
    required int i,
    required List<HonorsAndAward> honorsList,
  }) {
    if (month != null) {
      receivedMonth[i] = month;
    }
    if (year != null) {
      receivedYear[i] = year.replaceAll(RegExp(r'[^0-9]'), '').trim();
    }

    // Ensure valid selection
    if (receivedMonth[i].isNotEmpty &&
        receivedYear[i].isNotEmpty &&
        receivedMonth[i] != "Month" &&
        receivedYear[i] != "Year") {
      print('Expiration Date::::');

      DateTime selectedDate = DateFormat('MMMM yyyy')
          .parse('${receivedMonth[i]} ${receivedYear[i]}');

      honorsList[i] = honorsList[i].copyWith(dateReceived: selectedDate);
      ResumeModel updatedModel = model.copyWith(honorsAndAwards: honorsList);

      _updateResumeModel(updatedModel, context, i);
    } else {}
  }

  void _fillData(List<HonorsAndAward> honorsList) {
    for (var i = 0; i < honorsList.length; i++) {
      organization
          .add(TextEditingController(text: honorsList[i].awardingOrganization));
      award.add(TextEditingController(text: honorsList[i].awardName));
      receivedMonth.add(getMonthName(honorsList[i].dateReceived));
      receivedYear.add(getYear(honorsList[i].dateReceived));
    }
    _isDataFilled = true;
  }

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

  void _updateResumeModel(ResumeModel model, BuildContext context, int i) {
    context
        .read<CreateResumeBloc>()
        .add(UpdateResumeDataEvent(createResumeModel: model));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        List<HonorsAndAward> honorsList = List<HonorsAndAward>.from(
            state.createResumeModel.honorsAndAwards ?? []);
        if (!_isDataFilled) _fillData(honorsList);
        return Column(
          children: List.generate(
              state.createResumeModel.honorsAndAwards?.length ?? 0,
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
                                context
                                    .read<CreateResumeBloc>()
                                    .add(RemoveAFieldEvent(index: i));
                                award.removeAt(i);
                                organization.removeAt(i);
                                receivedMonth.removeAt(i);
                                receivedYear.removeAt(i);

                                // _isDataFilled = false;
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
                            validateFieldName(value, 'Award Name'),
                        maxLines: 3,
                        controller: award[i],
                        title: 'Award Name',
                        hintText:
                            'Enter Award Name (e.g., Employee of the Year,Academic Excellence Award)',
                        onChanged: (v) {
                          honorsList[i] = honorsList[i].copyWith(awardName: v);
                          final model = state.createResumeModel
                              .copyWith(honorsAndAwards: honorsList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      EditProfileTextfield(
                        characterLimit: 50,
                        validator: (value) =>
                            validateFieldName(value, 'Awarding Organization'),
                        controller: organization[i],
                        title: 'Awarding Organization or Institute',
                        hintText: 'ABC Company',
                        onChanged: (v) {
                          honorsList[i] =
                              honorsList[i].copyWith(awardingOrganization: v);
                          final model = state.createResumeModel
                              .copyWith(honorsAndAwards: honorsList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      DateSelectionDropdowns(
                          initialValue1:
                              getMonthName(honorsList[i].dateReceived),
                          initialValue2: getYear(honorsList[i].dateReceived),
                          titleDropdown1: 'Received Month',
                          titleDropdown2: 'Received Year',
                          hintTextDropdown1: 'Select Month',
                          hintTextDropdown2: 'Select Year',
                          onChangedDropdown1: (v) {
                            updateDateTime(
                              month: v,
                              model: state.createResumeModel,
                              i: i,
                              honorsList: honorsList,
                            );
                          },
                          onChangedDropdown2: (v) {
                            updateDateTime(
                                year: v,
                                model: state.createResumeModel,
                                i: i,
                                honorsList: honorsList);
                          },
                          optionsDropdown1: monthList,
                          optionsDropdown2: yearList),
                      // EditProfileTextfield(
                      //     characterLimit: 50,
                      //     showOptionalText: true,
                      //     maxLines: 7,
                      //     title: 'Description',
                      //     hintText:
                      //         "Highlight relevant skills acquired or the impact you made during the experience.",
                      //     onChanged: (v) {
                      //       honorsList[i] =
                      //           honorsList[i].copyWith(description: v);
                      //       final model = state.createResumeModel
                      //           .copyWith(honorsAndAwards: honorsList);
                      //       _updateResumeModel(model, context, i);
                      //     }),
                      if (i == (honorsList.length - 1))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddMoreButton(
                                step: state.step,
                                onTap: () {
                                  // _isDataFilled = false;
                                  // Get the current list and add a new empty Education object
                                  List<HonorsAndAward> updatedList = List.from(
                                      state.createResumeModel.honorsAndAwards ??
                                          []);
                                  updatedList.add(
                                      const HonorsAndAward()); // Add a fresh empty object

                                  final model = state.createResumeModel
                                      .copyWith(honorsAndAwards: updatedList);
                                  _updateResumeModel(
                                      model, context, updatedList.length - 1);
                                  // Add new controllers for the new entry to avoid copying values
                                  award.add(TextEditingController());
                                  organization.add(TextEditingController());
                                  receivedMonth.add('');
                                  receivedYear.add('');

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
                                if (award[i].text.isEmpty ||
                                    organization[i].text.isEmpty ||
                                    honorsList[i].dateReceived == null) {
                                  SnackbarsType.error(
                                      context, 'Please fill required fields!');
                                } else {
                                  context.push(AppRoutes.resumeDetails, extra: {
                                    'isPreview': true,
                                    'model': state.createResumeModel,
                                    'bloc': widget.resumeBuilderBloc
                                  });
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
                            //     honorsList = [const HonorsAndAward()];
                            //     final model = state.createResumeModel.copyWith(
                            //       honorsAndAwards: honorsList,
                            //     );
                            //     _updateResumeModel(model, context, i);
                            //     log('Final Model:::: ${state.createResumeModel.toJson()}');
                            //     // _clearFields();
                            //     context.push(AppRoutes.resumeDetails, extra: {
                            //       'isPreview': true,
                            //       'model': model,
                            //       'bloc': widget.resumeBuilderBloc
                            //     });
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
