import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/blocs/home/transferable_skills/transferable_skills_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/components/user_pfp.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent(
      {super.key,
      required this.advancedDrawerController,
      required this.outerContext});

  final AdvancedDrawerController advancedDrawerController;
  final BuildContext outerContext;

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  final List<String> drawerTitles = [
    'Home',
    // 'My Transferable Skills',
    // 'My Career Recommendations',
    'My Resume',
    // 'My Goals',
    // 'Success Stories',
    // 'Personal Plan',
    // 'Settings', // Removed from here
  ];

  List<Function(BuildContext)> get drawerOnTapCallbacks => [
        (context) => widget.advancedDrawerController.hideDrawer(),
        // (context) => context.push(AppRoutes.transferableSkills,
        //     extra: context.read<TransferableSkillsBloc>()..add(GetData())),
        // (context) => context.push(AppRoutes.careerRecommendations,
        //     extra: context.read<CareerRecommendationsBloc>()),
        (context) => context.push(AppRoutes.resumeBuilder,
            extra: context.read<MyLibraryBloc>()),
        // (context) => context.push(
        //       AppRoutes.goalSettings,
        //       extra: widget.outerContext.read<GoalsBloc>(),
        //     ),
        // (context) => context.push(AppRoutes.successStories,
        //     extra: context.read<SuccessStoriesBloc>()),
        // (context) => context.push(AppRoutes.myLibrary,
        //     extra: context.read<MyLibraryBloc>()),
        // (context) {
        //   widget.advancedDrawerController.hideDrawer();
        //   context.push(AppRoutes.setting);
        // }
      ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.result.event is Logout &&
            state.result.status == ResultStatus.error) {
          SnackbarsType.error(context, state.result.message);
        }
        if (state.result.event is Logout &&
            state.result.status == ResultStatus.successful) {
          SnackbarsType.success(context, state.result.message);
          context.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: Constant.horizontalPadding.w,
                    right: Constant.horizontalPadding.w,
                    top: Constant.verticalPadding.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              widget.advancedDrawerController.hideDrawer();
                            },
                            child: Image.asset(
                              AssetConstants.crossIcon,
                              width: 15.w,
                              height: 15.h,
                            )),
                        Text(
                          "Side Menu",
                          style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(),
                      ],
                    ),

                    Constant.verticalSpace(20.h),
                    // Profile Section
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  UserPfp(
                                    radius: 30.r,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.user.name,
                                          //  "Michael Jordan",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: AppColors.whiteColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Constant.verticalSpace(8.h),
                                        Text(
                                          state.user.email,
                                          // "michaeljordan@gmail.com",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            color: AppColors.whiteColor,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 5
                                          .w), // Adjusted `Constant.horizontalSpace`
                                  InkWell(
                                    onTap: () {
                                      context
                                        ..read<AuthBloc>().add(LoadStates())
                                        ..push(AppRoutes.editProfileScreen);
                                    },
                                    child: Image.asset(
                                      AssetConstants.editIcon,
                                      width: 28.w,
                                      height: 29.h,
                                    ),
                                  ),
                                ],
                              ),
                              Constant.verticalSpace(16.h),
                              PrimaryButton(
                                onPressed: () {
                                  widget.advancedDrawerController.hideDrawer();
                                  context.push(AppRoutes.profileScreen);
                                },
                                text: "View Profile",
                                textStyle:
                                    context.textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor,
                                ),
                                textColor: AppColors.whiteColor,
                                height: 35.h,
                                buttonColor: Colors.transparent,
                                borderColor:
                                    AppColors.whiteColor.withOpacity(0.5),
                                borderRadius: 8.r,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Constant.verticalSpace(16),

                    ...List.generate(
                      drawerTitles.length,
                      (index) {
                        Widget tile = DrawTile(
                          title: drawerTitles[index],
                          ontap: () {
                            if (subscriptionIndex == 0 && index != 0 + 1) {
                              Constant.showSubscriptionDialog(context);
                            } else {
                              setState(() {
                                selectedIndex = index;
                              });
                              drawerOnTapCallbacks[index](context);
                            }
                          },
                          isSelected: selectedIndex == index,
                        );

                        // If the index is 6, wrap it with additional UI elements (spacing & divider)
                        // if (index == 1) {
                        //   return Column(
                        //     children: [
                        //       tile,
                        //       Constant.verticalSpace(12),
                        //       Divider(
                        //         height: 1,
                        //         color: Colors.white.withOpacity(0.3),
                        //       ),
                        //       Constant.verticalSpace(12.h),
                        //     ],
                        //   );
                        // }

                        return tile;
                      },
                    ),
                    Spacer(),
                    Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    Constant.verticalSpace(12.h),
                    DrawTile(
                      icon: Icons.settings,
                      isSelected: false,
                      title: "Settings",
                      ontap: () {
                        widget.advancedDrawerController.hideDrawer();
                        context.push(AppRoutes.setting);
                      },
                    ),
                    Constant.verticalSpace(8.h),
                    DrawTile(
                      icon: Icons.logout,
                      isSelected: false,
                      title: "Logout",
                      ontap: () {
                        CommonDialog(
                          customDialog: Padding(
                            padding: EdgeInsets.only(top: 14.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Logout',
                                  style: context.textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                const Text(
                                  'Are you sure you want to Logout?',
                                  style: TextStyle(color: AppColors.blackColor),
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
                                          ? EdgeInsets.only(right: 4.0.w)
                                          : EdgeInsets.only(left: 4.0.w),
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                        return PrimaryButton(
                                            loading: state.loading && i == 1,
                                            textColor: i.isEven
                                                ? AppColors.blackColor
                                                : AppColors.whiteColor,
                                            buttonColor: i.isEven
                                                ? AppColors.grey
                                                    .withOpacity(0.5)
                                                : AppColors.primaryColor,
                                            onPressed: () {
                                              i.isEven
                                                  ? context.pop()
                                                  : context
                                                      .read<AuthBloc>()
                                                      .add(Logout());
                                            },
                                            text: i.isEven ? 'No' : 'Yes');
                                      }),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ).showCustomDialog(context);
                      },
                    ),
                    Constant.verticalSpace(16.h),
                  ],
                ),
              ),
              Positioned(
                bottom: -50,
                left: -80,
                child: IgnorePointer(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withOpacity(0.03),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -205,
                child: IgnorePointer(
                  child: Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withOpacity(0.03),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -250,
                left: -315,
                child: IgnorePointer(
                  child: Container(
                    height: 600,
                    width: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withOpacity(0.03),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class DrawTile extends StatelessWidget {
  const DrawTile(
      {super.key,
      required this.title,
      required this.ontap,
      this.icon,
      required this.isSelected});

  final String title;
  final VoidCallback ontap;
  final bool isSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          padding: EdgeInsets.only(left: 24.w, top: 12.h, bottom: 12.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.whiteColor.withOpacity(0.07) // Highlighted color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    icon,
                    color: AppColors.whiteColor,
                  ),
                ),
              Text(
                title,
                style: context.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
