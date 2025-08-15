// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
// import 'package:second_shot/models/goal_model.dart';
// import 'package:second_shot/presentation/components/components_barrels.dart';
// import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
// import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
// import 'package:second_shot/utils/constants/constant.dart';
// import 'package:second_shot/utils/constants/validators.dart';
// import 'package:second_shot/utils/extensions.dart';

// class SupportPeopleScreen extends StatelessWidget {
//   SupportPeopleScreen({super.key, required this.bloc});

//   final AddGoalBloc bloc;
//   final _key = GlobalKey<FormState>();

//   final SupportPeople supportPeopleModel1 = SupportPeople();
//   final SupportPeople supportPeopleModel2 = SupportPeople();
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: bloc,
//       child: ScaffoldWrapper(
//         child: Scaffold(body: BlocBuilder<AddGoalBloc, AddGoalState>(
//           builder: (context, state) {
//             return CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   backgroundColor: Colors.transparent,
//                   title: Text('Add Support Network',
//                       style: context.textTheme.titleMedium
//                           ?.copyWith(fontSize: 16.sp)),
//                   leading: GestureDetector(
//                     onTap: () => context.pop(),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: AppColors.blackColor,
//                     ),
//                   ),
//                   centerTitle: true,
//                 ),
//                 Form(
//                   key: _key,
//                   child: SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: Constant.horizontalPadding.w,
//                           vertical: Constant.verticalPadding.h / 2),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(
//                             "Connect with individuals who can support you on your journey towards achieving your goals.",
//                             style: context.textTheme.titleMedium
//                                 ?.copyWith(fontSize: 15.sp),
//                           ),
//                           Constant.verticalSpace(16.h),
//                           Text(
//                             "Support Person 1",
//                             style: context.textTheme.titleMedium
//                                 ?.copyWith(fontSize: 16.sp),
//                           ),
//                           PersonData(
//                             supportPeopleModel1: supportPeopleModel1,
//                             bloc: bloc,
//                           ),
//                           Constant.verticalSpace(8.h),
//                           Text(
//                             "Support Person 2",
//                             style: context.textTheme.titleMedium
//                                 ?.copyWith(fontSize: 16.sp),
//                           ),
//                           PersonData(
//                             supportPeopleModel1: supportPeopleModel2,
//                             bloc: bloc,
//                           ),
//                           Constant.verticalSpace(20.h),
//                           PrimaryButton(
//                             onPressed: () {
//                               // Ensure SupportPeopleModel objects are properly updated with user inputs
//                               bool isPerson1Filled = supportPeopleModel1
//                                           .fullName?.isNotEmpty ==
//                                       true ||
//                                   supportPeopleModel1
//                                           .emailAddress?.isNotEmpty ==
//                                       true ||
//                                   supportPeopleModel1.phoneNumber?.isNotEmpty ==
//                                       true;

//                               bool isPerson2Filled = supportPeopleModel2
//                                           .fullName?.isNotEmpty ==
//                                       true ||
//                                   supportPeopleModel2
//                                           .emailAddress?.isNotEmpty ==
//                                       true ||
//                                   supportPeopleModel2.phoneNumber?.isNotEmpty ==
//                                       true;

//                               if (isPerson1Filled) {
//                                 if (supportPeopleModel1.fullName?.isEmpty !=
//                                         false ||
//                                     supportPeopleModel1.emailAddress?.isEmpty !=
//                                         false ||
//                                     supportPeopleModel1.phoneNumber?.isEmpty !=
//                                         false) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Please fill all fields for Support Person 1.'),
//                                     ),
//                                   );
//                                   return;
//                                 } else {
//                                   // Add Person 1 to the bloc
//                                   bloc.add(AddSupportPeople(
//                                       supportPeople: supportPeopleModel1));
//                                 }
//                               }

//                               if (isPerson2Filled) {
//                                 if (supportPeopleModel2.fullName?.isEmpty !=
//                                         false ||
//                                     supportPeopleModel2.emailAddress?.isEmpty !=
//                                         false ||
//                                     supportPeopleModel2.phoneNumber?.isEmpty !=
//                                         false) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Please fill all fields for Support Person 2.'),
//                                     ),
//                                   );
//                                   return;
//                                 } else {
//                                   bloc.add(AddSupportPeople(
//                                       supportPeople: supportPeopleModel2));
//                                 }
//                               }

//                               // Navigate to the next screen if at least one person is added
//                               if (isPerson1Filled || isPerson2Filled) {
//                                 debugPrint(
//                                     'Person 1: ${supportPeopleModel1.toJson()}');
//                                 debugPrint(
//                                     'Person 2: ${supportPeopleModel2.toJson()}');
//                                 context.pop(); // Replace with the actual route
//                               } else {
//                                 context.pop();
//                               }
//                             },
//                             text: 'Save',
//                           ),
//                           Constant.verticalSpace(20.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           },
//         )),
//       ),
//     );
//   }
// }

// class PersonData extends StatelessWidget {
//   const PersonData({
//     super.key,
//     required this.supportPeopleModel1,
//     required this.bloc,
//   });

