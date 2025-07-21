import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/presentation/components/career_recommendation_card.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/utils/constants/result.dart';

class SearchRecommendations extends StatefulWidget {
  const SearchRecommendations({super.key});

  @override
  State<SearchRecommendations> createState() => _SearchRecommendationsState();
}

class _SearchRecommendationsState extends State<SearchRecommendations> {
  late CareerRecommendationsBloc bloc;
  late bool fromLibrary;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = GoRouterState.of(context).extra as Map<String, dynamic>;
      bloc = args['bloc'] as CareerRecommendationsBloc;
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.add(SearchCareerRecommendations(fromLibrary: fromLibrary, query: ''));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>;
    bloc = args['bloc'] as CareerRecommendationsBloc;
    fromLibrary = args['fromLibrary'] as bool;
    return BlocProvider.value(
      value: bloc,
      child:
          BlocConsumer<CareerRecommendationsBloc, CareerRecommendationsState>(
              listener: (context, state) {
        if (state.result != null) {
          if ((state.result!.event is MarkRecommendationFavorite ||
                  state.result!.event is MarkACareerFavorite) &&
              state.result!.status == ResultStatus.successful) {
            SnackbarsType.success(context, state.result!.message);
          }
        }
      }, builder: (context, state) {
        return ScaffoldWrapper(
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Search',
              bottomWidget: PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PrimaryTextField(
                    hintText: 'Search Recommendations',
                    onChanged: (String? v) {
                      bloc.add(SearchCareerRecommendations(
                          fromLibrary: fromLibrary, query: v ?? ""));
                    },
                  ),
                ),
              ),
            ),
            body: state.query.isEmpty && state.searched.isEmpty
                ? const Center(
                    child: Text('Start searching..'),
                  )
                : state.query.isNotEmpty && state.searched.isEmpty
                    ? const Center(
                        child: Text(
                            'No Recommendations found matching your query!'),
                      )
                    : ListView.builder(
                        itemCount: state.searched.length,
                        itemBuilder: (context, index) {
                          final current = state.searched[index];
                          return CareerRecommendationCard(
                            isLibrary: fromLibrary,
                            careerRecommendation: current,
                            onTapLike: () {
                              bloc.add(MarkRecommendationFavorite(
                                  fromSearch: true,
                                  fromLibrary: fromLibrary,
                                  careerRecommendationId:
                                      current.recommendationId,
                                  careers: current.careers
                                      .map((e) => e.career.id)
                                      .toList()));
                              // Recommendation Would Disappear from favourite list
                            },
                            onTapFwd: () {
                              bloc.add(GetCareerRecommendationByID(
                                  fromLibrary: fromLibrary,
                                  careerRecommendationId: fromLibrary
                                      ? current.favoriteID ?? ""
                                      : current.recommendationId));
                              context.push(
                                  AppRoutes.careerRecommendationsDetails,
                                  extra: bloc);
                            },
                          );
                        }),
          ),
        );
      }),
    );
  }
}
