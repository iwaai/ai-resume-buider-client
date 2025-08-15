part of 'career_recommendations_bloc.dart';

sealed class CareerRecommendationsEvent {}

class GetCareerRecommendations extends CareerRecommendationsEvent {}

class GetFavCareerRecommendations extends CareerRecommendationsEvent {}

class SearchCareerRecommendations extends CareerRecommendationsEvent {
  final bool fromLibrary;
  final String query;

  SearchCareerRecommendations({required this.fromLibrary, required this.query});
}

class GetCareerRecommendationByID extends CareerRecommendationsEvent {
  final String careerRecommendationId;
  final bool fromLibrary;

  GetCareerRecommendationByID(
      {required this.careerRecommendationId, required this.fromLibrary});
}

class MarkRecommendationFavorite extends CareerRecommendationsEvent {
  final String careerRecommendationId;
  final List<String> careers;
  final bool fromLibrary;
  final bool fromSearch;

  MarkRecommendationFavorite(
      {required this.careerRecommendationId,
      required this.careers,
      required this.fromLibrary,
      this.fromSearch = false});
}

class MarkACareerFavorite extends CareerRecommendationsEvent {
  final String careerRecommendationId;
  final String careerId;
  final bool fromLibrary;

  MarkACareerFavorite(
      {required this.careerRecommendationId,
      required this.careerId,
      required this.fromLibrary});
}

class OnSelectACareerInViewDetails extends CareerRecommendationsEvent {
  final CareerPoint career;

  OnSelectACareerInViewDetails({required this.career});
}

class VerifyPassword extends CareerRecommendationsEvent {
  final String password;

  VerifyPassword({required this.password});
}
