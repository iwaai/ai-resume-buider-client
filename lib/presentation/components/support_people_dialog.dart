import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/models/get_resume_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../blocs/home/resume_builder/resume_builder_bloc.dart';
import '../../models/add_support_people_model.dart';
import '../../services/resume_pdf_generator.dart';
// import '../../services/pdf_generation.dart';

class SupportPeopleDialog extends StatelessWidget {
  SupportPeopleDialog(
      {super.key,
      required this.bloc,
      required this.resumeId,
      required this.resume});

  final ResumeBuilderBloc bloc;
  final String resumeId;
  final ResumeModel resume;

  TextEditingController fullName = TextEditingController();
  TextEditingController fullName2 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController phone2 = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: SizedBox(
        height: 650.h,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Add Support Network',
                  style: context.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Text(
                    textAlign: TextAlign.center,
                    'Connect with individuals who can support you on your journey towards achieving your goals.',
                    style: context.textTheme.bodyMedium),
                SizedBox(height: 10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Support person  1',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      'Full Name',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        characterLimit: 30,
                        inputFormatters: [NameInputFormatter()],
                        validator: validateName,
                        controller: fullName,
                        hintText: 'Enter Full Name'),
                    Text(
                      'Email Address',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        validator: validateEmail,
                        controller: email,
                        characterLimit: 255,
                        inputType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        hintText: 'Enter Email Address'),
                    Text(
                      'Phone',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        inputType: TextInputType.phone,
                        validator: validateField,
                        inputFormatters: [PhoneNumberFormatter()],
                        // validator: valida  validator: validateField,
                        controller: phone,
                        hintText: 'Enter Phone'),
                    const Divider(),
                    Row(
                      children: [
                        Text('Support person  2',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(' (Optional)',
                            style: context.textTheme.bodySmall
                                ?.copyWith(color: AppColors.secondaryColor)),
                      ],
                    ),
                    Text(
                      'Full Name',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        characterLimit: 30,
                        inputFormatters: [
                          NameInputFormatter()
                        ], // validator: validateName,
                        controller: fullName2,
                        hintText: 'Enter Full Name'),
                    Text(
                      'Email Address',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        characterLimit: 255,
                        inputType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        controller: email2,
                        hintText: 'Enter Email Address'),
                    Text(
                      'Phone',
                      style: context.textTheme.titleMedium,
                    ),
                    PrimaryTextField(
                        inputType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, //
                          PhoneNumberFormatter()
                        ],
                        controller: phone2,
                        hintText: 'Enter Phone'),
                  ],
                ),
                BlocBuilder<ResumeBuilderBloc, ResumeBuilderState>(
                  builder: (context, state) {
                    return PrimaryButton(
                        loading: state.loading,
                        onPressed: () async {
                          if (_globalKey.currentState?.validate() == true) {
                            List<SupportPerson> supportPersons = [];
                            if (fullName.text.isNotEmpty &&
                                email.text.isNotEmpty &&
                                phone.text.isNotEmpty) {
                              supportPersons.add(SupportPerson(
                                fullName: fullName.text.trim(),
                                emailAddress: email.text.trim(),
                                phoneNumber: phone.text.trim(),
                              ));
                            }
                            if (fullName2.text.isNotEmpty &&
                                email2.text.isNotEmpty &&
                                phone2.text.isNotEmpty) {
                              supportPersons.add(SupportPerson(
                                fullName: fullName2.text.trim(),
                                emailAddress: email2.text.trim(),
                                phoneNumber: phone2.text.trim(),
                              ));
                            }
                            final File? pdf = await generateAndDownloadPdf(
                                resume,
                                isEmail: true);

                            final model = AddSupportPeopleModel().copyWith(
                                resumeId: resumeId,
                                resume: pdf,
                                supportPeople: [...supportPersons]);
                            context
                                .read<ResumeBuilderBloc>()
                                .add(SendToSupportPeopleEvent(
                                  model: model,
                                ));
                          }
                          // context.pop();
                        },
                        text: 'Submit');
                  },
                ),
                SizedBox(height: 10.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
