import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/goals_settings/component/share_goal_dailog.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/extensions.dart';

class ReviewSmartGoalScreen extends StatelessWidget {
  const ReviewSmartGoalScreen({super.key, required this.bloc});

  final AddGoalBloc bloc;
  final bool shownSupportDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<AddGoalBloc, AddGoalState>(
        listener: (context, state) {},
        builder: (context, state) {
          return ScaffoldWrapper(
            child: Scaffold(
              appBar: CustomAppBar(
                backIconColor: Colors.black,
                title: state.q5Answer.isEmpty
                    ? 'Review Your Goal'
                    : 'Review Your S.M.A.R.T Goal',
              ),
              body: state.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.horizontalPadding.w),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Take a moment to review your goal below. If you need to make changes you can click on the edit button. If you are fully satisfied with your goal you have the option to add 2 people for support and accountability. Click finalize goal to send to your support network add to your goal to the goal setting hub.",
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Card(
                                        margin: EdgeInsets.only(top: 30.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  Constant.verticalPadding.h,
                                              horizontal:
                                                  Constant.horizontalPadding.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Main Goal Details",
                                                    style: context
                                                        .textTheme.titleLarge
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      // context.pop();
                                                    },
                                                    child: Image.asset(
                                                      AssetConstants
                                                          .editPenIcon,
                                                      width: 20.w,
                                                      height: 20.h,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Constant.verticalSpace(12.h),
                                              Text(
                                                state.title.toString(),
                                                // "Digital Marketing Course",
                                                style: context
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.sp
                                                        // color: AppColors.lightBlueColor,
                                                        ),
                                              ),
                                              Constant.verticalSpace(12.h),
                                              Divider(
                                                color: AppColors.grey,
                                                thickness: 1,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Deadline for Main Goal",
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontSize: 15.sp,
                                                            color: AppColors
                                                                .blackColor),
                                                  ),
                                                  Text(
                                                    formatDate1(
                                                      state.endDate != null
                                                          ? state.endDate
                                                              .toString()
                                                          : DateTime.now()
                                                              .copyWith(
                                                                  month: DateTime
                                                                              .now()
                                                                          .month +
                                                                      3)
                                                              .toIso8601String(),
                                                    ),
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontSize: 15.sp,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: state.subgoalsData.isNotEmpty,
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          left: 0.w, right: 0.w, top: 16.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                Constant.verticalPadding.h,
                                            horizontal:
                                                Constant.horizontalPadding.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sub-Goals',
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(fontSize: 16.sp),
                                            ),
                                            Column(
                                              children: List.generate(
                                                state.subgoalsData.length,
                                                (index) => CustomBox(
                                                  number: '${index + 1}',
                                                  title: state
                                                      .subgoalsData[index].name
                                                      .toString(),
                                                  date: formatDate1(state
                                                      .subgoalsData[index]
                                                      .deadline
                                                      .toString()),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  state.supportPeople.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h),
                                          itemCount: state.supportPeople.length,
                                          itemBuilder: (context, index) {
                                            final supportPerson =
                                                state.supportPeople[index];
                                            return state
                                                    .supportPeople.isNotEmpty
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 12.h),
                                                    child: Card(
                                                      margin: const EdgeInsets
                                                          .symmetric(),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.r),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: Constant
                                                              .horizontalPadding
                                                              .w,
                                                          vertical: Constant
                                                              .verticalPadding
                                                              .h,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'Support People ',
                                                                    style: context
                                                                        .textTheme
                                                                        .titleMedium
                                                                        ?.copyWith(
                                                                            fontSize:
                                                                                15.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            '(${(index + 1).toString().padLeft(2, '0')})',
                                                                        style: context
                                                                            .textTheme
                                                                            .titleMedium
                                                                            ?.copyWith(
                                                                          fontSize:
                                                                              15.sp,
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          16.h),
                                                              child: Row(
                                                                children: [
                                                                  CustomSupportPeople(
                                                                    title:
                                                                        'Full Name',
                                                                    text: supportPerson
                                                                        .fullName
                                                                        .toString(),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    child:
                                                                        VerticalDivider(
                                                                      color: AppColors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  CustomSupportPeople(
                                                                    title:
                                                                        'Email Address',
                                                                    text: supportPerson
                                                                        .emailAddress
                                                                        .toString(),
                                                                  ),
                                                                  // SizedBox(
                                                                  //   height: 30.h,
                                                                  //   child:
                                                                  //       VerticalDivider(
                                                                  //     color: AppColors
                                                                  //         .grey,
                                                                  //   ),
                                                                  // ),
                                                                  // Expanded(
                                                                  //   child:
                                                                  //       CustomSupportPeople(
                                                                  //     title:
                                                                  //         'Phone Number',
                                                                  //     text: supportPerson
                                                                  //         .phoneNumber
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
                                                  )
                                                : const SizedBox.shrink();
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<AddGoalBloc, AddGoalState>(
                            builder: (context, state) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Constant.verticalPadding.h),
                                  child: Column(
                                    children: [
                                      PrimaryButton(
                                        onPressed: () {
                                          context.push(AppRoutes.supportPeople,
                                              extra: bloc);
                                        },
                                        text: 'Add Support People',
                                        textSize: 14.sp,
                                        borderRadius: 12.r,
                                      ),
                                      Constant.verticalSpace(5.h),
                                      PrimaryButton(
                                        // loading: state.loading,
                                        onPressed: () {
                                          GoalSectionDailog.showShareGoalDialog(
                                              context: context,
                                              argument:
                                                  context.read<AddGoalBloc>(),
                                              onNoTap: () {
                                                context.pop();
                                                context
                                                    .read<AddGoalBloc>()
                                                    .add(CreateGoal());
                                              },
                                              onYesTap: () {
                                                context.pop();
                                                if (state.supportPeople.length <
                                                    2) {
                                                  context.push(
                                                      AppRoutes.supportPeople,
                                                      extra: bloc);
                                                } else {
                                                  context
                                                      .read<AddGoalBloc>()
                                                      .add(CreateGoal());
                                                }
                                              });
                                        },
                                        text: 'Finalize Goal',
                                        textSize: 14.sp,
                                        borderRadius: 12.r,
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
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
            maxLines: 2,
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

class CustomBox extends StatelessWidget {
  const CustomBox(
      {super.key,
      required this.number,
      required this.title,
      required this.date});

  final String number;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.verticalPadding.h / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.blackColor, fontWeight: FontWeight.w500),
          ),
          Constant.horizontalSpace(16.w),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.blackColor, fontWeight: FontWeight.w500),
          ),
          Constant.verticalSpace(3.h),
          Divider(color: AppColors.grey, thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deadline for Sub-goals    ",
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 13.sp,
                    color: AppColors.blackColor,
                  ),
                ),
                Text(
                  date,
                  // "Mar/23/2024 - Jun/23/2024",
                  style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp, color: AppColors.primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
