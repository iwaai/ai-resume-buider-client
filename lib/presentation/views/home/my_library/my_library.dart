library my_library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/models/AwardAnswerModel.dart';
import 'package:second_shot/models/get_resume_model.dart';
import 'package:second_shot/models/library_model.dart';
import 'package:second_shot/models/transferable_skills_model.dart';
import 'package:second_shot/presentation/components/career_recommendation_card.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/views/home/my_library/awards/idp_report_pdf_generator.dart';
import 'package:second_shot/presentation/views/home/my_library/awards/share_idp_dialog.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/extensions.dart';

import '../../../../blocs/home/my_library/my_library_bloc.dart';
import '../../../router/route_constants.dart';
import '../../../theme/theme_utils/app_colors.dart';
import '../components/dialogs_renderer.dart';

part '../my_library/components/recommendation_text_box.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCont;

  @override
  void initState() {
    super.initState();
    const InitialDialogRenderer(screen: AppRoutes.myLibrary)
        .showInitialDialog(context);
    _tabCont = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (GoRouterState.of(context).extra as MyLibraryBloc)
        ..add(GetDataEvent())
        ..careerRecommendationsBloc.add(GetFavCareerRecommendations())
        ..add(GetAwardsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyLibraryBloc args = GoRouterState.of(context).extra as MyLibraryBloc;
    return BlocProvider.value(
      value: args,
      child: ScaffoldWrapper(
          child: Scaffold(
        appBar: CustomAppBar(
          title: 'Personal Plan',
          bottomWidget: PreferredSize(
            preferredSize: Size.fromHeight(65.h),
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
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      controller: _tabCont,
                      tabs: const [
                        Tab(text: 'IDP Form'),
                        Tab(text: 'Careers'),
                        Tab(text: 'T-Skills'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          trailingIcon: [
            _tabCont.index == 1
                ? GestureDetector(
                    onTap: () async {
                      context.push(AppRoutes.searchRecommendations, extra: {
                        'bloc': args.careerRecommendationsBloc
                          ..add(SearchCareerRecommendations(
                              fromLibrary: true, query: '')),
                        'fromLibrary': true
                      });
                    },
                    child: Image.asset(
                      AssetConstants.searchIcon,
                      height: 18.h,
                    ),
                  )
                : _tabCont.index == 0
                    ? BlocBuilder<MyLibraryBloc, MyLibraryState>(
                        builder: (context, state) {
                        final TransferableSkillsModel? tSkill =
                            args.tSkillBloc.state.model;
                        final ResumeModel? resume =
                            args.resumeBloc.state.models.firstOrNull;
                        final userName =
                            context.read<AppBloc>().state.user.name;
                        bool hasAllAwards =
                            state.awardAnswerModels.every((answer) {
                          final hasList = answer.listAnswer != null &&
                              answer.listAnswer!.isNotEmpty;
                          final hasSingle = answer.singleAnswer != null &&
                              answer.singleAnswer!.trim().isNotEmpty;
                          return hasList || hasSingle;
                        });

                        return ThreeDotsMenu(
                          menuItems: const [
                            'Email it to Yourself',
                            'Download',
                            'Share'
                          ],
                          menuActions: [
                            /// Send To Email
                            () async {
                              if (!hasAllAwards) {
                                SnackbarsType.error(
                                  duration: const Duration(milliseconds: 5000),
                                  context,
                                  'Please get all Awards to download IDP Report.',
                                );
                                return;
                              }
                              SnackbarsType.success(
                                  duration: const Duration(milliseconds: 5000),
                                  context,
                                  'Your IDP Report is being sent to your email...');
                              final awardReport = await generateCombinedPDF(
                                  userName: userName,
                                  context: context,
                                  resumeModel: resume,
                                  tSkillModel: tSkill,
                                  awardAnswerModels: state.awardAnswerModels);
                              if (awardReport != null) {
                                args.add(SendAwardReportToEmailEvent(
                                    awardReport: awardReport));
                              }
                            },

                            /// Download
                            () async {
                              if (!hasAllAwards) {
                                SnackbarsType.error(
                                  duration: const Duration(milliseconds: 5000),
                                  context,
                                  'Please get all Awards to download IDP Report.',
                                );
                                return;
                              }

                              SnackbarsType.success(
                                  duration: const Duration(milliseconds: 5000),
                                  context,
                                  'Your IDP Report is downloading...');

                              await generateCombinedPDF(
                                  openFile: true,
                                  awardAnswerModels: state.awardAnswerModels,
                                  context: context,
                                  userName: userName,
                                  tSkillModel: tSkill,
                                  resumeModel: resume);
                            },

                            /// Send To Support People
                            () async {
                              SnackbarsType.success(
                                  duration: const Duration(milliseconds: 5000),
                                  context,
                                  'Your IDP Report is being created...');
                              final pdf = await generateCombinedPDF(
                                  userName: userName,
                                  context: context,
                                  resumeModel: resume,
                                  tSkillModel: tSkill,
                                  awardAnswerModels: state.awardAnswerModels);
                              if (pdf != null) {
                                CommonDialog(
                                        isSupport: true,
                                        customDialog: ShareIdpDialog(
                                            bloc: context.read<MyLibraryBloc>(),
                                            file: pdf))
                                    .showCustomDialog(context);
                              }
                            },
                          ],
                        );
                      })
                    : const SizedBox.shrink(),
            SizedBox(width: 16.w),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
          ),
          child: TabBarView(
            controller: _tabCont,
            children: [
              /// IDP
              BlocConsumer<MyLibraryBloc, MyLibraryState>(
                  listener: (context, state) {
                if (state.result.event is SendAwardReportToEmailEvent) {
                  SnackbarsType.success(context,
                      'Your IDP Report has been sent your to email successfully!');
                } else if (state.result.event is SendAwardReportToEmailEvent &&
                    state.result.status == ResultStatus.error) {
                  SnackbarsType.error(context,
                      'Failed to send IDP Report!, Please try again later.');
                }
              }, builder: (context, state) {
                return Scaffold(
                  floatingActionButton: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: PrimaryButton(
                        onPressed: () {
                          final List<String> favouriteCareers = args
                              .careerRecommendationsBloc
                              .state
                              .careerRecommendations
                              .expand((model) => model.careers
                                  .map((career) => career.career.name))
                              .toList();
                          final List<String> favouriteTSkills =
                              List.from(state.models.map((model) {
                            final String title =
                                model.getLibraryModel?.title ?? '';
                            return title;
                          }).toList());
                          favouriteTSkills.removeWhere((str) => str == '');
                          context.push(AppRoutes.awardFormRenderer, extra: {
                            'bloc': context.read<MyLibraryBloc>(),
                            'TSkills': favouriteTSkills,
                            'FavouriteCareers': favouriteCareers,
                            'awardStep': state.awardStep,
                            'isFromFrom': true,
                          });
                        },
                        text: '+ Create your Individual Development Plan'),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerTop,
                  body: BlocBuilder<MyLibraryBloc, MyLibraryState>(
                    builder: (context, state) {
                      final List<String> favouriteCareers = args
                          .careerRecommendationsBloc.state.careerRecommendations
                          .expand((model) =>
                              model.careers.map((career) => career.career.name))
                          .toList();
                      final List<String> favouriteTSkills =
                          List.from(state.models.map((model) {
                        final String title = model.getLibraryModel?.title ?? '';
                        return title;
                      }).toList());
                      favouriteTSkills.removeWhere((str) => str == '');
                      return CustomScrollView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            child: state.loading == true
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 10.h),
                                    padding: EdgeInsets.only(top: 70.h),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      AwardAnswerModel? model;
                                      if (state.awardAnswerModels.isNotEmpty) {
                                        model = state.awardAnswerModels[index];
                                      }
                                      return AwardCard(
                                        model: model,
                                        index: index,
                                        buttonOnTap: () {
                                          context.read<MyLibraryBloc>().add(
                                              AwardStepReset(step: index + 1));
                                          context.push(
                                              AppRoutes.awardFormRenderer,
                                              extra: {
                                                'bloc': context
                                                    .read<MyLibraryBloc>(),
                                                'TSkills': favouriteTSkills,
                                                'FavouriteCareers':
                                                    favouriteCareers,
                                                'isFromFrom': false,
                                              });
                                          // state.awardStep = index;
                                        },
                                        onCardTap: () {
                                          context.read<MyLibraryBloc>().add(
                                              AwardStepReset(step: index + 1));
                                          context.push(
                                              AppRoutes.awardFormRenderer,
                                              extra: {
                                                'bloc': context
                                                    .read<MyLibraryBloc>(),
                                                'TSkills': favouriteTSkills,
                                                'FavouriteCareers':
                                                    favouriteCareers,
                                                'isFromFrom': false,
                                              });
                                        },
                                      );
                                    }),
                          )
                        ],
                      );
                    },
                  ),
                );
              }),

              /// Career Recommendationss
              BlocProvider.value(
                value: args.careerRecommendationsBloc,
                child: BlocConsumer<CareerRecommendationsBloc,
                    CareerRecommendationsState>(
                  listener: (context, state) {
                    if (state.result != null) {
                      if ((state.result!.event is MarkRecommendationFavorite ||
                              state.result!.event is MarkACareerFavorite) &&
                          state.result!.status == ResultStatus.successful) {
                        SnackbarsType.success(context, state.result!.message);
                      }
                      if ((state.result!.event is MarkRecommendationFavorite ||
                              state.result!.event is MarkACareerFavorite ||
                              state.result!.event
                                  is GetFavCareerRecommendations) &&
                          state.result!.status == ResultStatus.error &&
                          state.result!.message
                              .contains(Constant.accessDeniedMessage)) {
                        SnackbarsType.error(context, state.result!.message);
                        context.pushReplacement(AppRoutes.homeScreen);
                      }
                    }
                  },
                  builder: (context, state) {
                    final careerRecomms = state.favCareerRecommendations;
                    return state.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondaryColor,
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              args.careerRecommendationsBloc
                                  .add(GetFavCareerRecommendations());
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  child: state.favCareerRecommendations.isEmpty
                                      ? const Center(
                                          child: Text(
                                              'No Career recommendations marked favorite!'),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: () async {
                                            args.careerRecommendationsBloc.add(
                                                GetFavCareerRecommendations());
                                          },
                                          child: ListView.builder(
                                            itemCount: careerRecomms.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CareerRecommendationCard(
                                                isLibrary: true,
                                                careerRecommendation:
                                                    careerRecomms[index],
                                                onTapFwd: () {
                                                  context.push(
                                                      AppRoutes
                                                          .careerRecommendationsDetails,
                                                      extra: context.read<
                                                          CareerRecommendationsBloc>()
                                                        ..add(GetCareerRecommendationByID(
                                                            fromLibrary: true,
                                                            careerRecommendationId:
                                                                careerRecomms[
                                                                        index]
                                                                    .favoriteID!)));
                                                },
                                                onTapLike: () {
                                                  context
                                                      .read<
                                                          CareerRecommendationsBloc>()
                                                      .add(MarkRecommendationFavorite(
                                                          fromLibrary: true,
                                                          careerRecommendationId:
                                                              careerRecomms[
                                                                      index]
                                                                  .recommendationId,
                                                          careers:
                                                              careerRecomms[
                                                                      index]
                                                                  .careers
                                                                  .map((e) => e
                                                                      .career
                                                                      .id)
                                                                  .toList()));
                                                  // Recommendation Would Disappear from favourite list
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),

              /// T-Skills
              BlocConsumer<MyLibraryBloc, MyLibraryState>(
                listener: (context, state) {
                  print(
                      'listener ${state.result.event} ${state.result.status}');
                  if (state.result.event is GetDataEvent &&
                      state.result.status == ResultStatus.error &&
                      state.result.message
                          .contains(Constant.accessDeniedMessage)) {
                    SnackbarsType.error(context, state.result.message);
                    context.pushReplacement(AppRoutes.homeScreen);
                  }
                  if (state.result.event is SendAwardReportToEmailEvent) {
                    SnackbarsType.success(context,
                        'Your IDP Report has been sent your to email successfully!');
                  } else if (state.result.event
                          is SendAwardReportToEmailEvent &&
                      state.result.status == ResultStatus.error) {
                    SnackbarsType.error(context,
                        'Failed to send IDP Report!, Please try again later.');
                  }
                },
                builder: (context, state) {
                  return state.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondaryColor,
                          ),
                        )
                      : state.models.isEmpty
                          ? const Center(
                              child: Text('No Skills marked favorite!'),
                            )
                          : ListView.builder(
                              itemCount: state.models.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                final CustomLibraryModel? model =
                                    state.models[index].getLibraryModel;
                                return MyLibraryCard(
                                  isCareer: false,
                                  model: model,
                                );
                              },
                            );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class AwardCard extends StatelessWidget {
  final int index;
  final AwardAnswerModel? model;
  final void Function()? buttonOnTap;
  final void Function() onCardTap;

  const AwardCard(
      {super.key,
      required this.index,
      required this.model,
      required this.buttonOnTap,
      required this.onCardTap});

  Map<String, dynamic> getCardDetails(int index) {
    switch (index) {
      case 0:
        {
          return {
            'title': 'Getting in the Game',
            'colors': const Color(0xFF5470B5),
            'image': AssetConstants.rookieAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Rookie Award for identifying her top transferable skills: ${model?.listAnswer?.join(', ')}. Congratulations!"
            // model?.listAnswer,
          };
        }
      case 1:
        {
          return {
            'title': 'Ready to Complete',
            'colors': const Color(0xFF00303A),
            'image': AssetConstants.gameAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Playbook Pro Award for identifying her top Career ${model?.listAnswer?.join(',')}. Congratulations!",
          };
        }
      case 2:
        {
          return {
            'title': 'Most Valuable Player',
            'colors': Colors.pink.shade300,
            'image': AssetConstants.mvpAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Game Time Award for selecting the ${model?.singleAnswer} to further research and apply. Congratulations!",
          };
        }
      case 3:
        {
          return {
            'title': 'Undefeated',
            'colors': const Color(0xFFDE6CFF),
            'image': AssetConstants.careerAward,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Career Champion Award for ${model?.singleAnswer} completing her LinkedIn Profile",
          };
        }
      case 4:
        {
          return {
            'title': 'The Goat',
            'colors': const Color(0xFF0080FF),
            'image': AssetConstants.hallOfFame,
            'answer':
                "Second Shot has awarded Aubrey Kaufman the Hall of Fame Award for completing her Individual ${model?.singleAnswer} Development Plan. Congratulations!",
          };
        }
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = getCardDetails(index)['colors'];
    final String title = getCardDetails(index)['title'];
    final String image = getCardDetails(index)['image'];
    final dynamic answer = getCardDetails(index)['answer'];
    final bool showButton = model != null
        ? index <= 1
            ? model?.listAnswer == null
            : index <= 5
                ? model?.singleAnswer == null
                : false
        : true;
    return GestureDetector(
      onTap: () {
        if (!showButton) {
          print("Clicked");
          onCardTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.grey.withOpacity(0.5)),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 80.h,
              width: 80.w,
              opacity: AlwaysStoppedAnimation(model != null
                  ? index <= 1
                      ? model?.listAnswer == null
                          ? 0.3
                          : 1
                      : model?.singleAnswer == null
                          ? 0.3
                          : 1
                  : 0.3),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: model != null
                    ? index <= 1
                        ? model?.listAnswer == null
                            ? color.withOpacity(0.4)
                            : color
                        : model?.singleAnswer == null
                            ? color.withOpacity(0.4)
                            : color
                    : color.withOpacity(0.4),
              ),
            ),
            SizedBox(height: 16.h),
            if (!showButton)
              Text(
                answer,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: color,
                ),
              ),

            Visibility(
              visible: showButton,
              child:
                  PrimaryButton(onPressed: buttonOnTap, text: "Get the Badge"),
            ),
            // Constant.verticalSpace(.h)
          ],
        ),
        // height: 150,
        // width: 50,
      ),
    );
  }
}
