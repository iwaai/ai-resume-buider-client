import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/registration_questions/registration_questions_bloc.dart';
import 'package:second_shot/presentation/components/common_dialog_screen.dart';
import 'package:second_shot/presentation/components/primary_button.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q1_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q3_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q4_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q5_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q6_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q7_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q8_widget.dart';
import 'package:second_shot/presentation/views/registration_questions/questions/q9_widget.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/result.dart';

class QuestionRenderer extends StatelessWidget {
  const QuestionRenderer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationQuestionsBloc, RegistrationQuestionsState>(
        listenWhen: (p, n) => p != n,
        listener: (context, state) {
          if (state.result.event is SubmitEvent &&
              state.result.status == ResultStatus.successful) {
            showDialog(
                context: context,
                builder: (_) {
                  return CommonDialogScreen(
                    title: 'Congratulations',
                    image: AssetConstants.registrationSuccessIcon,
                    imageSize: 88,
                    widget: Column(
                      children: [
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: 170.w,
                          child: PrimaryButton(
                            textSize: 16,
                            text: 'Let\'s Dive in',
                            onPressed: () {
                              context.go(AppRoutes.homeScreen);
                            },
                          ),
                        )
                      ],
                    ),
                    navigate: false,
                    description:
                        'You have successfully completed the registration. Get ready to embark on your journey with us!',
                  );
                });
          }
        },
        builder: (context, state) {
          switch (state.step) {
            case 1:
              return Q1Widget();
            // case 2:
            //   return const Q2Widget();
            case 2:
              return const Q3Widget();
            case 3:
              return const Q4Widget();
            case 4:
              return const Q5Widget();
            case 5:
              return const Q6Widget();

            case 6:
              return const Q7Widget();

            case 7:
              return const Q8Widget();

            case 8:
              return const Q9Widget();

            // case 10:
            //   return const Q10Widget();
            default:
              return const SizedBox();
          }
        });
  }
}
