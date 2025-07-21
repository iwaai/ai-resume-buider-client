import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

class FinilizeGoalDetailScreen extends StatelessWidget {
  const FinilizeGoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as GoalsBloc;
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<GoalsBloc, GoalsState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          final result = state.result;

          if (result != null) {
            final eventType = result.event.runtimeType;
            final status = result.status;
            final message = result.message;

            if (status == ResultStatus.error) {
              SnackbarsType.error(context, message);
            } else if (status == ResultStatus.successful) {
              switch (eventType) {
                case const (GoalDetailEvent):
                  break;
                // case const (SupportPeopleEvent):
                //   SnackbarsType.success(context, message);
                //   context.read<GoalsBloc>().state;
                //   break;
                case UpdateMainGoalStatus():
                  // context.read<GoalsBloc>().add(GetGoalsData());

                  break;
                case const (DeleteGoalEvent):
                  context.read<GoalsBloc>().add(GetGoalsData());
                  SnackbarsType.success(context, message);
                  GoRouter.of(context).popUntil(AppRoutes.goalSettings);
                  break;
                case const (UpdateSubGoalStatus):
                  // context.read<GoalsBloc>().state;
                  break;
              }
            }
          }
        },
        builder: (context, state) {
          return ScaffoldWrapper(
            child: Scaffold(
              appBar: CustomAppBar(
                onClick: () {
                  if (state.query.isNotEmpty ||
                      state.filterGoalList.isNotEmpty) {
                    context.pop(context);
                  } else {
                    GoRouter.of(context).popUntil(AppRoutes.goalSettings);
                  }
                },
                title: 'Finalized Goal',
                trailingIcon: [
                  BlocBuilder<GoalsBloc, GoalsState>(
                    builder: (context, state) {
                      return ThreeDotsMenu(menuItems: [
                        if ((state.goalDtail?.supportPeople?.length ?? 0) < 2)
                          "Add Support Network",
                        'Delete',
                      ], menuActions: [
                        if ((state.goalDtail?.supportPeople?.length ?? 0) < 2)
                          () {
                            context.push(AppRoutes.editSupportPeople,
                                extra: bloc);
                          },
                        () {
                          goalDeleteSheet(context, bloc);
                        },
                      ]);
                    },
                  ),
                  SizedBox(width: 12.w)
                ],
              ),
              body: SingleChildScrollView(
                child: BlocBuilder<GoalsBloc, GoalsState>(
                  builder: (context, state) {
                    return state.loading
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            children: [
                              // Main Goal Card
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: Card(
                                  margin: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Constant.verticalPadding.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Constant.horizontalPadding.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${state.goalDtail?.status}",
                                                style: context
                                                    .textTheme.titleLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.lightBlueColor,
                                                ),
                                              ),
                                              Text(
                                                "Deadline",
                                                style: context
                                                    .textTheme.titleMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Constant.horizontalPadding.w,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                formatDate1(state
                                                        .goalDtail?.createdAt ??
                                                    ''),
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .blackColor),
                                              ),
                                              SizedBox(
                                                height: 20,
                                                child: VerticalDivider(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                              Text(
                                                formatDate1(
                                                    state.goalDtail?.deadline ??
                                                        ''),
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .blackColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Constant.verticalSpace(12.h),
                                        Divider(
                                          color:
                                              AppColors.grey.withOpacity(0.5),
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Constant.horizontalPadding.w,
                                              vertical: 4.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${state.goalDtail?.mainGoalName.toString()}",
                                                  style: context
                                                      .textTheme.titleLarge
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Checkbox(
                                                  activeColor:
                                                      AppColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r),
                                                  ),
                                                  value:
                                                      state.goalDtail?.status ==
                                                          'Completed',
                                                  onChanged: (v) {
                                                    if (state.goalDtail
                                                            ?.status !=
                                                        'Completed') {
                                                      context.read<GoalsBloc>().add(
                                                          UpdateMainGoalStatus());
                                                    }
                                                  })
                                            ],
                                          ),
                                        ),
                                        // Constant.verticalSpace(30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              //////    subgoals  ///////

                              Visibility(
                                visible:
                                    state.goalDtail?.subGoals?.isNotEmpty ??
                                        false,
                                child: Card(
                                  margin: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Constant.verticalPadding.h,
                                        horizontal:
                                            Constant.horizontalPadding.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Sub-Goals',
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(fontSize: 16.sp),
                                            ),
                                            Text(
                                              "${state.goalDtail?.subGoalStatus}",
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontSize: 16.sp,
                                                color: AppColors.lightBlueColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...List.generate(
                                            state.goalDtail!.subGoals?.length ??
                                                0, (index) {
                                          final goalDetial =
                                              state.goalDtail!.subGoals?[index];
                                          return Column(
                                            children: [
                                              CustomCheckBox(
                                                value:
                                                    goalDetial?.isCompleted ??
                                                        false,
                                                text: goalDetial?.name ?? '',
                                                deadline: formatDate2(goalDetial
                                                        ?.deadline
                                                        .toString() ??
                                                    ''),
                                                onChange: (newValue) {
                                                  if (goalDetial?.isCompleted ==
                                                      false) {
                                                    goalDetial?.isCompleted =
                                                        newValue;
                                                    bloc.add(
                                                      UpdateSubGoalStatus(
                                                          subGoalId:
                                                              goalDetial?.id ??
                                                                  ""),
                                                    );
                                                  }
                                                  // if()
                                                },
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              //  support people
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 16.h),
                                itemCount:
                                    state.goalDtail?.supportPeople?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final supportPeople =
                                      state.goalDtail?.supportPeople?[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Constant.horizontalPadding.w,
                                            vertical:
                                                Constant.verticalPadding / 2),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Support People ',
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '(${(index + 1).toString().padLeft(2, '0')})',
                                                        style: context.textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontSize: 15.sp,
                                                                color: AppColors
                                                                    .secondaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8.h, bottom: 8.h),
                                              child: Row(
                                                children: [
                                                  CustomSupportPeople(
                                                      title: 'Full Name',
                                                      text: supportPeople!
                                                          .fullName
                                                          .toString()),
                                                  SizedBox(
                                                    height: 30.h,
                                                    child: VerticalDivider(
                                                      color: AppColors.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                  CustomSupportPeople(
                                                    title: 'Email Address',
                                                    text: supportPeople
                                                        .emailAddress
                                                        .toString(),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 30.h,
                                                  //   child: VerticalDivider(
                                                  //     color: AppColors.grey
                                                  //         .withOpacity(0.5),
                                                  //   ),
                                                  // ),
                                                  // CustomSupportPeople(
                                                  //   title: 'Phone Number',
                                                  //   text: Constant
                                                  //       .formatPhoneNumber(
                                                  //     supportPeople.phoneNumber
                                                  //         .toString(),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> goalDeleteSheet(BuildContext context, GoalsBloc bloc) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AssetConstants.deleteGoalIcon,
                    width: 56.w,
                    height: 63.h,
                  ),
                  Constant.verticalSpace(16.h),
                  Text(
                    "Delete Goal",
                    style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 18.sp),
                  ),
                  // Constant.verticalSpace(5.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Are you sure you want to delete your goal?",
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  // Constant.verticalSpace(8.h),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        context.pop();
                      },
                      text: 'Cancel',
                      buttonColor: const Color(0xFFDDDDDD),
                      textColor: AppColors.blackColor,
                      borderRadius: 8.r,
                      fontWeight: FontWeight.w500,
                      textSize: 16.sp,
                    ),
                  ),
                  Constant.horizontalSpace(10),
                  Expanded(
                    child: BlocProvider.value(
                      value: bloc,
                      child: BlocBuilder<GoalsBloc, GoalsState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            loading: state.loading,
                            onPressed: () {
                              context.read<GoalsBloc>().add(DeleteGoalEvent(
                                  // goalId: state.goalDtail?.goalId.toString() ??
                                  //     ''),
                                  ));

                              // context.pop();
                            },
                            text: 'Yes',
                            buttonColor: AppColors.redColor,
                            borderRadius: 8.r,
                            fontWeight: FontWeight.w500,
                            textSize: 16.sp,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}

class CustomSupportPeople extends StatelessWidget {
  const CustomSupportPeople(
      {super.key, required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium
                ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final ValueChanged<bool>
      onChange; // Ensure the callback is typed as ValueChanged<bool>
  final bool value; // Current state of the checkbox
  final String text;
  final String deadline;

  const CustomCheckBox(
      {super.key,
      required this.onChange,
      required this.value,
      required this.text,
      required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  value: value, // Use the parent-provided value
                  checkColor: AppColors.whiteColor,
                  activeColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      onChange(newValue); // Notify the parent of changes
                    }
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  text,
                  style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.blackColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.grey.withOpacity(0.5),
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deadline for Sub-goals    ",
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontSize: 13.sp, color: AppColors.blackColor),
                ),
                Text(
                  deadline,
                  style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp, color: AppColors.primaryColor),
                ),
                Constant.verticalSpace(8.h)
              ],
            ),
          )
        ],
      ),
    );
  }
}
