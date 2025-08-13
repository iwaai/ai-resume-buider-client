import 'package:flutter/material.dart';
import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/api_response.dart';
import 'package:second_shot/models/goal_model.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class GoalRepo {
  final apiService = ApiService();
  final storageService = LocalStorage();

  Future<void> getGoals({
    required Function(ApiResponse data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.myGoals, authorize: true);

      if (response.success == true) {
        onSuccess(response);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> createGoal(
      {required Function(CreateGoalModel gpal) onSuccess,
      required Function(String message) onFailure,
      required CreateGoalModel goalModel}) async {
    try {
      final response = await apiService.post(AppUrl.createGoal,
          body: goalModel.toJson(), authorize: true);
      if (response.success == true) {
        onSuccess(CreateGoalModel.fromJson(response.data));
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> goalDetails({
    required Function(CreateGoalModel goalModel) onSuccess,
    required Function(String message) onFailure,
    required String? goalId,
  }) async {
    try {
      final response =
          await apiService.post(AppUrl.goalDetail, authorize: true, body: {
        "goalId": goalId,
      });

      if (response.success == true) {
        CreateGoalModel goalData = CreateGoalModel.fromJson(response.data);

        onSuccess(goalData);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> addSuppportPeople({
    required Function(String message) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final reponse = await apiService.post(AppUrl.addSupportPeople);
      if (reponse.success == true) {
        onSuccess(reponse.message.toString());
      } else {
        onFailure(reponse.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> deleteGoal({
    required Function(String message) onSuccess,
    required Function(String message) onFailure,
    required String goalId,
  }) async {
    try {
      final repponse = await apiService.delete(
        AppUrl.deleteGoal,
        body: {'goalId': goalId},
      );
      if (repponse.success == true) {
        onSuccess(repponse.message.toString());
      } else {
        onFailure(repponse.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updateSubGoalStatus({
    required Function() onSuccess,
    required Function(String error) onFailure,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response =
          await apiService.post(AppUrl.updateSubGoalStatus, body: body);

      if (response.success == true) {
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updateMainGoalStatus(
      {required Function() onSuccess,
      required Function(String error) onFailure,
      required String goalId}) async {
    debugPrint("GOal Id is $goalId");
    try {
      final response = await apiService
          .post(AppUrl.changeGoalStatus, body: {'goalId': goalId});

      if (response.success == true) {
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> editSupportPeople({
    required Function(String res) onSuccess,
    required Function(String error) onError,
    required String goalId,
    required List<SupportPeople> supportPeople,
  }) async {
    final body = {'goalId': goalId, 'supportPeople': supportPeople};

    try {
      final response =
          await apiService.post(AppUrl.addSupportPeople, body: body);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onError(response.message.toString());
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> searchGoal({
    required Function onSuccess,
    required Function(String error) onError,
    required String search,
    required Map<String, dynamic> body,
  }) async {
    try {
      final resp = await apiService.post(AppUrl.searchGoal, body: body);
      if (resp.success == true) {
        onSuccess;
      } else {
        onError(resp.message.toString());
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
