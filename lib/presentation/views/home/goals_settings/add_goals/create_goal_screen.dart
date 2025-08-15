import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/constants/validators.dart';
import 'package:second_shot/utils/extensions.dart';

import '../component/custom_calender.dart';

class CreateGoalScreen extends StatelessWidget {
  CreateGoalScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as AddGoalBloc;
    return BlocProvider.value(
      value: args,
      child: BlocConsumer<AddGoalBloc, AddGoalState>(
        listenWhen: (p, n) => p != n,
        listener: (context, state) {
          if (state.result?.event is CreateGoal &&
              state.result?.status == ResultStatus.successful) {
            _showGoalCreatedDialog(context, state, args);
          }
        },
        builder: (context, state) {
          return ScaffoldWrapper(
            child: Scaffold(
              appBar: CustomAppBar(
                title:
                    state.q5Answer.isEmpty ? "Create Goal" : "S.M.A.R.T Goal",
                isBackButton: true,
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildMainGoalSection(context, state),
                      const Divider(),
                      _buildSubGoalsSection(context, state),
                      _buildActionButtons(context, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainGoalSection(BuildContext context, AddGoalState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constant.horizontalPadding.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Constant.verticalSpace(8.h),
          Text("Goal", style: context.textTheme.labelLarge),
          SizedBox(height: 5.h),
          PrimaryTextField(
            initialValue: state.title.trim(),
            hintText: "Write your main goal here",
            onChanged: (v) {
              context.read<AddGoalBloc>().add(UpdateMainGoalTitle(title: v));
            },
            validator: validateField,
          ),
          Constant.verticalSpace(20.h),
          Text('Time-Bound',
              style: context.textTheme.labelLarge?.copyWith(fontSize: 13.sp)),
          Constant.verticalSpace(5.h),
          _buildDeadlinePicker(context, state),
        ],
      ),
    );
  }

  Widget _buildDeadlinePicker(BuildContext context, AddGoalState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: BlocBuilder<AddGoalBloc, AddGoalState>(
        builder: (context, state) {
          final endDate = state.endDate;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Set a Deadline",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Constant.verticalSpace(2.h),
                    Text(
                      "for achieving your main goal!",
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontSize: 15.sp),
                    ),
                    Constant.verticalSpace(5.h),
                    Text(
                      endDate != null
                          ? formatDate(endDate)
                          : "(3 months by default)",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _showDatePicker(context, isMainGoal: true);
                },
                child: Image.asset(
                  AssetConstants.goalDeadlineIcon,
                  width: 27.5.w,
                  height: 27.5.h,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubGoalsSection(BuildContext context, AddGoalState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constant.horizontalPadding.h),
      child: Column(
        children: [
          Constant.verticalSpace(20),
          Visibility(
            visible: state.subgoalsData.isNotEmpty,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Sub Goals ",
                        style: context.textTheme.titleLarge,
                        children: <TextSpan>[
                          TextSpan(
                            text: '(Optional)',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Constant.verticalSpace(16.h),
                Text(
                  "Break down your main goal into manageable steps. Add your sub-goals to turn your dreams into achievable milestones.",
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.blackColor),
                ),
                Constant.verticalSpace(16.h),
                Column(
                  children: List.generate(state.subgoalsData.length, (index) {
                    return _buildSubGoalItem(context, state, index);
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.h, top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.read<AddGoalBloc>().add(AddSubgoal()),
                        child: Text(
                          '+ Add more',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.primaryColor,
                            decorationColor: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (state.subgoalsData.isEmpty)
            SizedBox(
              height: state.q5Answer.isEmpty
                  ? MediaQuery.of(context).size.height * 0.25.h
                  : MediaQuery.of(context).size.height * 0.32.h,
            ),
        ],
      ),
    );
  }

  Widget _buildSubGoalItem(
      BuildContext context, AddGoalState state, int index) {
    final subgoal = state.subgoalsData[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constant.verticalSpace(8.h),
              Text("Sub-goal ${index + 1}",
                  style: context.textTheme.labelLarge),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: PrimaryTextField(
                        initialValue: subgoal.name.toString(),
                        validator: validateField,
                        onChanged: (String? v) {
                          context.read<AddGoalBloc>().add(
                              UpdateASubgoal(index: index, value: v ?? ""));
                        },
                        hintText: "Write your sub-goal here",
                      ),
                    ),
                  ),
                ],
              ),
              _buildSubGoalDeadlinePicker(context, state, index),
            ],
          ),
          Positioned(
            right: -3,
            top: -5,
            child: InkWell(
              onTap: () =>
                  context.read<AddGoalBloc>().add(RemoveASubgoal(index: index)),
              child: Padding(
                padding: EdgeInsets.only(top: 10.h, right: 2.w),
                child: Icon(
                  CupertinoIcons.delete,
                  color: AppColors.redColor,
                  size: 20.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubGoalDeadlinePicker(
      BuildContext context, AddGoalState state, int index) {
    final deadline = state.subgoalsData[index].deadline;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Set a deadline for achieving your sub-goal!",
                  style:
                      context.textTheme.labelLarge?.copyWith(fontSize: 15.sp),
                ),
                Constant.verticalSpace(5.h),
                Text(
                  deadline != null ? formatDate(deadline) : "Select Date",
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () =>
                _showDatePicker(context, isMainGoal: false, index: index),
            child: Image.asset(
              AssetConstants.goalDeadlineIcon,
              width: 27.5.w,
              height: 27.5.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AddGoalState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Constant.horizontalPadding.h, vertical: 16.h),
      child: Column(
        children: [
          if (state.q5Answer.isEmpty)
            PrimaryButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  CommonDialog(
                    title:
                        'Type your goal in the chat and add make it a Smart Goal. Review and add the sub goals you want to focus on',
                    okBtnText: 'Close',
                    okBtnFunction: () {
                      context.push(AppRoutes.smartGoal,
                          extra: context.read<AddGoalBloc>());
                      context.pop();
                    },
                  ).showCustomDialog(context);
                }
              },
              text: 'Make it S.M.A.R.T (Optional) ',
              textSize: 14.sp,
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
              textColor: AppColors.primaryColor,
              borderRadius: 8.sp,
              buttonColor: AppColors.whiteColor,
            ),
          Constant.verticalSpace(8.h),
          if (state.subgoalsData.isEmpty)
            PrimaryButton(
              onPressed: () => context.read<AddGoalBloc>().add(AddSubgoal()),
              text: 'Add Sub Goals (Optional)',
              borderRadius: 8.sp,
            ),
          Constant.verticalSpace(8.h),
          PrimaryButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (state.subgoalsData.any((i) => i.deadline == null)) {
                  SnackbarsType.error(
                      context, "Please set a deadline for your sub-goal");
                  return;
                }
                context.push(AppRoutes.reviewSmartGoal,
                    extra: context.read<AddGoalBloc>());
              }
            },
            text: 'Submit Your Goal ',
            borderRadius: 8.sp,
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context,
      {required bool isMainGoal, int? index}) {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 1)),
      maximumDate: DateTime.now().add(const Duration(days: 10000)),
      backgroundColor: Colors.white,
      primaryColor: AppColors.primaryColor,
      onCancelClick: () {},
      onDateSelected: (DateTime selectedDate) {
        if (isMainGoal) {
          context
              .read<AddGoalBloc>()
              .add(MainGoalDatePicker(endDate: selectedDate));
        } else if (index != null) {
          context
              .read<AddGoalBloc>()
              .add(UpdateSubGoalDate(index: index, endDate: selectedDate));
        }
      },
    );
  }

  void _showGoalCreatedDialog(
      BuildContext context, AddGoalState state, AddGoalBloc bloc) {
    CommonDialog(
      title: state.q5Answer.isEmpty
          ? 'Goal Successfully Created'
          : "S.M.A.R.T Goal Successfully Created",
      body:
          'Your goal has been successfully created. You can now monitor your progress and take the necessary steps to achieve it. Stay committed to your objectives and continue striving for success. if you have any questions, contact tech@resumate.com.',
      image: AssetConstants.goalCreatedDialog,
      okBtnText: 'View Goal Details',
      barrierDismissible: false,
      okBtnFunction: () {
        context.pop();
        CommonDialog(
          image: AssetConstants.tickMarkIcon,
          imageHeight: 100.h,
          barrierDismissible: false,
          title: "Success!",
          okBtnFunction: () {
            context.pushReplacement(AppRoutes.createGoal, extra: bloc);

            context.read<AddGoalBloc>().add(ClearFields());
          },
          okBtnText: "Submit another goal",
          additionalButton: PrimaryButton(
              onPressed: () {
                context.pushReplacement(AppRoutes.finilizedGoalDetail,
                    extra: bloc.goalsBloc);
              },
              text: ("Done with setting goal")),
        ).showCustomDialog(context);
      },
    ).showCustomDialog(context);
  }
}
