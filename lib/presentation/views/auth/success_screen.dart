import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.arg});

  final String arg;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String title = '';
  String icon = '';
  String description = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (widget.arg == 'signUp') {
          context.go(AppRoutes.subscriptionScreen);
        } else if (widget.arg == 'forgotPassword') {
          context.go(AppRoutes.login);
          // context.push(AppRoutes.uploadProfilePictureScreen);
        } else if (widget.arg == 'profileCompleted') {
          context
            ..read<RegistrationQuestionsBloc>().add(EmptyFormEvent())
            ..go(AppRoutes.registration);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Widegt.arg = ${widget.arg}");
    if (widget.arg == 'signUp') {
      title = "Email & Phone Number Verified";
      description = "Your email & phone number has been verified!";
      icon = AssetConstants.tickMarkGreenIcon;
    } else if ((widget.arg == 'forgotPassword')) {
      title = "Password Updated";
      description = "Your password has been updated successfully!";
      icon = AssetConstants.tickMarkIcon;
    } else if (widget.arg == 'profileCompleted') {
      title = "Account Created";
      description = "Your account has been created successfully!";
      icon = AssetConstants.tickMarkGreenIcon;
    }
    return ScaffoldWrapper(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.horizontalPadding * 2.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  icon,
                  height: 120.h,
                  width: 120.w,
                ),
                Constant.verticalSpace(12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28.sp,
                  ),
                ),
                Constant.verticalSpace(12),
                Text(
                  textAlign: TextAlign.center,
                  description,
                  style:
                      context.textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
