import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_shot/presentation/components/common_dialogue_2.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../blocs/app/app_bloc.dart';
import '../../../../services/local_storage.dart';
import '../../../../utils/constants/assets.dart';

class InitialDialogRenderer extends StatelessWidget {
  const InitialDialogRenderer({super.key, required this.screen});

  final String screen;

  showInitialDialog(BuildContext context, {bool isTSkillDialog = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final isSubscribed = context.read<AppBloc>().state.user.isSubscriptionPaid;

    final initialDialogShown = LocalStorage().isDialogShown(screen);
    final tSkillDialogShown = prefs.getBool('TSkillDialogShown') ?? false;

    if (!initialDialogShown) {
      LocalStorage().setDialogState(screen);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final dialogContent = _dialogContent(context);

        CommonDialog(
          title: dialogContent['title']!,
          body: dialogContent['body']!,
          image: dialogContent['image']!,
        ).showCustomDialog(context).then((_) async {
          if (isTSkillDialog) {
            if (isSubscribed) {
              if (!tSkillDialogShown) {
                await prefs.setBool('TSkillDialogShown', true);
                showTSkillDialog(context);
              }
            } else {
              showTSkillDialog(context);
            }
          }
        });
      });

      return;
    }

    if (isTSkillDialog) {
      if (isSubscribed) {
        if (!tSkillDialogShown) {
          await prefs.setBool('TSkillDialogShown', true);
          showTSkillDialog(context);
        }
      } else {
        showTSkillDialog(context);
      }
    }
  }

  showTSkillDialog(BuildContext context) {
    CommonDialog(
      title: 'My Transferable Skills',
      body: context.read<AppBloc>().state.user.isSubscriptionPaid
          ? 'Click on each circle to expand to learn about how you can use your soft skills in other areas of your life. Click the ribbon to save your favorite skills.'
          : 'Explore key skills that can help you transition into new career paths. '
              'On the Free Plan, you can only access the first node in the Transferable Map. '
              'Unlock all circles by upgrading your plan. The free version allows clicking only on the top circle.',
    ).showCustomDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Dialog();
  }

  Map<String, String> _dialogContent(BuildContext context) {
    switch (screen) {
      case AppRoutes.homeScreen:
        return {
          'title': 'Welcome To Your Career Prep Toolbox!',
          'body': !context.read<AppBloc>().state.user.isSubscriptionPaid
              ? 'Thank you for trying out Career Prep. Your free access lets you try out our Transferable Skills Module. Click anywhere else on the screen to subscribe and get access to all modules.'
              : 'You can start with any tool first. Click on each tool to learn more of how to use it in your life.',
          'image': AssetConstants.careerToolbox,
        };
      case AppRoutes.transferableSkills:
        return {
          'title': 'My Transferable Skills',
          'body':
              """Here is a map of your transferable skills. Take a look at all the soft skills you have inside of you that you have have learned over your life.

Click on each circle to expand to learn about how you can use your soft skills in other areas of your life.

Click the ribbon to save your favorite skills. Once it turns green, your skill is stored in your library and ready to be added to your resume
anytime!""",
          'image': AssetConstants.transferrableSkillsDialog,
        };
      case AppRoutes.careerRecommendations:
        return {
          'title': 'My Career Recommendations',
          'body':
              """You will be given a short 24 question survey. Make sure you choose the answer that comes to mind first. Once you are finished you can review your 5 matched careers. You are able to retake the survey to receive a new set of matches.""",
          'image': AssetConstants.careerRecommendationsDialog,
        };
      case AppRoutes.goalSettings:
        return {
          'title': 'Welcome To The Goal Setting Hub!',
          'body':
              """Here you can create goals, set deadlines, make them S.M.A.R.T. and even break them down into sub-goals. Share your goals with your support network and track your progress easily. Let’s start turning your aspirations into achievements!""",
          'image': AssetConstants.goalSettingDialog,
        };
      case AppRoutes.resumeBuilder:
        return {
          'title': 'Welcome To The Resume Builder!',
          'body':
              """Easily create your professional resume with our guided example, step by step. Once you're done, forward it to your support network for feedback or download it for future use. Let's get started on your path to success!""",
          'image': AssetConstants.resumeBuilderWelcomeDialog,
        };
      case AppRoutes.successStories:
        return {
          'title': 'Success Stories',
          'body':
              """Here are success stories of people who have walked similar paths in life as you. You can search by profession, sport, military rank, or school. If they can do it, you can do it too!""",
          'image': AssetConstants.successStoriesWelcomeDialog,
        };
      case AppRoutes.myLibrary:
        return {
          'title': 'Welcome To Your Library!',
          'body':
              """You can view your saved transferable skills and matched careers. View your library as a snapshot of your strengths and abilities.""",
          'image': AssetConstants.myLibraryDialog,
        };
      default:
        return {};
    }
  }
}
