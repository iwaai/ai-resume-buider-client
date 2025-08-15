import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/registration_questions/components/registration_stepper.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/questions_renderer.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../blocs/app/app_bloc.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///The changes being done on 9-April-2025 are under the fact that
    ///the client has asked for these changes, hence being commented now.
    ///might be permanently removed later

    ///Here we will check if User data is not null in local storage
    ///If so, we will assign values while creating bloc
    return BlocProvider.value(
      value: context.read<RegistrationQuestionsBloc>()
        ..add(GetRegistrationQuestionsDataEvent()),
      child: ScaffoldWrapper(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: BlocBuilder<RegistrationQuestionsBloc,
                  RegistrationQuestionsState>(builder: (context, state) {
                return CustomAppBar(
                  trailingIcon: context
                          .read<AppBloc>()
                          .state
                          .user
                          .isRegistrationQuestionCompleted
                      ? null
                      : [
                          IconButton(
                              onPressed: () {
                                CommonDialog(
                                  customDialog: Padding(
                                    padding: EdgeInsets.only(top: 14.0.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Logout',
                                          style:
                                              context.textTheme.headlineSmall,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          'Are you sure you want to Logout?',
                                          style:
                                              TextStyle(color: AppColors.grey),
                                        ),
                                        SizedBox(
                                          height: 18.h,
                                        ),
                                        Row(
                                          children: List.generate(
                                            2,
                                            (i) => Expanded(
                                                child: Padding(
                                              padding: i.isEven
                                                  ? EdgeInsets.only(
                                                      right: 4.0.w)
                                                  : EdgeInsets.only(
                                                      left: 4.0.w),
                                              child: BlocConsumer<AuthBloc,
                                                      AuthState>(
                                                  listener: (context, state) {
                                                if (state.result.event
                                                        is Logout &&
                                                    state.result.status ==
                                                        ResultStatus.error) {
                                                  SnackbarsType.error(context,
                                                      state.result.message);
                                                }
                                                if (state.result.event
                                                        is Logout &&
                                                    state.result.status ==
                                                        ResultStatus
                                                            .successful) {
                                                  SnackbarsType.success(context,
                                                      state.result.message);
                                                  context.go(AppRoutes.login);
                                                }
                                              }, builder: (context, state) {
                                                return PrimaryButton(
                                                    loading:
                                                        state.loading && i == 1,
                                                    textColor: i.isEven
                                                        ? AppColors.blackColor
                                                        : AppColors.whiteColor,
                                                    buttonColor: i.isEven
                                                        ? AppColors.grey
                                                            .withOpacity(0.5)
                                                        : AppColors
                                                            .primaryColor,
                                                    onPressed: () {
                                                      i.isEven
                                                          ? context.pop()
                                                          : context
                                                              .read<AuthBloc>()
                                                              .add(Logout());
                                                    },
                                                    text: i.isEven
                                                        ? 'No'
                                                        : 'Yes');
                                              }),
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ).showCustomDialog(context);
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: AppColors.redColor,
                              ))
                        ],
                );
              })),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Center(
                    child: Image.asset(
                      AssetConstants.appLogo,
                      // height: 122.h,
                      width: 176.w,
                    ),
                  ),
                  Text(
                    'Registration Questions',
                    style: context.textTheme.headlineMedium!.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Please answer a few quick registration questions\nto help build out your profile.',
                      style: context.textTheme.titleMedium!.copyWith(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BlocBuilder<RegistrationQuestionsBloc,
                      RegistrationQuestionsState>(builder: (context, state) {
                    if (state.loading && state.q9Answer == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        children: [
                          const RegistrationStepper(),
                          const QuestionRenderer(),
                          if (state.step > 1)
                            TextButton(
                                onPressed: () {
                                  if (state.step > 1) {
                                    context
                                        .read<RegistrationQuestionsBloc>()
                                        .add(PreviousStepEvent());
                                  }
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
