import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/auth/auth_bloc.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';

import '../../router/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage();
  @override
  void initState() {
    super.initState();

    // storage.removeData();

    Future.delayed(const Duration(seconds: 2), () {
      if (storage.token == null || storage.token!.isEmpty) {
        context.go(AppRoutes.login);
      } else {
        context.read<AuthBloc>().add(GetUserProfile());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.result.status == ResultStatus.successful &&
            state.result.event is GetUserProfile) {
          final user = context.read<AppBloc>().state.user;
          if (user.isSubscriptionPaid == false) {
            context.go(AppRoutes.subscriptionScreen);
          } else if (user.isProfileCompleted == false) {
            context.go(AppRoutes.uploadProfilePictureScreen);
          } else if (user.isRegistrationQuestionCompleted == false) {
            context
              ..read<RegistrationQuestionsBloc>().add(EmptyFormEvent())
              ..go(AppRoutes.registration);
          } else {
            context.read<NotificationsBloc>()..add(OnInit());
            context.go(AppRoutes.homeScreen);
          }
        }
      },
      child: ScaffoldWrapper(
        child: Scaffold(
            body: Center(
          child: SizedBox(
              width: 272.w,
              height: 272.h,
              child: Image.asset(AssetConstants.appLogo)),
        )

            //  Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child:
            //   Center(
            //     child:
            //      Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         const Text('Splash'),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         PrimaryButton(
            //           buttonColor: Colors.red,
            //           // width: 250,
            //           // onPressed: () {
            //           //   showDialog(
            //           //     context: context,
            //           //     builder: (context) => Dialog(
            //           //       child: AlertDialog(
            //           //         icon: Image.asset(
            //           //             'assets/images/career_recommendations_dialog.png'),
            //           //         title: Text(
            //           //           'Career Recommendation',
            //           //           textAlign: TextAlign.center,
            //           //           style: context.textTheme.titleLarge?.copyWith(
            //           //             fontWeight: FontWeight.bold,
            //           //           ),
            //           //         ),
            //           //         content: Text(
            //           //           '''You’ve been matched with five potential careers! Take a moment to click through each one and explore sample job titles, career pathways, and recommended education.
            //           //
            //           //                     Be sure to mark your favorites so you can save them in your library. This way, you’ll have easy access to revisit and review them later.
            //           //
            //           //                     If you’re interested in exploring even more career options, you can always retake the assessment for additional matches.''',
            //           //           textAlign: TextAlign.center,
            //           //           style: context.textTheme.titleMedium?.copyWith(
            //           //             color: AppColors.grey.withOpacity(.8),
            //           //           ),
            //           //         ),
            //           //         actions: [
            //           //           PrimaryButton(
            //           //             onPressed: () {
            //           //               context.pop();
            //           //             },
            //           //             text: 'Okay',
            //           //           ),
            //           //         ],
            //           //       ),
            //           //     ),
            //           //   );
            //           // },
            //           onPressed: () {
            //             const CommonDialog(
            //               image: AssetConstants.careerRecommendationsImage,
            //               title: 'Career Recommendation',
            //               body:
            //                   '''You’ve been matched with five potential careers! Take a moment to click through each one and explore sample job titles, career pathways, and recommended education.

            //          Be sure to mark your favorites so you can save them in your library. This way, you’ll have easy access to revisit and review them later.
            //        If you’re interested in exploring even more career options, you can always retake the assessment for additional matches.''',
            //               // okBtnFunction: () {},
            //             ).showCustomDialog(context);
            //           },
            //           text: 'Login',
            //         )
            //         //       PrimaryButton(
            //         //         buttonColor: Colors.red,
            //         //         width: 150,
            //         //         onPressed: () {
            //         //           showDialog(
            //         //             context: context,
            //         //             builder: (context) => AlertDialog(
            //         //               contentPadding: EdgeInsets.all(
            //         //                   16.0), // optional for padding control
            //         //               icon: Image.asset(
            //         //                   'assets/images/career_recommendations_dialog.png'),
            //         //               title: Text(
            //         //                 'Career Recommendation',
            //         //                 textAlign: TextAlign.center,
            //         //                 style: context.textTheme.titleLarge?.copyWith(
            //         //                   fontWeight: FontWeight.bold,
            //         //                 ),
            //         //               ),
            //         //               content: Text(
            //         //                 '''You’ve been matched with five potential careers! Take a moment to click through each one and explore sample job titles, career pathways, and recommended education.
            //         //
            //         // Be sure to mark your favorites so you can save them in your library. This way, you’ll have easy access to revisit and review them later.
            //         //
            //         // If you’re interested in exploring even more career options, you can always retake the assessment for additional matches.''',
            //         //                 textAlign: TextAlign.center,
            //         //                 style: context.textTheme.titleMedium?.copyWith(
            //         //                   color: AppColors.grey.withOpacity(.8),
            //         //                 ),
            //         //               ),
            //         //               actions: [
            //         //                 PrimaryButton(
            //         //                   onPressed: () {
            //         //                     context.pop();
            //         //                   },
            //         //                   text: 'Okay',
            //         //                 ),
            //         //               ],
            //         //             ),
            //         //           );
            //         //         },
            //         //         text: 'Login',
            //         //         // enabled: false,
            //         //       ),
            //         ,
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         const PrimaryDropdown(
            //             width: 250,
            //             hintText: 'hintText',
            //             options: [
            //               '1',
            //               '1',
            //               '1',
            //               '1',
            //               '1',
            //               '1',
            //             ])
            //       ],
            //     ),
            //   ),
            // ),

            ),
      ),
    );
  }
}
