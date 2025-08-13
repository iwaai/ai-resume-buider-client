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
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
        child: Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if ((state.result.event is Login &&
                  state.result.status == ResultStatus.error) ||
              (state.result.event is RegisterWithApple &&
                  state.result.status == ResultStatus.error) ||
              (state.result.event is RegisterWithGoogle &&
                  state.result.status == ResultStatus.error)) {
            SnackbarsType.error(context, state.result.message);
          }

          // If Login or Register With Google or Apple is successful, fetch the user profile
          if ((state.result.event is Login ||
                  state.result.event is RegisterWithGoogle ||
                  state.result.event is RegisterWithApple) &&
              state.result.status == ResultStatus.successful) {
            context.read<AuthBloc>().add(GetUserProfile());
          }

          // Handle User Profile Completion
          if (state.result.event is GetUserProfile &&
              state.result.status == ResultStatus.successful) {
            final user = context.read<AppBloc>().state.user;

            if (!user.isSubscriptionPaid) {
              context.go(AppRoutes.subscriptionScreen);
            } else if (!user.isProfileCompleted) {
              context.go(AppRoutes.uploadProfilePictureScreen);
            } else if (!user.isRegistrationQuestionCompleted) {
              context
                ..read<RegistrationQuestionsBloc>().add(EmptyFormEvent())
                ..go(AppRoutes.registration);
            } else {
              context.go(AppRoutes.homeScreen);
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.horizontalPadding),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Constant.verticalSpace(70.h),
                      Center(
                        child: Image.asset(
                          AssetConstants.appLogo,
                          width: 176.w,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Text(
                        "Welcome Back!",
                        style: context.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor),
                      ),
                      Constant.verticalSpace(8),
                      Text(
                        "Please enter the details to continue",
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Constant.verticalSpace(24.h),
                      PrimaryButton(
                        // loading: state.loading,
                        onPressed: () {
                          context.push(AppRoutes.signupScreen);
                        },
                        text: "Try It For Free",
                        textSize: 14.sp,
                      ),
                      Constant.verticalSpace(10.h),
                      PrimaryTextField(
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        characterLimit: 255,
                        hintText: "Email",
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')), // Deny spaces
                        ],
                        validator: validateEmail,
                      ),
                      PrimaryTextField(
                        inputType: TextInputType.visiblePassword,
                        characterLimit: 30,
                        controller: passController,
                        obscureText: true,
                        hintText: "Password",
                        isPassword: true,
                        validator: validatePassword,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')), // Deny spaces
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.forgotPassword);
                        },
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Forgot Password",
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                      Constant.verticalSpace(20),
                      PrimaryButton(
                        loading: state.loading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  Login(
                                    email:
                                        emailController.text.trim().toLower(),
                                    password: passController.text.trim(),
                                  ),
                                );
                          }
                        },
                        text: "Sign in",
                        textSize: 14.sp,
                      ),
                      Constant.verticalSpace(20),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //         child: Divider(
                      //       color: AppColors.grey,
                      //     )),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 12.w),
                      //       child: Text(
                      //         "OR",
                      //         style: context.textTheme.titleMedium
                      //             ?.copyWith(color: AppColors.blackColor),
                      //       ),
                      //     ),
                      //     Expanded(child: Divider(color: AppColors.grey))
                      //   ],
                      // ),
                      // Constant.verticalSpace(24.h),
                      // if (Platform.isIOS)
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     if (Platform.isIOS)
                      //       GestureDetector(
                      //         onTap: () => context
                      //             .read<AuthBloc>()
                      //             .add(RegisterWithApple()),
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
                      RichText(
                        text: TextSpan(
                          text: "Don’t have an account? ",
                          style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign Up',
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(AppRoutes.signupScreen);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
