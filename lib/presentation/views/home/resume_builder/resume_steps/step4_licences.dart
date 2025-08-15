part of '../components/library_resume_builder.dart';

class Step4Licences extends StatefulWidget {
  const Step4Licences({
    super.key,
  });

  @override
  State<Step4Licences> createState() => _Step4LicencesState();
}

class _Step4LicencesState extends State<Step4Licences> {
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
  List<TextEditingController> certificate = [];
  List<TextEditingController> organization = [];
  List<String> issueMonth = [];
  List<String> issueYear = [];
  List<String> expirationMonth = [];
  List<String> expirationYear = [];
  bool _isDataFilled = false;

  void updateDateTime({
    String? month,
    String? year,
    bool isExpirationDate = false,
    required ResumeModel model,
    required int i,
    required List<LicensesAndCertification> licenseList,
  }) {
    if (isExpirationDate) {
      if (month != null) {
        expirationMonth[i] = month;
      }
      if (year != null) {
        expirationYear[i] = year.replaceAll(RegExp(r'[^0-9]'), '').trim();
      }

      // Ensure valid selection
      if (expirationMonth[i].isNotEmpty &&
          expirationYear[i].isNotEmpty &&
          expirationMonth[i] != "Month" &&
          expirationYear[i] != "Year") {
        DateTime selectedDate = DateFormat('MMMM yyyy')
            .parse('${expirationMonth[i]} ${expirationYear[i]}');

        licenseList[i] = licenseList[i].copyWith(expirationDate: selectedDate);
        ResumeModel updatedModel =
            model.copyWith(licensesAndCertifications: licenseList);

        _updateResumeModel(updatedModel, context, i);
      }
    } else {
      if (month != null) {
        issueMonth[i] = month;
      }
      if (year != null) {
        issueYear[i] = year.replaceAll(RegExp(r'[^0-9]'), '').trim();
      }

      // Ensure valid selection
      if (issueMonth[i].isNotEmpty &&
          issueYear[i].isNotEmpty &&
          issueMonth[i] != "Month" &&
          issueYear[i] != "Year") {
        DateTime selectedDate =
            DateFormat('MMMM yyyy').parse('${issueMonth[i]} ${issueYear[i]}');
        licenseList[i] = LicensesAndCertification(
            certificationName: licenseList[i].certificationName,
            issuingOrganization: licenseList[i].issuingOrganization,
            issueDate: selectedDate,
            expirationDate: null);
        expirationMonth[i] = 'Month';
        expirationYear[i] = 'Year';

        ResumeModel updatedModel =
            model.copyWith(licensesAndCertifications: licenseList);

        _updateResumeModel(updatedModel, context, i);
      }
    }
  }

  void _fillData(List<LicensesAndCertification> licenseList) {
    for (var i = 0; i < licenseList.length; i++) {
      certificate
          .add(TextEditingController(text: licenseList[i].certificationName));
      organization
          .add(TextEditingController(text: licenseList[i].issuingOrganization));
      issueMonth.add(getMonthName(licenseList[i].issueDate));
      issueYear.add(getYear(licenseList[i].issueDate));
      expirationMonth.add(getMonthName(licenseList[i].expirationDate));
      expirationYear.add(getYear(licenseList[i].expirationDate));
    }
    _isDataFilled = true;
  }

  void _clearFields() {
    certificate.clear();
    organization.clear();
    issueMonth.clear();
    issueYear.clear();
    expirationMonth.clear();
    expirationYear.clear();
  }

  void _updateResumeModel(ResumeModel model, BuildContext context, int i) {
    context
        .read<CreateResumeBloc>()
        .add(UpdateResumeDataEvent(createResumeModel: model));
  }

