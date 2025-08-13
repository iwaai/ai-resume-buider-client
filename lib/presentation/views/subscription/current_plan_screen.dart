import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/subscription/subscription_bloc.dart';
import 'package:second_shot/models/user_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/auth/Components/subscripstion_plans_widget.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../router/route_constants.dart';

class CurrentPlanScreen extends StatelessWidget {
  const CurrentPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;

    return BlocProvider.value(
      value: context.read<SubscriptionBloc>()..add(GetUserSubscriptionEvent()),
      child: ScaffoldWrapper(
        child: Scaffold(
          appBar: const CustomAppBar(
            title: 'Current Plan',
          ),
          body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
            builder: (context, state) {
              print('Loading ${state.cPLoading}');
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: state.cPLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding:
                                EdgeInsets.all(16.sp).copyWith(bottom: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This is your current plan. For assistance contact info@yoursecondshot.com.',
                                  style: context.textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0.h),
                                  child: CurrentPlanWidget(
                                      productDetails:
                                          state.currentSubscription),
                                ),
                                const Spacer(),
                                // _buildUpgradePlanButton(state, user, context),
                                // SizedBox(height: 10.h),
                                _buildCancelSubscriptionButton(state, user),
                                _buildPlatformSpecificMessage(state, context),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradePlanButton(
      SubscriptionState state, UserModel user, BuildContext context) {
    if (state.currentSubscription?.platform == 'ios' && Platform.isIOS ||
        state.currentSubscription?.platform == 'in-app' && Platform.isAndroid) {
      return PrimaryButton(
        loading: state.loading,
        onPressed: () {
          if (user.isSubscriptionPaid) {
            context.push(AppRoutes.subscriptionScreen);
          }
        },
        text: 'Upgrade Plan',
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildCancelSubscriptionButton(
      SubscriptionState state, UserModel user) {
    if ((state.currentSubscription?.platform == 'ios' && Platform.isIOS ||
            state.currentSubscription?.platform == 'in-app' &&
                Platform.isAndroid) &&
        user.isSubscriptionPaid) {
      return PrimaryButton(
        buttonColor: Colors.transparent,
        textColor: AppColors.primaryColor,
        borderColor: AppColors.primaryColor,
        onPressed: () {
          if (Platform.isIOS) {
            launchUrl(
                Uri.parse("https://apps.apple.com/account/subscriptions"));
          } else {
            launchUrl(Uri.parse(
                'https://play.google.com/store/account/subscriptions'));
          }
        },
        text: 'Cancel Subscription',
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildPlatformSpecificMessage(
      SubscriptionState state, BuildContext context) {
    if (state.currentSubscription?.platform == 'stripe') {
      return ListTile(
        tileColor: AppColors.redColor,
        leading: Image.asset(
          AssetConstants.deadlineAlertNotification,
          height: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        subtitle: Text(
          'Your subscription was purchased through the web platform. Please visit the website to manage your subscription.',
          style: context.textTheme.bodySmall!
              .copyWith(color: AppColors.whiteColor),
        ),
      );
    }

    if (!(state.currentSubscription?.platform == 'ios') && Platform.isIOS) {
      return ListTile(
        tileColor: AppColors.redColor,
        leading: Image.asset(
          AssetConstants.deadlineAlertNotification,
          height: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        subtitle: Text(
          'Your Subscription was not purchased through the IOS platform, please visit relevant platform to manage your subscription (i.e. Android or Web).',
          style: context.textTheme.bodySmall!
              .copyWith(color: AppColors.whiteColor),
        ),
      );
    }

    if (!(state.currentSubscription?.platform == 'in-app') &&
        Platform.isAndroid) {
      return ListTile(
        tileColor: AppColors.redColor,
        leading: Image.asset(
          AssetConstants.deadlineAlertNotification,
          height: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        subtitle: Text(
          'Your Subscription was not purchased through the Android platform, please visit relevant platform to manage your subscription (i.e. IOS or Web).',
          style: context.textTheme.bodySmall!
              .copyWith(color: AppColors.whiteColor),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
