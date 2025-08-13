part of 'career_recommendations_bloc.dart';

class CareerRecommendationsState {
  final Result? result;
  final List<CareerRecommendation> careerRecommendations;
  final List<CareerRecommendation> favCareerRecommendations;
  final List<CareerRecommendation> searched;
  final String query;
  final bool isVerified;
  CareerRecommendation selectedRecommendation;
  final CareerPoint selectedCareer;
  final bool loading;
  final bool buttonLoading;
  final bool detailsLoading;

  CareerRecommendationsState({
    required this.result,
    this.loading = false,
    this.buttonLoading = false,
    this.detailsLoading = false,
    this.careerRecommendations = const [],
    this.favCareerRecommendations = const [],
    this.searched = const [],
    this.query = '',
    this.isVerified = false,
    required this.selectedRecommendation,
    required this.selectedCareer,
  });

  CareerRecommendationsState copyWith({
    Result? result,
    bool? loading,
    bool? buttonLoading,
    bool? detailsLoading,
    CareerRecommendation? selectedRecommendation,
    List<CareerRecommendation>? careerRecommendations,
    List<CareerRecommendation>? favCareerRecommendations,
    List<CareerRecommendation>? searched,
    String? query,
    bool? isVerified,
    CareerPoint? selectedCareer,
  }) {
    return CareerRecommendationsState(
      result: result ?? this.result,
      loading: loading ?? this.loading,
      buttonLoading: buttonLoading ?? this.buttonLoading,
      detailsLoading: detailsLoading ?? this.detailsLoading,
      selectedRecommendation:
      selectedRecommendation ?? this.selectedRecommendation,
      careerRecommendations:
      careerRecommendations ?? this.careerRecommendations,
      favCareerRecommendations:
      favCareerRecommendations ?? this.favCareerRecommendations,
      searched: searched ?? this.searched,
      query: query ?? this.query,
      isVerified: isVerified ?? this.isVerified,
      selectedCareer: selectedCareer ?? this.selectedCareer,
    );
  }

  factory CareerRecommendationsState.idle() {
    return CareerRecommendationsState(
      selectedCareer: CareerPoint.initial(),
      result: Result.idle(),
      loading: false,
      buttonLoading: false,
      detailsLoading: false,
      careerRecommendations: [],
      favCareerRecommendations: [],
      searched: [],
      query: '',
      isVerified: false,
      selectedRecommendation: CareerRecommendation.initial(),
    );
  }
}
