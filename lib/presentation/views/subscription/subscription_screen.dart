import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/blocs/subscription/subscription_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../router/route_constants.dart';
import '../auth/Components/subscripstion_plans_widget.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, required this.isSubscribed});
  final bool isSubscribed;
  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    return BlocProvider.value(
      value: context.read<SubscriptionBloc>()
    ..add(InitializeSubscriptionEvent())
    ..isCalled = false,
      child: ScaffoldWrapper(
        child: Scaffold(
          appBar: CustomAppBar(
            isBackButton: user.isRegistrationQuestionCompleted,
            title: 'Subscription Plan',
          ),
          body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
              listener: (context, state) {
            if (state.result != null) {
              if (state.result!.event is BuySubscriptionEvent &&
                  state.result!.status == ResultStatus.error) {
                SnackbarsType.error(context, state.result!.message);
              }
              if (state.result!.event is InitializeSubscriptionEvent &&
                  state.result!.status == ResultStatus.error) {
                SnackbarsType.error(context, state.result!.message);
              }

              if (state.result!.event is InitializeSubscriptionEvent &&
                  state.result!.status == ResultStatus.successful) {
                print('Dialog shown on success');
                CommonDialog(
                        imageHeight: 74.h,
                        okBtnFunction: () {
                          print(user.toJson());
                          if (user.isProfileCompleted == true &&
                              user.isRegistrationQuestionCompleted == true) {
                            context
                              ..read<AuthBloc>().add(GetUserProfile())
                              ..go(AppRoutes.homeScreen);
                          } else if (user.isProfileCompleted == false) {
                            context.go(AppRoutes.uploadProfilePictureScreen);
                          } else if (user.isRegistrationQuestionCompleted ==
                              false) {
                            context
                              ..read<RegistrationQuestionsBloc>()
                                  .add(EmptyFormEvent())
                              ..go(AppRoutes.registration);
                          }
                        },
                        okBtnText: 'Get Started',
                        barrierDismissible: false,
                        title: "Your Career Prep Toolbox has been unlocked",
                        body:
                            """Your subscription has been successfully unlocked. You now have full access to all features and benefits. If you have any questions, contact tech@resumate.com""",
                        image: AssetConstants.tickMarkGreenIcon)
                    .showCustomDialog(context);
              }
            }
          }, builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: state.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: EdgeInsets.all(16.sp).copyWith(bottom: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose from one of our subscription plans to suit your needs. For assistance contact tech@resumate.com.',
                                style: context.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10.h,
                                ),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      context.read<SubscriptionBloc>().add(
                                          SelectAPlanEvent(
                                              plan: state.products[index]));
                                    },
                                    child: SubscriptionsPlansWidget(
                                      isSelected: state.selectedPlan?.id ==
                                          state.products[index].id,
                                      productDetails: state.products[index],
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              PrimaryButton(
                                  loading: state.loading,
                                  onPressed: () {
                                    if (state.selectedPlan != null) {
                                      if (user.isSubscriptionPaid == false) {
                                        context
                                            .read<SubscriptionBloc>()
                                            .add(BuySubscriptionEvent());
                                      }
                                      if (user.isSubscriptionPaid == true) {
                                        SnackbarsType.error(context,
                                            'Please cancel your current plan and restart app to resubscribe!');
                                      }
                                    } else {
                                      SnackbarsType.error(context,
                                          'Please Select a Subscription Plan!');
                                    }
                                  },
                                  text: 'Buy Now'),
                              SizedBox(height: 10.h),
                              // if (!context
                              //     .read<AppBloc>()
                              //     .state
                              //     .user
                              //     .isRegistrationQuestionCompleted)
                              if (user.isSubscriptionPaid == false &&
                                  GoRouter.of(context)
                                          .routeInformationProvider
                                          .value
                                          .uri
                                          .toString() !=
                                      AppRoutes.homeScreen)
                                PrimaryButton(
                                    buttonColor: Colors.transparent,
                                    textColor: AppColors.primaryColor,
                                    borderColor: AppColors.primaryColor,
                                    onPressed: () {
                                      if (user.isProfileCompleted == false) {
                                        context.go(AppRoutes
                                            .uploadProfilePictureScreen);
                                      } else if (user
                                              .isRegistrationQuestionCompleted ==
                                          false) {
                                        context
                                          ..read<RegistrationQuestionsBloc>()
                                              .add(EmptyFormEvent())
                                          ..go(AppRoutes.registration);
                                      } else {
                                        context.go(AppRoutes.homeScreen);
                                      }
                                    },
                                    text: 'Try it for free.'),
                              if (user.isSubscriptionPaid == true)
                                PrimaryButton(
                                    buttonColor: Colors.transparent,
                                    textColor: AppColors.primaryColor,
                                    borderColor: AppColors.primaryColor,
                                    onPressed: () {
                                      Platform.isIOS
                                          ? launchUrl(Uri.parse(
                                              "https://apps.apple.com/account/subscriptions"))
                                          : launchUrl(Uri.parse(
                                              'https://play.google.com/store/account/subscriptions'));
                                    },
                                    text: 'Cancel Subscription'),
                            ],
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
