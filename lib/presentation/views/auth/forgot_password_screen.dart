import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../router/route_constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        appBar: const CustomAppBar(
          isBackButton: true,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.result.event is ForgotPassword &&
                state.result.status == ResultStatus.error) {
              SnackbarsType.error(context, state.result.message);
            }
            if (state.result.event is ForgotPassword &&
                state.result.status == ResultStatus.successful) {
              SnackbarsType.success(context, state.result.message);
              context.push(AppRoutes.verifyOtp, extra: 'login');
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constant.horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Image.asset(
                                  AssetConstants.forgotPasswordImage,
                                  width: 121.w,
                                ),
                                Constant.verticalSpace(20),
                                Text(
                                  "Forgot Password",
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor),
                                ),
                                Constant.verticalSpace(20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Constant.horizontalPadding),
                                  child: Text(
                                    "Enter your registered email address, and we’ll send you an OTP to reset your password.",
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(color: AppColors.blackColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Constant.verticalSpace(20),
                                PrimaryTextField(
                                  controller: emailController,
                                  hintText: "Email Address",
                                  validator: validateEmail,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')), // Deny spaces
                                  ],
                                ),
                                Constant.verticalSpace(12),
                                PrimaryButton(
                                  loading: state.loading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                            ForgotPassword(
                                                email: emailController.text),
                                          );
                                    }
                                  },
                                  text: "Send",
                                  textSize: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom),
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
