import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/presentation/components/career_recommendation_card.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/constants/assets.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';

import '../components/dialogs_renderer.dart';

class CareerRecommendations extends StatefulWidget {
  const CareerRecommendations({super.key});

  @override
  State<CareerRecommendations> createState() => _CareerRecommendationsState();
}

class _CareerRecommendationsState extends State<CareerRecommendations> {
  @override
  void initState() {
    const InitialDialogRenderer(screen: AppRoutes.careerRecommendations)
        .showInitialDialog(
      context,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = GoRouterState.of(context).extra as CareerRecommendationsBloc;
      args.add(GetCareerRecommendations());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as CareerRecommendationsBloc;
    return BlocProvider.value(
      value: args,
      child: ScaffoldWrapper(
          showChatbot: true,
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'My Career Recommendations',
              trailingIcon: [
                IconButton(
                  onPressed: () {
                    context.push(AppRoutes.searchRecommendations, extra: {
                      'bloc': args
                        ..add(SearchCareerRecommendations(
                            fromLibrary: false, query: '')),
                      'fromLibrary': false
                    });
                  },
                  icon: Image.asset(
                    AssetConstants.searchIcon,
                    height: 18.h,
                  ),
                )
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: BlocConsumer<CareerRecommendationsBloc,
                CareerRecommendationsState>(
              listener: (context, state) {
                if (state.result?.event is VerifyPassword &&
                    state.result?.status == ResultStatus.error) {
                  SnackbarsType.error(
                      context, 'Incorrect Password!, Please try again');
                } else if (state.result?.event is VerifyPassword &&
                    state.result?.status == ResultStatus.successful) {
                  SnackbarsType.success(
                      context, 'Password verified successfully!');
                  context.push(AppRoutes.takeAssessment,
                      extra: context.read<CareerRecommendationsBloc>());
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w)
                      .copyWith(bottom: 8.h),
                  child: PrimaryButton(
                      loading: state.buttonLoading,
                      onPressed: () {
                        if (state.careerRecommendations.isNotEmpty) {
                          String password = '';
                          CommonDialog(
                            customDialog: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp)),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('Enter Current Password',
                                      style: TextStyle(fontSize: 14.sp)),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                PrimaryTextField(
                                  onChanged: (v) {
                                    password = v;
                                  },
                                  hintText: 'Type here',
                                  isPassword: true,
                                  obscureText: true,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                PrimaryButton(
                                    loading: state.buttonLoading,
                                    onPressed: () {
                                      if (password == '') {
                                        SnackbarsType.error(
                                            context, 'Please enter password');
                                        return;
                                      }
                                      context.pop();
                                      context
                                          .read<CareerRecommendationsBloc>()
                                          .add(VerifyPassword(
                                              password: password));
                                    },
                                    text: 'Submit')
                              ],
                            ),
                          ).showCustomDialog(context);
                        } else {
                          context.push(AppRoutes.takeAssessment,
                              extra: context.read<CareerRecommendationsBloc>());
                        }
                      },
                      text: context
                              .read<CareerRecommendationsBloc>()
                              .state
                              .careerRecommendations
                              .isNotEmpty
                          ? 'Retake Assessment'
                          : 'Take the Assessment'),
                );
              },
            ),
            body: BlocConsumer<CareerRecommendationsBloc,
                CareerRecommendationsState>(listener: (context, state) {
              if (state.result != null) {
                if (state.result!.event is MarkRecommendationFavorite &&
                    state.result!.status == ResultStatus.successful) {
                  SnackbarsType.success(context, state.result!.message);
                }
                if ((state.result!.event is GetCareerRecommendations ||
                        state.result!.event is MarkACareerFavorite ||
                        state.result!.event is MarkRecommendationFavorite ||
                        state.result!.event is GetFavCareerRecommendations ||
                        state.result!.event is GetCareerRecommendationByID) &&
                    state.result!.status == ResultStatus.error &&
                    state.result!.message
                        .contains(Constant.accessDeniedMessage)) {
                  SnackbarsType.error(context, state.result!.message);
                  context.pushReplacement(AppRoutes.homeScreen);
                }
              }
            }, builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 2));

                    args.add(GetCareerRecommendations());
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: state.careerRecommendations.isEmpty
                            ? const Center(
                                child: Text(
                                  'Discover Your Career Path! Take the assessment and explore careers to find your perfect fit.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.sp)
                                    .copyWith(bottom: 70.h),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    args.add(GetCareerRecommendations());
                                  },
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 16.h),
                                    itemCount:
                                        state.careerRecommendations.length,
                                    itemBuilder: (context, index) {
                                      return CareerRecommendationCard(
                                        isLibrary: false,
                                        careerRecommendation:
                                            state.careerRecommendations[index],
                                        onTapLike: () {
                                          args.add(MarkRecommendationFavorite(
                                              fromLibrary: false,
                                              careerRecommendationId: state
                                                  .careerRecommendations[index]
                                                  .recommendationId,
                                              careers: state
                                                  .careerRecommendations[index]
                                                  .careers
                                                  .map((e) => e.career.id)
                                                  .toList()));
                                          // Recommendation Would Disappear from favourite list
                                        },
                                        onTapFwd: () {
                                          args.add(GetCareerRecommendationByID(
                                              fromLibrary: false,
                                              careerRecommendationId: state
                                                  .careerRecommendations[index]
                                                  .recommendationId));
                                          context.push(
                                              AppRoutes
                                                  .careerRecommendationsDetails,
                                              extra: args);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                      )
                    ],
                  ));
            }),
          )),
    );
  }
}
