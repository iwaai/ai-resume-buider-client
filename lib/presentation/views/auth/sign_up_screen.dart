import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/auth/Components/number_formate.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../utils/constants/constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final passController = TextEditingController();

  final confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.result.event is SignUp &&
                state.result.status == ResultStatus.error) {
              SnackbarsType.error(context, state.result.message);
            }
            if (state.result.event is SignUp &&
                state.result.status == ResultStatus.successful) {
              context.push(AppRoutes.verifyOtp, extra: 'signUp');
            }
            if (state.result.event is RegisterWithGoogle &&
                state.result.status == ResultStatus.error) {
              // context.read<AuthBloc>().add(GetUserProfile());
              SnackbarsType.error(context, state.result.message);
            }
            if (state.result.event is RegisterWithGoogle &&
                state.result.status == ResultStatus.successful) {
              context.read<AuthBloc>().add(GetUserProfile());
              if (state.result.event is GetUserProfile &&
                  state.result.status == ResultStatus.successful) {
                final user = context.read<AppBloc>().state.user;
                if (user.isSubscriptionPaid == false) {
                  context.go(AppRoutes.subscriptionScreen);
                } else if (user.isProfileCompleted == false) {
                  context.go(AppRoutes.uploadProfilePictureScreen);
                } else if (user.isRegistrationQuestionCompleted == false) {
                  context
                    ..read<RegistrationQuestionsBloc>().add(EmptyFormEvent())
                    ..go(AppRoutes.registration);
                } else {
                  context.go(AppRoutes.homeScreen);
                }
              }

              if (state.result.event is RegisterWithApple &&
                  state.result.status == ResultStatus.error) {
                // context.read<AuthBloc>().add(GetUserProfile());
                SnackbarsType.error(context, state.result.message);
              }
              if (state.result.event is RegisterWithApple &&
                  state.result.status == ResultStatus.successful) {
                context.read<AuthBloc>().add(GetUserProfile());
                if (state.result.event is GetUserProfile &&
                    state.result.status == ResultStatus.successful) {
                  final user = context.read<AppBloc>().state.user;
                  if (user.isSubscriptionPaid == false) {
                    context.go(AppRoutes.subscriptionScreen);
                  } else if (user.isProfileCompleted == false) {
                    context.go(AppRoutes.uploadProfilePictureScreen);
                  } else if (user.isRegistrationQuestionCompleted == false) {
                    context
                      ..read<RegistrationQuestionsBloc>().add(EmptyFormEvent())
                      ..go(AppRoutes.registration);
                  } else {
                    context.go(AppRoutes.homeScreen);
                  }
                }
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.horizontalPadding.h,
                    vertical: Constant.verticalPadding.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Constant.verticalSpace(40),
                      Center(
                        child: Image.asset(
                          AssetConstants.appLogo,
                          // width: 165.w,
                          width: 176.w,
                        ),
                      ),
                      Text(
                        "Sign Up",
                        style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.blackColor, fontSize: 24.sp),
                      ),
                      Constant.verticalSpace(16),
                      Text(
                        "Please enter the details to continue",
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Constant.verticalSpace(24),
                      PrimaryTextField(
                        hintText: "Full Name",
                        controller: fullNameController,
                        validator: validateName,
                        characterLimit: 30,
                        inputFormatters: [NameInputFormatter()],
                      ),

                      PrimaryTextField(
                        controller: emailController,
                        hintText: "Email Address",
                        validator: validateEmail,
                        characterLimit: 255,
                        inputType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')), // Deny spaces
                        ],
                      ),

                      PrimaryTextField(
                        controller: phoneNumberController,
                        hintText: "(123) 456-7890",
                        characterLimit: 16,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AssetConstants.flagIcon,
                                width: 24.w,
                                height: 16.h,
                              ),
                              const Text(" +1  "),
                              SizedBox(
                                height: 20.h,
                                child: const VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1, // Divider thickness
                                ),
                              )
                            ],
                          ),
                        ),
                        validator: validateMobile,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          // Adding the custom phone number formatter
                          FilteringTextInputFormatter.digitsOnly, //
                          PhoneNumberFormatter()
                        ],
                      ),

                      PrimaryTextField(
                        controller: passController,
                        obscureText: true,
                        hintText: "Password",
                        validator: validatePassword,
                        isPassword: true,
                        characterLimit: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r"\s")), // Prevent spaces
                        ],
                      ),
                      PrimaryTextField(
                        controller: confirmPassController,
                        obscureText: true,
                        hintText: "Confirm Password",
                        characterLimit: 30,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r"\s")), // Prevent spaces
                        ],
                        validator: (value) {
                          if (value != passController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      Constant.verticalSpace(20),
                      PrimaryButton(
                        loading: state.loading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUp(
                                    fullName: fullNameController.text,
                                    emailAddress:
                                        emailController.text.trim().toLower(),
                                    phoneNumber:
                                        "+1${sanitizePhoneNumber(phoneNumberController.text.trim())}",
                                    password: passController.text.trim(),
                                    confirmPass:
                                        confirmPassController.text.trim(),
                                  ),
                                );
                          }
                        },
                        text: "Sign Up",
                        textSize: 16.sp,
                      ),
                      // Constant.verticalSpace(20),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         color: AppColors.grey,
                      //         height: 10,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 8),
                      //       child: Text("OR",
                      //           style: context.textTheme.titleLarge
                      //               ?.copyWith(fontWeight: FontWeight.w500)),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         color: AppColors.grey,
                      //         height: 10,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Constant.verticalSpace(24.h),
                      // if (Platform.isIOS)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     if (Platform.isIOS)
                      //       GestureDetector(
                      //         onTap: () {
                      //           context
                      //               .read<AuthBloc>()
                      //               .add(RegisterWithApple());
                      //         },
                      //         child: Image.asset(
                      //           AssetConstants.appleIcon,
                      //           width: 49.w,
                      //           height: 49.h,
                      //         ),
                      //       ),
                      //     // if (Platform.isAndroid)
                      //     GestureDetector(
                      //       onTap: () {
                      //         context
                      //             .read<AuthBloc>()
                      //             .add(RegisterWithGoogle());
                      //       },
                      //       child: Image.asset(
                      //         AssetConstants.googleIcon,
                      //         width: 49.w,
                      //         height: 49.h,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Constant.verticalSpace(
                      //   24.h,
                      // ),
                      // // Constant.verticalSpace(24),
                      // RichText(
                      //   text: TextSpan(
                      //     text: "Already have an account? ",
                      //     style: context.textTheme.titleLarge?.copyWith(
                      //         fontWeight: FontWeight.w500,
                      //         color: AppColors.blackColor),
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //         text: 'Sign in',
                      //         style: context.textTheme.titleLarge?.copyWith(
                      //             fontWeight: FontWeight.w500,
                      //             color: AppColors.primaryColor),
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = () {
                      //             context.push(AppRoutes.login);
                      //           },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Constant.verticalSpace(20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "I agree to the ",
                          style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Term & Condition',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(AppRoutes.termsAndCondition);
                                },
                            ),
                            TextSpan(
                              text: ' & ',
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackColor),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(AppRoutes.privacyPolicy);
                                },
                            ),
                          ],
                        ),
                      ),
                      Constant.verticalSpace(24.h)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
