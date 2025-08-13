import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class ChatBotRepo {
  final apiService = ApiService();

  Future<void> chatBotMessage(
      {required Function(String response) onSuccess,
      required Function(String message) onFailure,
      required String message}) async {
    try {
      final response = await apiService
          .post(AppUrl.chatBot, authorize: true, body: {'message': message});
      if (response.success) {
        onSuccess(response.data);
      } else {
        onFailure(response.message ?? '');
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