//   final SupportPeople supportPeopleModel1;
//   final AddGoalBloc bloc;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: bloc,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Constant.verticalSpace(16.h),
//           Text("Full Name", style: context.textTheme.titleMedium),
//           Constant.verticalSpace(8.h),
//           PrimaryTextField(
//             initialValue: supportPeopleModel1.fullName,
//             characterLimit: 30,
//             inputFormatters: [NameInputFormatter()],
//             hintText: 'Enter Name',
//             validator: validateName,
//             onChanged: (p0) {
//               supportPeopleModel1.fullName = p0;
//             },
//           ),
//           Text("Email Address", style: context.textTheme.titleMedium),
//           Constant.verticalSpace(8.h),
//           PrimaryTextField(
//               initialValue: supportPeopleModel1.emailAddress,
//               hintText: 'Enter Email Address',
//               characterLimit: 255,
//               inputType: TextInputType.emailAddress,
//               inputFormatters: [
//                 FilteringTextInputFormatter.deny(
//                   RegExp(r'\s'),
//                 ),
//               ], // Deny spaces
//               validator: validateEmail,
//               onChanged: (p0) {
//                 supportPeopleModel1.emailAddress = p0;
//               }),
//           Text("Phone Number", style: context.textTheme.titleMedium),
//           Constant.verticalSpace(8.h),
//           PrimaryTextField(
//               initialValue: supportPeopleModel1.phoneNumber,
//               hintText: 'Phone Number',
//               validator: validateMobile,
//               inputType: TextInputType.number,
//               inputFormatters: [
//                 // Adding the custom phone number formatter
//                 FilteringTextInputFormatter.digitsOnly, //
//                 PhoneNumberFormatter()
//               ],
//               onChanged: (p0) {
//                 supportPeopleModel1.phoneNumber = p0;
//                 debugPrint("+1${supportPeopleModel1.phoneNumber}");
//               }),
//           Constant.verticalSpace(10.h),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class SupportPeopleScreen extends StatelessWidget {
  SupportPeopleScreen({super.key, required this.bloc});

  final AddGoalBloc bloc;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: ScaffoldWrapper(
        child: Scaffold(
          body: BlocBuilder<AddGoalBloc, AddGoalState>(
            builder: (context, state) {
              List<SupportPeople> supportPeopleList =
                  List<SupportPeople>.from(state.supportPeople);

              if (supportPeopleList.length < 2) {
                int itemsToAdd = 2 - supportPeopleList.length;
                supportPeopleList.addAll(
                  List.generate(itemsToAdd, (index) => SupportPeople()),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    title: Text('Add Support Network',
                        style: context.textTheme.titleMedium
                            ?.copyWith(fontSize: 16.sp)),
                    leading: GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.blackColor,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  Form(
                    key: _key,
                    child: SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constant.horizontalPadding.w,
                            vertical: Constant.verticalPadding.h / 2),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Support Person ${index + 1}",
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(fontSize: 16.sp),
                                  ),
                                  PersonData(
                                    supportPeopleModel:
                                        supportPeopleList[index],
                                    index: index,
                                    bloc: bloc,
                                  ),
                                ],
                              ),
                            ),
                            Constant.verticalSpace(60.h),
                            PrimaryButton(
                              onPressed: () {
                                bool atLeastOneInstanceFilled = false;
                                bool allFilledInstancesValid = true;

                                List<SupportPeople> filteredList =
                                    supportPeopleList.where((person) {
                                  return (person.fullName?.isNotEmpty ??
                                          false) ||
                                      (person.emailAddress?.isNotEmpty ??
                                          false);
                                  //      ||
                                  // (person.phoneNumber?.isNotEmpty ?? false);
                                }).toList();

                                if (filteredList.isNotEmpty) {
                                  atLeastOneInstanceFilled = true;

                                  for (int i = 0;
                                      i < filteredList.length;
                                      i++) {
                                    final person = filteredList[i];
                                    if ((person.fullName?.isEmpty ?? true) ||
                                            (person.emailAddress?.isEmpty ??
                                                true)
                                        // ||
                                        // (person.phoneNumber?.isEmpty ?? true)
                                        ) {
                                      allFilledInstancesValid = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please fill all fields for Support Person ${i + 1}.'),
                                        ),
                                      );
                                      break;
                                    }
                                  }
                                }

                                if (!atLeastOneInstanceFilled) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'At least one support person is required.'),
                                    ),
                                  );
                                } else if (allFilledInstancesValid) {
                                  bloc.add(AddSupportPeople(
                                      supportPeople: filteredList));
                                  context.pop();
                                }
                              },
                              text: 'Save',
                            ),
                            Constant.verticalSpace(20.h),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PersonData extends StatelessWidget {
  const PersonData({
    super.key,
    required this.supportPeopleModel,
    required this.bloc,
    required this.index,
  });

  final SupportPeople supportPeopleModel;
  final AddGoalBloc bloc;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Constant.verticalSpace(16.h),
        Text("Full Name", style: context.textTheme.titleMedium),
        Constant.verticalSpace(8.h),
        PrimaryTextField(
          initialValue: supportPeopleModel.fullName,
          characterLimit: 30,
          inputFormatters: [NameInputFormatter()],
          hintText: 'Enter Name',
          validator: validateName,
          onChanged: (p0) {
            supportPeopleModel.fullName = p0;
          },
        ),
        Text("Email Address", style: context.textTheme.titleMedium),
        Constant.verticalSpace(8.h),
        PrimaryTextField(
          initialValue: supportPeopleModel.emailAddress,
          hintText: 'Enter Email Address',
          characterLimit: 255,
          inputType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          validator: validateEmail,
          onChanged: (p0) {
            supportPeopleModel.emailAddress = p0;
          },
        ),
        // Text("Phone Number", style: context.textTheme.titleMedium),
        // Constant.verticalSpace(8.h),
        // PrimaryTextField(
        //   initialValue: supportPeopleModel.phoneNumber,
        //   hintText: 'Phone Number',
        //   validator: validateMobile,
        //   inputType: TextInputType.number,
        //   inputFormatters: [
        //     FilteringTextInputFormatter.digitsOnly,
        //     PhoneNumberFormatter(),
        //   ],
        //   onChanged: (p0) {
        //     supportPeopleModel.phoneNumber = p0;
        //   },
        // ),
        Constant.verticalSpace(10.h),
      ],
    );
  }
}
