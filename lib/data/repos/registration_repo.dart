import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class RegistrationRepo {
  final apiService = ApiService();

  final storageService = LocalStorage();

  Future<void> getQuestions({
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getRegistrationQuestionsData,
          authorize: true);
      if (response.success == true) {
        onSuccess(response.data as Map<String, dynamic>);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> setRegistrationData({
    required Map<String, dynamic> body,
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.post(AppUrl.setRegistrationData, body: body);
      if (response.success == true) {
        print("============> ${response.data}");
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getData({
    required Function(RegistrationDataModel data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.get(AppUrl.getRegistrationData, authorize: true);
      if (response.success == true) {
        final dataModel = RegistrationDataModel.fromJson(response.data);
        onSuccess(dataModel);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
