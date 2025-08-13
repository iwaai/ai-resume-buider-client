import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/goals/bloc/add_goal/bloc/add_goal_bloc.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/models/resume_data_model.dart';
import 'package:second_shot/presentation/components/resume_preview_widget.dart';
import 'package:second_shot/presentation/router/route_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/views/home/career_recommendations/search_recommendations.dart';
import 'package:second_shot/presentation/views/home/goals_settings/edit_support_people.dart';
import 'package:second_shot/presentation/views/home/goals_settings/goal_search_screen.dart';
import 'package:second_shot/presentation/views/home/success_stories/story_search_screen.dart';
import 'package:second_shot/presentation/views/resume_builder/resume_sacnner.dart';
import 'package:second_shot/presentation/views/subscription/current_plan_screen.dart';

import '../../blocs/home/resume_builder/resume_builder_bloc.dart';
import '../../models/get_resume_model.dart';
import '../views/home/goals_settings/finalized_goal_detail_screen.dart';
import '../views/home/my_library/awards/award_form_renderer.dart';
import '../views/home/resume_builder/components/library_resume_builder.dart';
import '../views/home/transferable_skills/components/library_transferable_skills.dart';

class GoRouters {
  static GoRouter routes = GoRouter(
    routes: List.generate(
      _routePaths.length,
      (i) => animatedRoute(path: _routePaths[i]),
    ),
  );

  static GoRoute animatedRoute({required String path}) {
    return GoRoute(
      path: path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: _getScreen(path: path, state: state),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              alignment: Alignment.topCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  static Widget _getScreen(
      {required String path, required GoRouterState state}) {
    switch (path) {
      case AppRoutes.splash:
        return const SplashScreen();
      case AppRoutes.addResume:
        return AddResume();
      case AppRoutes.login:
        return LoginScreen();
      case AppRoutes.signupScreen:
        return SignUpScreen();
      case AppRoutes.registration:
        return const RegistrationScreen();
      case AppRoutes.forgotPassword:
        return ForgotPasswordScreen();
      case AppRoutes.verifyOtp:
        return VerifyOtpScreen(arg: (state.extra as String?) ?? '');
      case AppRoutes.successScreen:
        return SuccessScreen(arg: (state.extra as String?) ?? '');
      case AppRoutes.setNewPassword:
        return SetNewPasswordScreen();
      case AppRoutes.homeScreen:
        return const HomeScreen();
      case AppRoutes.transferableSkills:
        return const TransferableSkills();
      case AppRoutes.uploadProfilePictureScreen:
        return UploadProfilePictureScreen();
      case AppRoutes.notificationScreen:
        return const NotificationScreen();
      case AppRoutes.careerRecommendations:
        return const CareerRecommendations();
      case AppRoutes.searchRecommendations:
        return const SearchRecommendations();
      case AppRoutes.careerRecommendationsDetails:
        return const CareerRecommendationDetailScreen();
      case AppRoutes.takeAssessment:
        return const TakeAssessmentScreen();
      case AppRoutes.goalSettings:
        return const GoalsSettings();
      case AppRoutes.supportPeople:
        return SupportPeopleScreen(bloc: state.extra as AddGoalBloc);
      case AppRoutes.resumeBuilder:
        return const ResumeBuilder();
      case AppRoutes.resumeDetails:
        return ResumeDetails(
            resumeBuilderBloc: (state.extra as Map<String, dynamic>)['bloc']
                as ResumeBuilderBloc,
            isPreview:
                (state.extra as Map<String, dynamic>)['isPreview'] as bool,
            model:
                (state.extra as Map<String, dynamic>)['model'] as ResumeModel);
      case AppRoutes.successStories:
        return const SuccessStories();
      case AppRoutes.myLibrary:
        return const MyLibrary();
      case AppRoutes.profileScreen:
        return const ProfileScreen();
      case AppRoutes.editProfileScreen:
        return EditProfile();
      case AppRoutes.chatBot:
        return Chatbot();
      case AppRoutes.createGoal:
        return CreateGoalScreen();
      case AppRoutes.smartGoal:
        return SmartGoalScreen(bloc: state.extra as AddGoalBloc);
      // case AppRoutes.goalDetail:
      //   return FinilizeGoalDetailScreen();
      case AppRoutes.reviewSmartGoal:
        return ReviewSmartGoalScreen(bloc: state.extra as AddGoalBloc);
      case AppRoutes.setting:
        return const SettingScreen();
      case AppRoutes.termsAndCondition:
        return const TermAndConditionScreen();
      case AppRoutes.privacyPolicy:
        return const PrivacyPolicyScreen();
      case AppRoutes.subscriptionScreen:
        return SubscriptionScreen(
            isSubscribed: (state.extra as bool?) ?? false);
      case AppRoutes.currentPlanScreen:
        return const CurrentPlanScreen();
      case AppRoutes.finilizedGoalDetail:
        return const FinilizeGoalDetailScreen();
      case AppRoutes.editSupportPeople:
        return EditSupportPeopleScreen();
      case AppRoutes.goalSearch:
        return const GoalSearchScreen();
      case AppRoutes.awardFormRenderer:
        return AwardFormRenderer(
          bloc: (state.extra as Map<String, dynamic>)['bloc'] as MyLibraryBloc,
          favouriteTSkills:
              (state.extra as Map<String, dynamic>)['TSkills'] as List<String>,
          favouriteCareers: (state.extra
              as Map<String, dynamic>)['FavouriteCareers'] as List<String>,
          isFromForm:
              (state.extra as Map<String, dynamic>)['isFromFrom'] as bool,
        );
      case AppRoutes.resumeScanner:
        return ResumeScannerScreen();
      case AppRoutes.searchStory:
        return StorySearchScreen(
            // isMatchProfileTab: state.extra,
            );
      default:
        return const SizedBox.shrink();
    }
  }

  static final List<String> _routePaths = [
    AppRoutes.splash,
    AppRoutes.login,
    AppRoutes.signupScreen,
    AppRoutes.forgotPassword,
    AppRoutes.verifyOtp,
    AppRoutes.setNewPassword,
    AppRoutes.successScreen,
    AppRoutes.uploadProfilePictureScreen,
    AppRoutes.registration,
    AppRoutes.homeScreen,
    AppRoutes.notificationScreen,
    AppRoutes.transferableSkills,
    AppRoutes.careerRecommendations,
    AppRoutes.searchRecommendations,
    AppRoutes.takeAssessment,
    AppRoutes.careerRecommendationsDetails,
    AppRoutes.goalSettings,
    AppRoutes.resumeBuilder,
    AppRoutes.successStories,
    AppRoutes.myLibrary,
    AppRoutes.profileScreen,
    AppRoutes.editProfileScreen,
    AppRoutes.chatBot,
    AppRoutes.createGoal,
    AppRoutes.smartGoal,
    AppRoutes.supportPeople,
    // AppRoutes.goalDetail,
    AppRoutes.reviewSmartGoal,
    AppRoutes.setting,
    AppRoutes.termsAndCondition,
    AppRoutes.privacyPolicy,
    AppRoutes.subscriptionScreen,
    AppRoutes.currentPlanScreen,
    AppRoutes.addResume,
    AppRoutes.resumeDetails,
    AppRoutes.finilizedGoalDetail,
    AppRoutes.editSupportPeople,
    AppRoutes.goalSearch,
    AppRoutes.searchStory,
    AppRoutes.awardFormRenderer,
    AppRoutes.resumeScanner
  ];
}
