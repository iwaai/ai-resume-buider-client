import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.arg});

  final String arg;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 60;

  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("Arg is ${widget.arg}");
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.result.event is VerifyOtp &&
            state.result.status == ResultStatus.error) {
          SnackbarsType.error(context, state.result.message);
        }
        if (state.result.event is VerifyOtp &&
            state.result.status == ResultStatus.successful) {
          if (widget.arg == 'signUp') {
            context.read<AuthBloc>().add(GetUserProfile());
            context.push(AppRoutes.successScreen, extra: widget.arg);
          } else if (widget.arg == 'login') {
            context.push(AppRoutes.setNewPassword);
          }
        }
        if (state.result.event is ResendOtp &&
            state.result.status == ResultStatus.error) {
          _pinController.clear();

          SnackbarsType.error(context, state.result.message);
        }
        if (state.result.event is VerifyOtp &&
            state.result.status == ResultStatus.error) {
          _pinController.clear();

          SnackbarsType.error(context, state.result.message);
        }
        if (state.result.event is ResendOtp &&
            state.result.status == ResultStatus.successful) {
          SnackbarsType.success(context, state.result.message);
        }
      },
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state.loading,
          child: ScaffoldWrapper(
            child: Scaffold(
              appBar: const CustomAppBar(
                isOnlybackButton: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constant.horizontalPadding,
                ),
                child: Form(
                  key: _formkey,
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
                          "Verify OTP",
                          style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor),
                        ),
                        Constant.verticalSpace(16),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: 'The code was sent to',
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.blackColor),
                              children: [
                                TextSpan(
                                  text: ' ${state.email.toLower()}',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        ),
                        Constant.verticalSpace(20),
                        Text(
                          _secondsRemaining > 0
                              ? '00:$_secondsRemaining '
                              : '00:00',
                          style: context.textTheme.titleMedium
                              ?.copyWith(fontSize: 15.sp),
                        ),
                        Constant.verticalSpace(20),
                        Pinput(
                          forceErrorState: true,
                          controller: _pinController,
                          keyboardType: TextInputType.phone,
                          length: 6, // Number of OTP digits
                          defaultPinTheme: PinTheme(
                            width: 52.w,
                            height: 49.h,
                            textStyle: context.textTheme.labelLarge
                                ?.copyWith(fontSize: 15.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Ensures only digits are entered
                          ],
                          onCompleted: (pin) {
                            debugPrint("OTP entered: $pin");
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter OTP';
                            } else if (value.length < 6) {
                              return 'OTP must be 6 digits long';
                            } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'OTP must contain only numbers';
                            }
                            return null;
                          },
                          onChanged: (pin) {
                            if (pin.length < 6) {
                              debugPrint('OTP must be 6 digits long');
                            }
                          },
                        ),
                        Constant.verticalSpace(20),
                        PrimaryButton(
                          loading: state.loading,
                          onPressed: () {
                            debugPrint(_pinController.text);
                            debugPrint("===>${widget.arg}");

                            if (_formkey.currentState!.validate()) {
                              if (widget.arg == 'signUp') {
                                context.read<AuthBloc>().add(VerifyOtp(
                                    email: state.email,
                                    otp: _pinController.text,
                                    type: 'signup'));
                              } else if (widget.arg == 'login') {
                                context.read<AuthBloc>().add(
                                      VerifyOtp(
                                          email: state.email.trim(),
                                          otp: _pinController.text.trim()),
                                    );
                              }
                            }
                          },
                          text: "Verify",
                          textSize: 16.sp,
                        ),
                        Constant.verticalSpace(20),
                        RichText(
                          text: TextSpan(
                            text: "Did not receive code yet? ",
                            style: context.textTheme.bodyLarge,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Resend',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _secondsRemaining > 0
                                      ? () {
                                          debugPrint("not click");
                                        }
                                      : () {
                                          setState(() {
                                            _secondsRemaining = 60;
                                            _startTimer();
                                          });
                                          debugPrint("click success");
                                          context.read<AuthBloc>().add(
                                              ResendOtp(email: state.email));
                                        },
                                style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: _secondsRemaining > 0
                                        ? AppColors.grey
                                        : AppColors.blackColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