  String getMonthName(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM').format(date);
    } else {
      return 'Month';
    }
  }

  String getYear(DateTime? date) {
    if (date != null) {
      return DateFormat('yyyy').format(date);
    } else {
      return 'Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        List<LicensesAndCertification> licenseList =
            List<LicensesAndCertification>.from(
                state.createResumeModel.licensesAndCertifications ?? []);
        if (!_isDataFilled) _fillData(licenseList);
        return Column(
          children: List.generate(
              licenseList.length,
              (i) => Column(
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
                                certificate.removeAt(i);
                                organization.removeAt(i);
                                issueMonth.removeAt(i);
                                issueYear.removeAt(i);
                                expirationMonth.removeAt(i);
                                expirationYear.removeAt(i);
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
                            validateFieldName(value, 'Certificate Name'),
                        controller: certificate[i],
                        title: 'Certificate Name',
                        hintText: 'Enter Certificate Name',
                        onChanged: (v) {
                          licenseList[i] =
                              licenseList[i].copyWith(certificationName: v);
                          final model = state.createResumeModel
                              .copyWith(licensesAndCertifications: licenseList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      EditProfileTextfield(
                        characterLimit: 50,
                        validator: (value) =>
                            validateFieldName(value, 'Issuing Organization'),
                        controller: organization[i],
                        title: 'Issuing Organization',
                        hintText: 'Enter Issuing Organization',
                        onChanged: (v) {
                          licenseList[i] =
                              licenseList[i].copyWith(issuingOrganization: v);
                          final model = state.createResumeModel
                              .copyWith(licensesAndCertifications: licenseList);
                          _updateResumeModel(model, context, i);
                        },
                      ),
                      DateSelectionDropdowns(
                        initialValue1: getMonthName(licenseList[i].issueDate),
                        initialValue2: getYear(licenseList[i].issueDate),
                        titleDropdown1: 'Issue Month',
                        titleDropdown2: 'Issue Year',
                        hintTextDropdown1: 'Select Month',
                        hintTextDropdown2: 'Select Year',
                        onChangedDropdown1: (v) {
                          updateDateTime(
                              month: v,
                              model: state.createResumeModel,
                              i: i,
                              licenseList: licenseList,
                              isExpirationDate: false);
                        },
                        onChangedDropdown2: (v) {
                          updateDateTime(
                              isExpirationDate: false,
                              year: v,
                              model: state.createResumeModel,
                              i: i,
                              licenseList: licenseList);
                        },
                        optionsDropdown1: monthList,
                        optionsDropdown2: [
                          for (int year = 1990; year <= 2025; year++)
                            year.toString()
                        ],
                      ),
                      DateSelectionDropdowns(
                        isEnabled2:
                            licenseList[i].issueDate == null ? false : true,
                        isEnabled1:
                            licenseList[i].issueDate == null ? false : true,
                        initialValue1:
                            getMonthName(licenseList[i].expirationDate),
                        initialValue2: getYear(licenseList[i].expirationDate),
                        titleDropdown1: 'Expiration Month',
                        titleDropdown2: 'Expiration Year',
                        hintTextDropdown1: 'Select Month',
                        hintTextDropdown2: 'Select Year',
                        onChangedDropdown1: (v) {
                          updateDateTime(
                              isExpirationDate: true,
                              month: v,
                              model: state.createResumeModel,
                              i: i,
                              licenseList: licenseList);
                        },
                        onChangedDropdown2: (v) {
                          updateDateTime(
                              isExpirationDate: true,
                              year: v,
                              model: state.createResumeModel,
                              i: i,
                              licenseList: licenseList);
                        },
                        optionsDropdown1: monthList,
                        optionsDropdown2: [
                          for (int year = int.tryParse(issueYear[i]) ?? 1990;
                              year <= 2040;
                              year++)
                            year.toString()
                        ],
                      ),
                      if (i == (licenseList.length - 1))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AddMoreButton(
                                step: state.step,
                                onTap: () {
                                  // _isDataFilled = false;

                                  // context
                                  //     .read<CreateResumeBloc>()
                                  //     .add(AddAFieldEvent());
                                  // Get the current list and add a new empty Education object
                                  List<LicensesAndCertification> updatedList =
                                      List.from(state.createResumeModel
                                              .licensesAndCertifications ??
                                          []);
                                  print(updatedList.length);
                                  updatedList.add(
                                      const LicensesAndCertification()); // Add a fresh empty object
                                  print(updatedList.length);

                                  final model = state.createResumeModel
                                      .copyWith(
                                          licensesAndCertifications:
                                              updatedList);
                                  _updateResumeModel(
                                      model, context, updatedList.length - 1);

                                  // Add new controllers for the new entry to avoid copying values
                                  certificate.add(TextEditingController());
                                  organization.add(TextEditingController());
                                  issueMonth.add('');
                                  issueYear.add('');
                                  expirationMonth.add('');
                                  expirationYear.add('');
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
                                if (certificate[i].text.isEmpty ||
                                    organization[i].text.isEmpty ||
                                    licenseList[i].issueDate == null ||
                                    licenseList[i].expirationDate == null) {
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
                            SizedBox(height: 8.h),
                            PrimaryButton(
                              fontWeight: FontWeight.w600,
                              borderColor: AppColors.stepsNonSelectedColor,
                              buttonColor: Colors.transparent,
                              textColor: AppColors.blackColor,
                              onPressed: () {
                                licenseList = [
                                  const LicensesAndCertification()
                                ];
                                final model = state.createResumeModel.copyWith(
                                  licensesAndCertifications: licenseList,
                                );
                                _updateResumeModel(model, context, i);
                                _clearFields();
                                context
                                    .read<CreateResumeBloc>()
                                    .add(StepIncrement());
                              },
                              text: 'Skip',
                            ),
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
