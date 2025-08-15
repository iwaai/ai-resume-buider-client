import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/theme/theme_utils/app_colors.dart';
import 'package:second_shot/presentation/views/home/success_stories/explore_profile_view.dart';
import 'package:second_shot/presentation/views/home/success_stories/match_profile_view.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import '../../../router/route_constants.dart';
import '../components/dialogs_renderer.dart';

class SuccessStories extends StatefulWidget {
  const SuccessStories({super.key});

  @override
  State<SuccessStories> createState() => _SuccessStoriesState();
}

class _SuccessStoriesState extends State<SuccessStories>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    const InitialDialogRenderer(screen: AppRoutes.successStories)
        .showInitialDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = GoRouterState.of(context).extra as SuccessStoriesBloc;
    return BlocProvider.value(
      value: bloc
        ..add(ExploreProfileData())
        ..add(MatchProfileData()),
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: BlocConsumer<SuccessStoriesBloc, SuccessStoriesState>(
          listener: (context, state) {
            if ((state.result.event is ExploreProfileData ||
                    state.result.event is MatchProfileData) &&
                state.result.status == ResultStatus.error &&
                state.result.message.contains(Constant.accessDeniedMessage)) {
              SnackbarsType.error(context, state.result.message);
              context.pushReplacement(AppRoutes.homeScreen);
            }
          },
          builder: (context, state) {
            return ScaffoldWrapper(
              child: Scaffold(
                appBar: CustomAppBar(
                  title: 'Success Stories',
                  bottomWidget: PreferredSize(
                    preferredSize:
                        Size.fromHeight(65.h), // Set height for TabBar
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.horizontalPadding.w,
                          vertical: Constant.verticalPadding.h),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xff012C57))),
                        child: Container(
                          // height: 42.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7.r),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                              ),
                              tabs: const [
                                Tab(text: 'Matched Profiles'),
                                Tab(text: 'Explore All Profiles'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  trailingIcon: [
                    GestureDetector(
                      onTap: () {
                        context
                          ..read<SuccessStoriesBloc>()
                              .add(SetSearchType(index: _tabController.index))
                          ..push(AppRoutes.searchStory, extra: bloc
                              // extra: bloc,
                              );
                      },
                      child: Image.asset(
                        AssetConstants.searchIcon,
                        width: 22.w,
                        height: 22.h,
                      ),
                    ),
                    SizedBox(width: 16.w),
                  ],
                ),
                body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      MatchProfileView(),
                      // Second Tab Content
                      ExploreProfileView()
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
