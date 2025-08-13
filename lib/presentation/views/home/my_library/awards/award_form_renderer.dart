import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/my_library/my_library_bloc.dart';
import 'package:second_shot/models/AwardAnswerModel.dart';
import 'package:second_shot/models/AwardQuestionModel.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/views/home/my_library/awards/idp_report_pdf_generator.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../../blocs/app/app_bloc.dart';
import '../../../../theme/theme_utils/app_colors.dart';
import '../../resume_builder/components/library_resume_builder.dart';

class AwardFormRenderer extends StatelessWidget {
  AwardFormRenderer(
      {super.key,
      required this.bloc,
      required this.favouriteTSkills,
      required this.favouriteCareers,
      required this.isFromForm});

  final MyLibraryBloc bloc;
  final List<String> favouriteTSkills;
  final List<String> favouriteCareers;
  final bool isFromForm;

  void _fillForm(MyLibraryBloc bloc, String v, {bool isListAnswer = false}) {
    final state = bloc.state;
    final updatedModels =
        List<AwardQuestionModel>.from(state.awardQuestionModels);
    if (isListAnswer) {
      updatedModels[state.awardStep - 1] =
          state.awardQuestionModels[state.awardStep - 1].copyWith(listAnswer: [
        ...?state.awardQuestionModels[state.awardStep - 1].listAnswer,
        v
      ]);
    } else {
      updatedModels[state.awardStep - 1] = state
          .awardQuestionModels[state.awardStep - 1]
          .copyWith(singleAnswer: v);
    }

    bloc.add(FillFormEvent(models: updatedModels));
  }

  TextEditingController mvpController = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController hallOfFameController = TextEditingController();
  List<String> tSkillAnswers = [];
  List<String> careerRecom = [];
  bool _isDataFilled = false;

  _fillData(
      {required List<AwardAnswerModel> answerModelList,
      required List<AwardQuestionModel> questionModelList,
      required MyLibraryBloc bloc}) {
    mvpController =
        TextEditingController(text: answerModelList[2].singleAnswer);
    careerController =
        TextEditingController(text: answerModelList[3].singleAnswer);
    hallOfFameController =
        TextEditingController(text: answerModelList[4].singleAnswer);
    _isDataFilled = true;
    tSkillAnswers = answerModelList[0].listAnswer ?? [];
    careerRecom = answerModelList[1].listAnswer ?? [];
    questionModelList[0] =
        questionModelList[0].copyWith(listAnswer: tSkillAnswers);
    questionModelList[1] =
        questionModelList[1].copyWith(listAnswer: careerRecom);
    questionModelList[2] =
        questionModelList[2].copyWith(singleAnswer: mvpController.text);
    questionModelList[3] =
        questionModelList[3].copyWith(singleAnswer: careerController.text);
    questionModelList[4] =
        questionModelList[4].copyWith(singleAnswer: hallOfFameController.text);
    bloc.add(FillFormEvent(models: questionModelList));
  }

  bool _validateFields(int stepIndex, BuildContext context) {
    String? errorMessage;

    switch (stepIndex) {
      case 1:
        if (tSkillAnswers.isEmpty) {
          errorMessage = 'Please select your answer.';
        }
        break;
      case 2:
        if (careerRecom.isEmpty) {
          errorMessage = 'Please select your answer.';
        }
        break;
      case 3:
        if (mvpController.text.isEmpty) {
          errorMessage = 'Please enter your answer.';
        }
        break;
      case 4:
        if (careerController.text.isEmpty) {
          errorMessage = 'Please enter your answer.';
        }
        break;
      case 5:
        if (hallOfFameController.text.isEmpty) {
          errorMessage = 'Please enter your answer.';
        }
        break;
    }

    if (errorMessage != null) {
      SnackbarsType.error(context, errorMessage);
      return false;
    }

    return true;
  }

  bool getDownloadButton(
      int stepIndex, List<AwardAnswerModel> answerModelList) {
    if (stepIndex < 0 || stepIndex >= answerModelList.length) return false;

    final model = answerModelList[stepIndex];

    if ((stepIndex == 0 || stepIndex == 1) &&
        model.listAnswer != null &&
        model.listAnswer!.isNotEmpty) {
      return true;
    }

    if ((stepIndex == 2 || stepIndex == 3 || stepIndex == 4) &&
        model.singleAnswer != null) {
      return true;
    }

    return false;
  }

