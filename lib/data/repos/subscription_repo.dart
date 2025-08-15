import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/subscription_model.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class SubscriptionRepo {
  final apiService = ApiService();

  Future<void> buySubscription({
    required bool isAndroid,
    required String subscriptionName,
    required String purchaseToken,
    required String productId,
    required Function(String message) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.post(
          !isAndroid
              ? AppUrl.buySubscriptionIOS
              : AppUrl.buySubscriptionAndroid,
          body: {
            "subscription": subscriptionName,
            "purchase_token": purchaseToken,
            "product_id": productId
          });

      if (response.success) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getCurrentSubscription({
    required Function(SubscriptionModel message) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(
        AppUrl.mySubscription,
      );

      if (response.success) {
        onSuccess(SubscriptionModel.fromJson(response.data));
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
