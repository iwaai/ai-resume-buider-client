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
import 'package:second_shot/presentation/views/profile/components/profile_header_container.dart';
import 'package:second_shot/presentation/views/profile/components/profile_sections.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.result.event is UpdateUser &&
                  state.result.status == ResultStatus.error) {
                SnackbarsType.error(context, state.result.message);
              }

              if (state.result.event is UpdateUser &&
                  state.result.status == ResultStatus.successful) {
                SnackbarsType.success(context, state.result.message);
                context
                    .read<AppBloc>()
                    .add(SetUser(user: LocalStorage().user!));
              }
            },
            child: const ProfileHeaderContainer(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Visit our website',
                      //   style: context.textTheme.bodyLarge!.copyWith(
                      //       // color: AppColors.profileText,
                      //       fontWeight: FontWeight.w600),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       'www.secondshot.com/56et',
                      //       style: context.textTheme.bodyLarge!.copyWith(
                      //           color: AppColors.profileText,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {},
                      //       child: Text(
                      //         'Visit Now',
                      //         style: context.textTheme.labelLarge!.copyWith(
                      //             color: AppColors.lightBlueColor,
                      //             decoration: TextDecoration.underline,
                      //             decorationColor: AppColors.lightBlueColor,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // const ProfileDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            AssetConstants.playStoreIcon,
                            height: 24.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            AssetConstants.appStoreIcon,
                            height: 24.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Image.asset(
                            AssetConstants.webIcon,
                            height: 24.h,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // showDialog(
                              //     context: context,
                              //     builder: (_) {
                              //       return const InviteFriendsDialog();
                              //     });
                            },
                            child: Text(
                              'Invite Friends',
                              style: context.textTheme.labelLarge!.copyWith(
                                  color: AppColors.lightBlueColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.lightBlueColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const ProfileDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Information',
                            style: context.textTheme.titleLarge!.copyWith(
                                // color: AppColors.profileText,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                ..read<RegistrationQuestionsBloc>()
                                    .add(ResetStepsEvent())
                                ..read<RegistrationQuestionsBloc>()
                                    .add(UpdateAnswersForEditEvent())
                                ..push(AppRoutes.registration);
                            },
                            child: Text(
                              'Edit',
                              style: context.textTheme.labelLarge!.copyWith(
                                  color: AppColors.lightBlueColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.lightBlueColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      BlocProvider.value(
                        value: context.read<RegistrationQuestionsBloc>()
                          ..add(GetRegistrationDataEvent()),
                        child: BlocBuilder<RegistrationQuestionsBloc,
                            RegistrationQuestionsState>(
                          builder: (context, state) {
                            return state.loading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProfileSections(
                                          title: "Education",
                                          question1:
                                              'Grade level or Professional Level',
                                          answer1: state.registrationData
                                                  ?.currentGradeLevel ??
                                              "",
                                          question2:
                                              'Favorite Grade School Subject',
                                          answer2: state
                                                  .registrationData
                                                  ?.favoriteMiddleSchoolSubject
                                                  ?.name ??
                                              ""),
                                      const ProfileDivider(),
                                      if (state.registrationData
                                              ?.hasMilitaryService ??
                                          false) ...[
                                        ProfileSections(
                                            title: "Military Service",
                                            question1: 'Branch of Service',
                                            answer1: state.registrationData
                                                    ?.branchOfService?.name ??
                                                "",
                                            question2: 'Position',
                                            answer2: state.registrationData
                                                    ?.rank?.name ??
                                                ""),
                                        const ProfileDivider(),
                                      ],
                                      if ((state.registrationData
                                                  ?.recentJobTitle ??
                                              "")
                                          .isNotEmpty) ...[
                                        ProfileSections(
                                            title: "Career",
                                            question1: state.registrationData
                                                        ?.recentJobTitle ==
                                                    null
                                                ? null
                                                : 'Recent Job Title',
                                            answer1: state.registrationData
                                                        ?.recentJobTitle ==
                                                    null
                                                ? null
                                                : state.registrationData
                                                        ?.recentJobTitle ??
                                                    "",
                                            question2: null,
                                            answer2: null),
                                        const ProfileDivider(),
                                      ],
                                      if (state.registrationData?.isAthlete ??
                                          false) ...[
                                        ProfileSections(
                                            title: "Athlete Background",
                                            question1: 'Primary Sport',
                                            answer1: state.registrationData
                                                    ?.primarySport?.name ??
                                                "",
                                            question2: 'Position',
                                            answer2: state.registrationData
                                                    ?.sportPosition?.name ??
                                                ""),
                                        const ProfileDivider(),
                                      ],
                                      ProfileSections(
                                          title: "Hobbies",
                                          question1: null,
                                          answer1: state.registrationData
                                                  ?.favoriteHobby1?.name ??
                                              "",
                                          question2: null,
                                          answer2: state.registrationData
                                                  ?.favoriteHobby2?.name ??
                                              ""),
                                    ],
                                  );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.grey.withOpacity(1),
      height: 16.h,
    );
  }
}

class InviteFriendsDialog extends StatelessWidget {
  const InviteFriendsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Refer a friend and help them build their own Career Prep Toolbox!',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "Invite your friends by sharing its link, available on App Store, Play Store, and the web. One tap to copy, and you're ready to share!",
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
              SizedBox(
                height: 16.h,
              ),
              InviterFriendTile(
                title: 'Website',
                link: state.webURL,
              ),
              SizedBox(
                height: 16.h,
              ),
              InviterFriendTile(
                title: 'Play store',
                link: state.playStoreURL,
              ),
              SizedBox(
                height: 16.h,
              ),
              InviterFriendTile(
                title: 'Appstore',
                link: state.appStoreURL,
              ),
              SizedBox(
                height: 16.h,
              ),
              PrimaryButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: "Close")
            ],
          );
        }),
      ),
    );
  }
}

class InviterFriendTile extends StatelessWidget {
  final String title;
  final String link;

  const InviterFriendTile({super.key, required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(right: 0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.bodyMedium!,
            ),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link)).then((value) {
                SnackbarsType.success(context, 'Copied');
              });
            },
            child: Text(
              'Copy',
              style: context.textTheme.titleSmall!
                  .copyWith(color: AppColors.lightBlueColor),
            ),
          )
        ],
      ),
    );
  }
}
