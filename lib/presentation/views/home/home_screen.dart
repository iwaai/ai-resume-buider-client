import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/blocs/home/goals/bloc/goals_bloc.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/blocs/home/resume_builder/resume_builder_bloc.dart';
import 'package:second_shot/blocs/home/success_stories/success_stories_bloc.dart';
import 'package:second_shot/blocs/home/transferable_skills/transferable_skills_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/views/home/components/dialogs_renderer.dart';
import 'package:second_shot/utils/constants/result.dart';

import '../../../blocs/home/home_bloc.dart';
import '../../router/route_constants.dart';
import '../../theme/theme_utils/app_colors.dart';
import 'components/drawer.dart';
import 'components/home_appbar_component.dart';
import 'components/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _advancedDrawerController = AdvancedDrawerController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<int> _items = List.generate(2, (index) => index); // Fake data

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.homeScreen)
        .showInitialDialog(context);

    Future.delayed(const Duration(milliseconds: 350), () {
      for (var i = 0; i < _items.length; i++) {
        Future.delayed(Duration(milliseconds: i * 250), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(GetUserProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Home build');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc()..add(OnInitHome()),
        ),
        BlocProvider.value(
            value: context.read<RegistrationQuestionsBloc>()
              ..add(GetRegistrationQuestionsDataEvent())
              ..add(GetRegistrationDataEvent())),
        BlocProvider(
          create: (context) => SuccessStoriesBloc()
            ..add(ExploreProfileData())
            ..add(MatchProfileData()),
          lazy: true,
        ),
        BlocProvider.value(
          value: context.read<NotificationsBloc>()
            ..add(GetToggleNotification()),
        ),
        BlocProvider(
          create: (context) => TransferableSkillsBloc()..add(GetData()),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => ResumeBuilderBloc()..add(GetMyResumeEvent()),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => GoalsBloc()..add(GetGoalsData()),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => CareerRecommendationsBloc()
            ..add(GetCareerRecommendations())
            ..add(GetFavCareerRecommendations()),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => MyLibraryBloc(
              resumeBloc: context.read<ResumeBuilderBloc>(),
              tSkillBloc: context.read<TransferableSkillsBloc>(),
              careerRecommendationsBloc:
                  context.read<CareerRecommendationsBloc>())
            ..add(GetDataEvent()),
          lazy: true,
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.result.status == ResultStatus.successful &&
              state.result.event is GetUserProfile) {
            context.read<HomeBloc>().add(OnInitHome());
          }
        },
        child: AdvancedDrawer(
          backdrop: Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          openScale: 0.85,
          openRatio: 0.85,
          disabledGestures: false,
          childDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          drawer: Builder(builder: (context) {
            return DrawerComponent(
              advancedDrawerController: _advancedDrawerController,
              outerContext: context,
            );
          }),
          child: ScaffoldWrapper(
            showChatbot: true,
            child: Scaffold(
              body: Column(
                children: [
                  HomeAppBar(
                    openDrawer: _handleMenuButtonPressed,
                  ),
                  Expanded(
                    child: AnimatedList(
                      key: _listKey,
                      initialItemCount: 0,
                      itemBuilder: (context, index, animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(index.isEven ? -1.0 : 1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                                parent: animation, curve: Curves.easeIn),
                          ),
                          child: HomeCard(
                            index: _items[index],
                            outerContext: context,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
