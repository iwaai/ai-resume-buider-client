import 'package:second_shot/models/career_recomm_models.dart';

import '../../utils/constants/app_url.dart';
import '../api_service.dart';

class CareerRecommRepo {
  final apiService = ApiService();

  Future<void> verifyPassword(
      {required Function(bool isVerified) onSuccess,
      required Function(String message, bool isVerified) onFailure,
      required String password}) async {
    try {
      final response = await apiService
          .post(AppUrl.verifyPassword, body: {"current_password": password});
      if (response.success) {
        onSuccess(response.success);
      } else {
        onFailure(response.message.toString(), response.success);
      }
    } catch (e) {
      onFailure(e.toString(), false);
    }
  }

  Future<void> getQuestions({
    required Function(List<CareerRecommQuestion> models) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getCareerRecommQuestions);
      if (response.success) {
        final modelList = (response.data as List).map((e) {
          return CareerRecommQuestion.fromJson(e);
        }).toList();
        print('Model List ${modelList.length}');
        onSuccess(modelList);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getCareerRecommendations({
    required Function(List<CareerRecommendation> models) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getCareerRecommendations);
      if (response.success) {
        final modelList = (response.data as List).map((e) {
          return CareerRecommendation.fromJson(e);
        }).toList();
        print('Model List ${modelList.length}');
        onSuccess(modelList);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      print('Hit failure with message $e');

      onFailure(e.toString());
    }
  }

  Future<void> getCareerRecommendationByID({
    required String careerRecommendationId,
    required Function(CareerRecommendation model) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.post(AppUrl.getCareerRecommendationByID,
          body: {'recommendationId': careerRecommendationId});
      if (response.success) {
        final model = CareerRecommendation.fromJson(response.data);
        onSuccess(model);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getFavCareerRecommendationByID({
    required String favID,
    required Function(CareerRecommendation model) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.post(
          AppUrl.getFavCareerRecommendationByID,
          body: {'favoriteId': favID});
      if (response.success) {
        final data = FavoriteCareer.fromJson(response.data);

        onSuccess(data.toCareerRecommendation());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> markRecommendationFavorite({
    required String careerRecommendationId,
    required List<String> careers,
    required Function(String message) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.post(AppUrl.markRecommendationFavorite,
          body: {
            'recommendationId': careerRecommendationId,
            "careers": careers
          });
      if (response.success) {
        onSuccess(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> markCareerFavorite({
    required String careerRecommendationId,
    required String careerId,
    required Function(String message) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.post(AppUrl.markCareerFavorite, body: {
        'recommendationId': careerRecommendationId,
        "careerId": careerId
      });
      if (response.success) {
        onSuccess(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> submitAssessment({
    required List<Map<String, dynamic>> answers,
    required Function(String id) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService
          .post(AppUrl.submitAssessment, body: {'answers': answers});
      if (response.success) {
        onSuccess(response.data['_id']);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getCareerLikes({
    required Function(List<FavoriteCareer> models) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.get(AppUrl.getCareerLikes, authorize: true);

      if (response.success) {
        final modelList = (response.data as List).map((e) {
          return FavoriteCareer.fromJson(e);
        }).toList();
        print('Recomm Model List ${modelList.length}');
        onSuccess(modelList);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
