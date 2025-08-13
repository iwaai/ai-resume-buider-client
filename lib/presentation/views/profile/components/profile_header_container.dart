import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/presentation/components/custom_appBar.dart';
import 'package:second_shot/presentation/components/user_pfp.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/extensions.dart';

class ProfileHeaderContainer extends StatelessWidget {
  const ProfileHeaderContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
          child: Column(
            children: [
              const CustomAppBar(
                backIconColor: AppColors.whiteColor,
                title: 'My Profile',
                txtColors: AppColors.whiteColor,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserPfp(
                          radius: 40.sp,
                        ),
                        SizedBox(width: 20.h),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.headlineSmall!
                                    .copyWith(
                                        color: AppColors.whiteColor,
                                        fontSize: 18),
                              ),
                              Text(
                                "${state.user.city}, ${state.user.state}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleMedium!
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            print(state.user.toJson());
                            context
                              ..read<AuthBloc>().add(LoadStates())
                              ..push(AppRoutes.editProfileScreen);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.secondaryColor),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: EmailPhoneComponent(
                              icon: AssetConstants.emailIcon,
                              text: state.user.email),
                        ),
                        if (state.user.phone.isNotEmpty) ...[
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            flex: 3,
                            child: EmailPhoneComponent(
                                icon: AssetConstants.phoneIcon,
                                text: state.user.phone.toUSPhoneNumber()),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmailPhoneComponent extends StatelessWidget {
  final String icon;
  final String text;
  const EmailPhoneComponent(
      {super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: 16.sp,
          width: 16.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.titleMedium!
                .copyWith(color: AppColors.whiteColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
