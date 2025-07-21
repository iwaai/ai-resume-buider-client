part of '../components/library_resume_builder.dart';

class Step1Information extends StatelessWidget {
  Step1Information({super.key});

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController website = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateResumeBloc, CreateResumeState>(
      builder: (context, state) {
        final createResumeModel = state.createResumeModel;
        return Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTextfield(
                validator: validateName,
                characterLimit: 30,
                textInputFormatters: [NameInputFormatter()],
                controller: fullName =
                    TextEditingController(text: createResumeModel.fullName),
                title: "Full Name",
                hintText: "Enter your Name",
              ),
              EditProfileTextfield(
                validator: validateEmail,
                textInputType: TextInputType.emailAddress,
                textInputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(r'\s')), // Deny spaces
                ],
                characterLimit: 256,
                controller: email =
                    TextEditingController(text: createResumeModel.email),
                title: "Email",
                hintText: "Enter your Email",
              ),
              EditProfileTextfield(
                validator: validateMobile,
                characterLimit: 16,
                textInputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneNumberFormatter()
                ],
                textInputType: TextInputType.phone,
                controller: phone = TextEditingController(
                    text: (createResumeModel.phone ?? "")),
                title: "Phone",
                hintText: "Enter your Phone",
              ),
              EditProfileTextfield(
                characterLimit: 50,
                controller: website =
                    TextEditingController(text: createResumeModel.address),
                showOptionalText: true,
                title: "Website",
                hintText: "Enter your Website",
              ),
              TipsWidget(
                step: state.step,
              ),
              SizedBox(height: 8.h),
              PrimaryButton(
                onPressed: () {
                  if (_globalKey.currentState?.validate() == true) {
                    if (fullName.text.isEmpty ||
                        email.text.isEmpty ||
                        phone.text.isEmpty ||
                        phone.text.length <= 13) {
                      SnackbarsType.error(
                          context, 'Please fill required fields!');
                    } else {
                      context.read<CreateResumeBloc>().add(StepIncrement());
                      final model = createResumeModel.copyWith(
                        fullName: fullName.text,
                        email: email.text,
                        phone: phone.text,
                        address: website.text,
                      );
                      context
                          .read<CreateResumeBloc>()
                          .add(UpdateResumeDataEvent(createResumeModel: model));
                    }
                  }
                },
                text: 'Next',
              ),
            ],
          ),
        );
      },
    );
  }
}
