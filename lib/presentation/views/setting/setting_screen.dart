import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/blocs/subscription/subscription_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Settings',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.horizontalPadding.w / 2,
              vertical: Constant.verticalPadding.h / 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  child: BlocProvider.value(
                    value: context.read<NotificationsBloc>(),
                    child: BlocBuilder<NotificationsBloc, NotificationsState>(
                      builder: (context, state) {
                        return SwitchListTile(
                          contentPadding: const EdgeInsets.all(5),
                          activeTrackColor: AppColors.primaryColor,
                          inactiveTrackColor: AppColors.whiteColor,
                          tileColor: Colors.transparent,
                          activeColor: AppColors.whiteColor,
                          title: Text(
                            'Notifications',
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontSize: 16.sp),
                          ),
                          subtitle: Text(
                            'You can turn your notifications on or off.',
                            style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 14.sp),
                          ),
                          value: state.toggleNotification,
                          onChanged: (bool? value) {
                            context
                                .read<NotificationsBloc>()
                                .add(ToggleNotification());
                            // setState(() {
                            //   notificationsValue = !notificationsValue;
                            // });
                          },
                        );
                      },
                    ),
                  ),
                ),
                Divider(color: AppColors.grey),
                CustomTile(
                  text: 'Subscription',
                  ontap: () {
                    context
                        .read<SubscriptionBloc>()
                        .add(InitializeSubscriptionEvent());
                    context.read<AppBloc>().state.user.isSubscriptionPaid
                        ? context.push(AppRoutes.currentPlanScreen)
                        : context.push(AppRoutes.subscriptionScreen,
                            extra: context
                                    .read<AppBloc>()
                                    .state
                                    .user
                                    .isSubscriptionPaid
                                ? true
                                : false);
                  },
                ),
                if (context.read<AppBloc>().state.user.phone.isNotEmpty) ...[
                  Divider(color: AppColors.grey),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.result.event is UpdatePassword &&
                          state.result.status == ResultStatus.error) {
                        SnackbarsType.error(context, state.result.message);
                      }
                      if (state.result.event is UpdatePassword &&
                          state.result.status == ResultStatus.successful) {
                        context.pop(context);
                        SnackbarsType.success(context, state.result.message);
                      }
                    },
                    builder: (context, state) {
                      return CustomTile(
                        text: 'Change Password',
                        ontap: () {
                          changePasswordDialog(context);
                        },
                      );
                    },
                  ),
                ],
                Divider(color: AppColors.grey),
                CustomTile(
                  text: 'Terms and Conditions',
                  ontap: () {
                    context.push(AppRoutes.termsAndCondition);
                  },
                ),
                Divider(color: AppColors.grey),
                CustomTile(
                  text: 'Privacy Policy',
                  ontap: () {
                    context.push(AppRoutes.privacyPolicy);
                  },
                ),
                Divider(color: AppColors.grey),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.result.event is DeleteAccount &&
                        state.result.status == ResultStatus.error) {
                      SnackbarsType.error(context, state.result.message);
                    }
                    if (state.result.event is DeleteAccount &&
                        state.result.status == ResultStatus.successful) {
                      context.go(AppRoutes.login);
                      SnackbarsType.success(context, state.result.message);
                    }
                  },
                  builder: (context, state) {
                    return CustomTile(
                      text: 'Delete Account',
                      ontap: () {
                        CommonDialog(
                          customDialog: Padding(
                            padding: EdgeInsets.only(top: 14.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Delete Account',
                                  style: context.textTheme.headlineSmall,
                                ),
                                Constant.verticalSpace(10.h),
                                Text(
                                  'Are you sure you want to permanently delete your account? This action cannot be undone, and you will lose all data associated with your account. If you change your mind, you will not be able to reactivate your account.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.grey),
                                ),
                                Constant.verticalSpace(18.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          return PrimaryButton(
                                              loading: state.loading,
                                              textColor: AppColors.whiteColor,
                                              buttonColor:
                                                  AppColors.primaryColor,
                                              onPressed: () {
                                                context
                                                    .read<AuthBloc>()
                                                    .add(DeleteAccount());
                                              },
                                              text: 'Yes');
                                        },
                                      ),
                                    ),
                                    Constant.horizontalSpace(8.w),
                                    Expanded(
                                      child: PrimaryButton(
                                          textColor: AppColors.blackColor,
                                          buttonColor:
                                              AppColors.grey.withOpacity(0.5),
                                          onPressed: () {
                                            context.pop(context);
                                          },
                                          text: 'No'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ).showCustomDialog(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> changePasswordDialog(BuildContext context) {
    final currentPassword = TextEditingController();
    final newPassword = TextEditingController();
    final confirmPassword = TextEditingController();
    return showDialog(
        context: context,
        builder: (_) {
          final _formKey = GlobalKey<FormState>();
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      'Change Password',
                      style:
                          context.textTheme.titleLarge!.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    PrimaryTextField(
                      hintText: 'Old Password',
                      controller: currentPassword,
                      validator: validatePassword,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')), // Deny spaces
                      ],
                      isPassword: true,
                      characterLimit: 30,
                    ),
                    PrimaryTextField(
                      controller: newPassword,
                      hintText: 'New Password',
                      validator: validatePassword,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')), // Deny spaces
                      ],
                      isPassword: true,
                      characterLimit: 30,
                    ),
                    PrimaryTextField(
                      controller: confirmPassword,
                      hintText: 'Confirm New Password',
                      isPassword: true,
                      characterLimit: 30,
                      validator: (value) {
                        if (value != newPassword.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                            loading: state.loading,
                            onPressed: () {
                              // context.pop();
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                      UpdatePassword(
                                        currentPassword: currentPassword.text,
                                        newPassword: newPassword.text,
                                        confirmPAssword: confirmPassword.text,
                                      ),
                                    );
                              }
                            },
                            text: 'Save');
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, required this.text, required this.ontap});

  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Text(
        text,
        style: context.textTheme.titleMedium?.copyWith(fontSize: 16.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        size: 18,
        color: AppColors.grey,
      ),
      onTap: ontap,
    );
  }
}
