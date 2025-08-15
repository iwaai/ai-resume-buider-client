import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class SetNewPasswordScreen extends StatelessWidget {
  SetNewPasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
        child: Scaffold(
      appBar: const CustomAppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.result.event is ResetPassword &&
              state.result.status == ResultStatus.error) {
            SnackbarsType.error(context, state.result.message);
          }
          if (state.result.event is ResetPassword &&
              state.result.status == ResultStatus.successful) {
            SnackbarsType.success(context, state.result.message);
            context.go(AppRoutes.successScreen, extra: 'forgotPassword');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constant.horizontalPadding.w,
                vertical: Constant.verticalPadding.h),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetConstants.verifyOTPIcon,
                      width: 121.w,
                    ),
                    Constant.verticalSpace(20),
                    Text(
                      "Set New Password",
                      style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor),
                    ),
                    Constant.verticalSpace(16),
                    Constant.verticalSpace(20),
                    PrimaryTextField(
                      obscureText: true,
                      hintText: "New Password",
                      controller: _newPasswordController,
                      isPassword: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')), // Deny spaces
                      ],
                      validator: validatePassword,
                      characterLimit: 30,
                    ),
                    PrimaryTextField(
                      hintText: "Confirm New Password",
                      obscureText: true,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      characterLimit: 30,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')), // Deny spaces
                      ],
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    Constant.verticalSpace(20),
                    PrimaryButton(
                      loading: state.loading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthBloc>().add(
                                ResetPassword(
                                  password: _newPasswordController.text.trim(),
                                  confirmPAssword:
                                      _confirmPasswordController.text.trim(),
                                ),
                              );
                        }
                      },
                      text: "Save",
                      textSize: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
