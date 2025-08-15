import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class EditSupportPeopleScreen extends StatelessWidget {
  EditSupportPeopleScreen({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as GoalsBloc;

    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<GoalsBloc, GoalsState>(
        listener: (context, state) {
          if (state.result?.event is EditSupportPeopleEvent &&
              state.result?.status == ResultStatus.error) {
            SnackbarsType.error(
                context, state.result?.message.toString() ?? "Error");
          }
          if (state.result?.event is EditSupportPeopleEvent &&
              state.result?.status == ResultStatus.successful) {
            SnackbarsType.success(
                context, state.result?.message.toString() ?? '');
            context.pop();
          }
        },
        builder: (context, state) {
          return BlocBuilder<GoalsBloc, GoalsState>(
            builder: (context, state) {
              List<SupportPeople> supportPeopleList = List<SupportPeople>.from(
                  state.goalDtail?.supportPeople ?? []);

              if (supportPeopleList.length < 2) {
                int itemsToAdd = 2 - supportPeopleList.length;
                supportPeopleList.addAll(
                  List.generate(itemsToAdd, (index) => SupportPeople()),
                );
              }

              return IgnorePointer(
                ignoring: state.loading,
                child: ScaffoldWrapper(
                  child: Scaffold(
                      appBar: const CustomAppBar(
                        title: 'Add Support Network',
                        centerTile: true,
                      ),
                      body: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Constant.horizontalPadding.w,
                            vertical: Constant.verticalPadding.h / 2,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Connect with individuals who can support you on your journey towards achieving your goals.",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(fontSize: 15.sp),
                                ),
                                Constant.verticalSpace(16.h),
                                ...List.generate(
                                  supportPeopleList.length,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Support Person ${index + 1}",
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(fontSize: 16.sp),
                                      ),
                                      PersonData(
                                        supportPeopleModel1:
                                            supportPeopleList[index],
                                        bloc: bloc,
                                      ),
                                    ],
                                  ),
                                ),
                                Constant.verticalSpace(20.h),
                                PrimaryButton(
                                  loading: state.loading,
                                  onPressed: () {
                                    bool atLeastOneInstanceFilled = false;
                                    bool allFilledInstancesValid = true;

                                    // Filter out empty instances
                                    List<SupportPeople> filteredList =
                                        supportPeopleList.where((person) {
                                      return person.fullName != null &&
                                              person.fullName!.isNotEmpty ||
                                          person.emailAddress != null &&
                                              person.emailAddress!.isNotEmpty;
                                      // ||
                                      // person.phoneNumber != null &&
                                      //     person.phoneNumber!.isNotEmpty;
                                    }).toList();

                                    // Check if at least one instance is filled
                                    if (filteredList.isNotEmpty) {
                                      atLeastOneInstanceFilled = true;

                                      // Validate all filled instances
                                      for (int i = 0;
                                          i < filteredList.length;
                                          i++) {
                                        final person = filteredList[i];

                                        if (person.fullName == null ||
                                            person.fullName!.isEmpty ||
                                            person.emailAddress == null ||
                                            person.emailAddress!.isEmpty ||
                                            // person.phoneNumber == null ||
                                            person.phoneNumber!.isEmpty) {
                                          allFilledInstancesValid = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Please fill all fields for Support Person ${i + 1}.'),
                                            ),
                                          );
                                          break; // Stop checking further instances
                                        }
                                      }
                                    }

                                    if (!atLeastOneInstanceFilled) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'At least one support person is required.'),
                                        ),
                                      );
                                    } else if (allFilledInstancesValid) {
                                      // Send only the filtered list to the API
                                      bloc.add(EditSupportPeopleEvent(
                                          supPeople: filteredList));
                                    }
                                  },
                                  text: 'Submit',
                                ),
                                Constant.verticalSpace(20.h),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PersonData extends StatelessWidget {
  const PersonData({
    super.key,
    required this.supportPeopleModel1,
    required this.bloc,
  });

  final SupportPeople supportPeopleModel1;
  final GoalsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<GoalsBloc, GoalsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Constant.verticalSpace(16.h),
              Text("Full Name", style: context.textTheme.titleMedium),
              Constant.verticalSpace(8.h),
              PrimaryTextField(
                characterLimit: 30,
                inputFormatters: [NameInputFormatter()],
                initialValue: supportPeopleModel1.fullName,
                hintText: 'Enter Name',
                validator: validateName,
                readOnly: supportPeopleModel1.fullName != null ? true : false,
                onChanged: (p0) {
                  supportPeopleModel1.fullName = p0;
                },
              ),
              Text("Email Address", style: context.textTheme.titleMedium),
              Constant.verticalSpace(8.h),
              PrimaryTextField(
                  initialValue: supportPeopleModel1.emailAddress,
                  hintText: 'Enter Email Address',
                  readOnly:
                      supportPeopleModel1.emailAddress != null ? true : false,
                  validator: validateEmail,
                  characterLimit: 255,
                  inputType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ], // Deny spaces
                  onChanged: (p0) {
                    supportPeopleModel1.emailAddress = p0;
                  }),
              // Text("Phone Number", style: context.textTheme.titleMedium),
              // Constant.verticalSpace(8.h),
              // PrimaryTextField(
              //     initialValue: Constant.formatPhoneNumber(
              //         supportPeopleModel1.phoneNumber),
              //     hintText: 'Phone Number',
              //     readOnly:
              //         supportPeopleModel1.phoneNumber != null ? true : false,
              //     validator: validateMobile,
              //     inputType: TextInputType.number,
              //     inputFormatters: [
              //       // Adding the custom phone number formatter
              //       FilteringTextInputFormatter.digitsOnly, //
              //       PhoneNumberFormatter()
              //     ],
              //     onChanged: (p0) {
              //       supportPeopleModel1.phoneNumber = p0;
              //       print("+1${supportPeopleModel1.phoneNumber}");
              //     }),
              Constant.verticalSpace(10.h),
            ],
          );
        },
      ),
    );
  }
}