  bool showDownloadButton = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc..add(GetFormQuestions()),
      child: BlocConsumer<MyLibraryBloc, MyLibraryState>(
          listener: (context, state) {
            showDownloadButton =
                getDownloadButton(state.awardStep - 1, state.awardAnswerModels);
            if (state.result.event is UpdateAwardFormEvent &&
                state.result.status == ResultStatus.successful) {
            } else if (state.result.event is UpdateAwardFormEvent &&
                state.result.status == ResultStatus.error) {}
            if (state.result.event is GetFormQuestions &&
                state.result.status == ResultStatus.successful) {
              final myLibraryBloc = context.read<MyLibraryBloc>();
              if (state.awardQuestionModels.isNotEmpty) {
                List<AwardQuestionModel> questionModelList =
                    List.from(state.awardQuestionModels);
                List<AwardAnswerModel> answerModelList =
                    List.from(state.awardAnswerModels);
                if (_isDataFilled == false &&
                    answerModelList.isNotEmpty &&
                    state.loading == false) {
                  _fillData(
                      bloc: myLibraryBloc,
                      answerModelList: answerModelList,
                      questionModelList: questionModelList);
                }
              }
            }
          },
          buildWhen: (p, n) => true,
          builder: (context, state) {
            final myLibraryBloc = context.read<MyLibraryBloc>();
            final stepIndex = state.awardStep - 1;
            AwardQuestionModel questionModel = AwardQuestionModel();
            List<AwardQuestionModel> questionModelList = [];
            if (state.awardQuestionModels.isNotEmpty) {
              questionModelList = List.from(state.awardQuestionModels);
              questionModel = questionModelList[stepIndex];
            }

            // if (_isDataFilled == false &&
            //     answerModelList.isNotEmpty &&
            //     state.loading == false) {
            /*  _fillData(
                    bloc: myLibraryBloc,
                    answerModelList: answerModelList,
                    questionModelList: questionModelList);*/
            // questionModel = questionModel.copyWith(
            //     listAnswer: answerModelList[stepIndex].listAnswer);
            // for (int i = 0; i <= questionModelList.length - 1; i++) {
            //   questionModel = questionModelList[i].copyWith(
            //       listAnswer: answerModelList[i].listAnswer,
            //       singleAnswer: answerModelList[i].singleAnswer);
            //   questionModelList[i] = questionModel;
            // }
            // }
            return ScaffoldWrapper(
              child: Scaffold(
                appBar: CustomAppBar(
                  title: 'Get Badges',
                  onClick: () {
                    myLibraryBloc.add(AwardStepReset());
                    context.read<MyLibraryBloc>().add(GetAwardsEvent());

                    context.pop();
                  },
                ),
                body: state.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondaryColor,
                        ),
                      )
                    : state.awardQuestionModels.isEmpty
                        ? const Center(
                            child: Text(
                                'Please check your internet connection and try again.'),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// Stepper
                                  Steppers(
                                      selectedStep: state.awardStep,
                                      isAwardsScreen: true),
                                  SizedBox(height: 28.h),
                                  if (showDownloadButton == true)
                                    InkWell(
                                      onTap: () async {
                                        SnackbarsType.success(context,
                                            'Your IDP Award Report is downloading');
                                        await generateAwardPDF(
                                            openFile: true,
                                            index: stepIndex,
                                            awardAnswerModels:
                                                state.awardAnswerModels);
                                      },
                                      child: const Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          'Download Award',
                                          style: TextStyle(
                                              color: AppColors.primaryBlue),
                                        ),
                                      ),
                                    ),

                                  /// Award Image
                                  AnimatedScale(
                                    curve: Curves.elasticOut,
                                    scale: state.awardImageOpacity == 1.0
                                        ? 1.2
                                        : 0.9,
                                    duration: const Duration(milliseconds: 800),
                                    child: Opacity(
                                      opacity: state.awardImageOpacity,
                                      child: Image.asset(
                                        questionModel.image ?? '',
                                        height: 90.h,
                                        width: 90.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  /// Title
                                  Text(
                                    questionModel.title ?? 'title',
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10.h),

                                  /// Subtitle
                                  Text(
                                    questionModel.subTitle ?? 'Subtitle',
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  SizedBox(height: 18.h),

                                  /// Description
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      questionModel.question ?? 'Question',
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.labelLarge,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  /// Input Field
                                  /// Step 1 Rookie
                                  if (state.awardStep == 1)
                                    BlocBuilder<MyLibraryBloc, MyLibraryState>(
                                      builder: (context, state) {
                                        // final List<String> answers =
                                        //     tSkillAnswers;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PrimaryDropdown(
                                              // initialValue: answers.isNotEmpty
                                              //     ? answers[0]
                                              //     : '',
                                              onChanged: (v) {
                                                if (v != null &&
                                                    !tSkillAnswers
                                                        .contains(v)) {
                                                  tSkillAnswers.add(v);
                                                  print(
                                                      'TSkill Answer $tSkillAnswers');
                                                  final updatedModel =
                                                      questionModel.copyWith(
                                                          listAnswer:
                                                              tSkillAnswers);
                                                  questionModelList[stepIndex] =
                                                      updatedModel;
                                                  print(
                                                      'state before ${state.awardQuestionModels[stepIndex].listAnswer}');
                                                  context
                                                      .read<MyLibraryBloc>()
                                                      .add(FillFormEvent(
                                                          models:
                                                              questionModelList));
                                                  print(
                                                      'state after ${state.awardQuestionModels[stepIndex].listAnswer}');
                                                }
                                              },
                                              hintText: 'Select your answer',
                                              options: favouriteTSkills,
                                            ),
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: List.generate(
                                                  tSkillAnswers.length,
                                                  (index) {
                                                return Chip(
                                                  label: Text(
                                                    tSkillAnswers[index],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  deleteIcon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red),
                                                  onDeleted: () {
                                                    print(
                                                        'REMOVE CALLED ${tSkillAnswers.length}');
                                                    tSkillAnswers
                                                        .removeAt(index);
                                                    final updatedModel =
                                                        questionModel.copyWith(
                                                            listAnswer:
                                                                tSkillAnswers);
                                                    questionModelList[
                                                            stepIndex] =
                                                        updatedModel;
                                                    context
                                                        .read<MyLibraryBloc>()
                                                        .add(FillFormEvent(
                                                            models:
                                                                questionModelList));
                                                  },
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                  /// Step 2 Game Time
                                  if (state.awardStep == 2)
                                    BlocBuilder<MyLibraryBloc, MyLibraryState>(
                                      builder: (context, state) {
                                        final List<String> answers =
                                            careerRecom;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PrimaryDropdown(
                                              initialValue:
                                                  'Select your answer',
                                              onChanged: (v) {
                                                print("=====$v");
                                                if (v != null &&
                                                    !answers.contains(v)) {
                                                  answers.add(v);
                                                  final updatedModel =
                                                      questionModel.copyWith(
                                                          listAnswer: answers);
                                                  questionModelList[stepIndex] =
                                                      updatedModel;
                                                  context
                                                      .read<MyLibraryBloc>()
                                                      .add(FillFormEvent(
                                                          models:
                                                              questionModelList));
                                                }
                                              },
                                              hintText: 'Select your answer',
                                              options: favouriteCareers,
                                            ),
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: List.generate(
                                                  answers.length, (index) {
                                                return Chip(
                                                  label: Text(
                                                    answers[index],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  deleteIcon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red),
                                                  onDeleted: () {
                                                    answers.removeAt(index);
                                                    final updatedModel =
                                                        questionModel.copyWith(
                                                            listAnswer:
                                                                answers);
                                                    questionModelList[
                                                            stepIndex] =
                                                        updatedModel;
                                                    context
                                                        .read<MyLibraryBloc>()
                                                        .add(FillFormEvent(
                                                            models:
                                                                questionModelList));
                                                  },
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                  /// Step 3 MVP
                                  if (state.awardStep == 3)
                                    PrimaryTextField(
                                        controller: mvpController,
                                        onChanged: (v) {
                                          mvpController.text = v;
                                          _fillForm(myLibraryBloc,
                                              mvpController.text);
                                        },
                                        hintText: 'Enter your answer'),

                                  /// Step 4 Career Champion
                                  if (state.awardStep == 4)
                                    PrimaryTextField(
                                        controller: careerController,
                                        onChanged: (v) {
                                          _fillForm(myLibraryBloc, v);
                                        },
                                        hintText: 'Enter your answer'),

                                  /// Step 5 Hall of Fame
                                  if (state.awardStep == 5)
                                    PrimaryTextField(
                                        controller: hallOfFameController,
                                        onChanged: (v) {
                                          _fillForm(myLibraryBloc, v);
                                        },
                                        hintText: 'Enter your answer'),
                                  SizedBox(height: 10.h),
                                  PrimaryButton(
                                    text: 'Submit',
                                    onPressed: () {
                                      final isValid = _validateFields(
                                          state.awardStep, context);
                                      if (!isValid) {
                                        return;
                                      } else {
                                        print(
                                            'state==> ${state.awardQuestionModels.first.listAnswer}');
                                        final updatedModel = state
                                            .awardQuestionModels[stepIndex];
                                        print(
                                            'STATE CHANGES ${state.awardQuestionModels[0].listAnswer}');

                                        myLibraryBloc.add(UpdateAwardFormEvent(
                                            model: updatedModel,
                                            isListAnswer: state.awardStep < 3
                                                ? true
                                                : false));
                                        List<String> selectedValue = state
                                                .awardQuestionModels[
                                                    state.awardStep - 1]
                                                .listAnswer ??
                                            [];
                                        String selectedSingleValue = state
                                                .awardQuestionModels[
                                                    state.awardStep - 1]
                                                .singleAnswer ??
                                            '';
                                        String value = selectedValue.join(', ');
                                        CommonDialog(
                                          imageHeight: 120.h,
                                          image: state
                                              .awardQuestionModels[
                                                  state.awardStep - 1]
                                              .image,
                                          title: 'Congratulations',
                                          body:
                                              'Second Shot has awarded ${context.read<AppBloc>().state.user.name} ${questionModel.dialoDescription.toString()}  ${state.awardStep < 4 ? value.isEmpty ? selectedSingleValue : value : ''} ${questionModel.description2.toString()}',
                                          barrierDismissible: false,
                                        ).showCustomDialog(context).then((_) {
                                          if (state.awardStep != 5) {
                                            if (isFromForm == true) {
                                              print('Step Increment');
                                              context.read<MyLibraryBloc>().add(
                                                  AwardStepIncrementEvent());
                                            } else {
                                              context
                                                  .read<MyLibraryBloc>()
                                                  .add(GetAwardsEvent());
                                              myLibraryBloc
                                                  .add(AwardStepReset());
                                              context.pop();
                                            }
                                          } else {
                                            myLibraryBloc.add(
                                                UpdateAwardFormEvent(
                                                    model: updatedModel,
                                                    isListAnswer:
                                                        state.awardStep < 3
                                                            ? true
                                                            : false));
                                            context
                                                .read<MyLibraryBloc>()
                                                .add(GetAwardsEvent());
                                            myLibraryBloc.add(AwardStepReset());
                                            Future.delayed(
                                                    const Duration(seconds: 1))
                                                .then((_) {
                                              context.pop();
                                            });
                                          }
                                        });
                                      }
                                    },
                                    // text: 'Submit',
                                  ),
                                  SizedBox(height: 18.h),

                                  /// Skip Button
                                  InkWell(
                                    onTap: () {
                                      if (isFromForm == true) {
                                        if (state.awardStep != 5) {
                                          // AwardQuestionModel skippedModel =
                                          //     state.awardQuestionModels[
                                          //         state.awardStep - 1];
                                          // skippedModel = skippedModel.copyWith(
                                          //     listAnswer: null,
                                          //     singleAnswer: null);
                                          // myLibraryBloc.add(
                                          //     UpdateAwardFormEvent(
                                          //         model: skippedModel.copyWith(
                                          //             listAnswer: null),
                                          //         isListAnswer:
                                          //             state.awardStep < 3
                                          //                 ? true
                                          //                 : false));
                                          myLibraryBloc.add(
                                              AwardStepIncrementEvent(
                                                  isSkip: true));
                                        } else {
                                          // context
                                          //     .read<MyLibraryBloc>()
                                          //     .add(GetAwardsEvent());
                                          myLibraryBloc.add(AwardStepReset());
                                          context.pop();
                                        }
                                      } else {
                                        // context
                                        //     .read<MyLibraryBloc>()
                                        //     .add(GetAwardsEvent());
                                        myLibraryBloc.add(AwardStepReset());
                                        context.pop();
                                      }
                                    },
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ),
              ),
            );
          }),
    );
  }
}
