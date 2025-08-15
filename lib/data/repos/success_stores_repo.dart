import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/api_response.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class StoriesRepo {
  final apiService = ApiService();

  // final storageService = LocalS
  // torage();

  Future<void> getExploreProfile({
    required int page,
    required Function(ApiResponse data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService
          .get('${AppUrl.exploreProfile}?page=$page', authorize: true);
      // print("explore =======> ${response.message}");
      if (response.success == true) {
        onSuccess(response);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getMatchProfile({
    required int page,
    required Function(ApiResponse data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.get(AppUrl.matchProfile, authorize: true);

      if (response.success == true) {
        onSuccess(response);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> searchStory(
      {required Function(ApiResponse data) onSuccess,
      required Function(String message) onFailure,
      required String search}) async {
    try {
      final response = await apiService
          .get("${AppUrl.searchStory}?search=$search", authorize: true);
      if (response.success == true) {
        onSuccess(response);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
