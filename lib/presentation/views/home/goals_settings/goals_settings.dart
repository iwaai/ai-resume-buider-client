import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';
import '../../../../blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import '../components/dialogs_renderer.dart';
import '../components/goal_card.dart';

class GoalsSettings extends StatefulWidget {
  const GoalsSettings({super.key});

  @override
  GoalsSettingsState createState() => GoalsSettingsState();
}

class GoalsSettingsState extends State<GoalsSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<String> tabNames = [
    'All',
    'Not Started yet',
    'In Progress',
    'Completed'
  ];
  final List<String?> tabStatuses = [
    null,
    Constant.notStartedYet,
    Constant.inProgress,
    Constant.completed
  ];

  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.goalSettings)
        .showInitialDialog(context);
    _tabController = TabController(length: tabNames.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = GoRouterState.of(context).extra as GoalsBloc;
      bloc.add(GetGoalsData());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as GoalsBloc;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: bloc,
        ),
        BlocProvider(
          create: (context) {
            return AddGoalBloc(bloc); // Pass goalId to AddGoalBloc
          },
        ),
      ],
      child: BlocConsumer<GoalsBloc, GoalsState>(
        listener: (context, state) {
          if (state.result != null) {
            if ((state.result!.event is GetGoalsData ||
                    state.result!.event is DeleteGoalEvent ||
                    state.result!.event is EditSupportPeopleEvent ||
                    state.result!.event is GoalDetailEvent ||
                    state.result!.event is UpdateSubGoalStatus) &&
                state.result!.status == ResultStatus.error &&
                state.result!.message.contains(Constant.accessDeniedMessage)) {
              SnackbarsType.error(context, state.result!.message);
              context.pushReplacement(AppRoutes.homeScreen);
            }
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: tabNames.length,
            child: ScaffoldWrapper(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'My Goals',
                    style: context.textTheme.titleMedium
                        ?.copyWith(fontSize: 16.sp),
                  ),
                  centerTitle: true,
                  leading: GestureDetector(
                    onTap: () => context.go(AppRoutes.homeScreen),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.goalSearch,
                          extra: context.read<GoalsBloc>()),
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Image.asset(
                          AssetConstants.searchIcon,
                          width: 22.w,
                        ),
                      ),
                    )
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(80.h),
                    child: Column(
                      children: [
                        TabBar(
                          dividerHeight: 0,
                          controller: _tabController,
                          isScrollable: true,
                          indicator:
                              const BoxDecoration(color: Colors.transparent),
                          indicatorPadding: EdgeInsets.zero,
                          padding: EdgeInsets.only(right: 16.w),
                          indicatorSize: TabBarIndicatorSize.label,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.only(left: 16.w),
                          overlayColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          tabs: tabNames
                              .map((name) => _buildTab(
                                  context, name, tabNames.indexOf(name)))
                              .toList(),
                        ),
                        Constant.verticalSpace(20.h),
                      ],
                    ),
                  ),
                ),
                body: state.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: tabStatuses.map((status) {
                          return FilteredGoalView(
                            goalsList: status == null
                                ? state.goalsList
                                : state.goalsList
                                    .where((e) => e.status == status)
                                    .toList(),
                          );
                        }).toList(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final isSelected = _currentIndex == index;

    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                    isSelected ? AppColors.whiteColor : const Color(0xFF181818),
              ),
        ),
      ),
    );
  }
}

class FilteredGoalView extends StatelessWidget {
  const FilteredGoalView({super.key, required this.goalsList});
  final List<CreateGoalModel> goalsList;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GoalsBloc>().add(GetGoalsData());
        return Future.value();
      },
      child: Column(
        children: [
          AddGoalLength(length: goalsList.length),
          Expanded(
            child: goalsList.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.horizontalPadding.w),
                      child: const Text(
                        "Let's Set Your Goals! Define your career aspirations and keep them on track with our goal setting tools.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : GoalListView(goalsList: goalsList),
          ),
        ],
      ),
    );
  }
}

class GoalListView extends StatelessWidget {
  const GoalListView({super.key, required this.goalsList});
  final List<CreateGoalModel> goalsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: goalsList.length,
      padding: EdgeInsets.only(top: 12.h),
      itemBuilder: (context, index) {
        return GoalCard(
          goalModel: goalsList[index],
          onTap: () {
            context
                .read<GoalsBloc>()
                .add(GoalDetailEvent(goalId: '${goalsList[index].goalId}'));
            context.push(AppRoutes.finilizedGoalDetail,
                extra: context.read<GoalsBloc>());
          },
        );
      },
    );
  }
}

class AddGoalLength extends StatelessWidget {
  const AddGoalLength({super.key, required this.length});
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constant.horizontalPadding.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: "Added Goals ",
              style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.blackColor),
              children: <TextSpan>[
                TextSpan(
                  text: "($length)",
                  style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.createGoal,
                extra: context.read<AddGoalBloc>()..add(ClearFields())),
            child: Text(
              '+ Add Goals',
              style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
