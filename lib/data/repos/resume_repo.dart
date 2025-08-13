import 'dart:convert';
import 'dart:io';

import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/get_resume_model.dart';

import '../../models/add_support_people_model.dart';
import '../../utils/constants/app_url.dart';

class ResumeRepo {
  final apiService = ApiService();

  Future<void> getMyResumes(
      {required Function(String message) onFailure,
      required Function(List<ResumeModel> model) onSuccess}) async {
    try {
      final res = await apiService.get(AppUrl.getMyResumes, authorize: true);
      if (res.success) {
        final modelList =
            (res.data as List).map((i) => ResumeModel.fromJson(i)).toList();
        onSuccess(modelList);
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> deleteResume(
      {required Function(String message) onFailure,
      required Function() onSuccess,
      required String id}) async {
    try {
      final res = await apiService.delete(AppUrl.deleteResume,
          authorize: true, body: {"resume_id": id});
      if (res.success) {
        onSuccess();
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> createResume(
      {required Function(String message) onFailure,
      required Function(ResumeModel model) onSuccess,
      required ResumeModel model}) async {
    try {
      final res = await apiService.post(AppUrl.createResume,
          authorize: true, body: model.toJsonCreateResume());
      if (res.success == true) {
        final model = ResumeModel.fromJson(res.data);
        onSuccess(model);
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> editResume(
      {required Function(String message) onFailure,
      required Function(ResumeModel model) onSuccess,
      required ResumeModel model}) async {
    try {
      final res = await apiService.put(AppUrl.updateResume,
          authorize: true, body: model.toJsonEditResume());
      if (res.success == true) {
        final model = ResumeModel.fromJson(res.data);
        onSuccess(model);
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> sendToEmail(
      {required Function(String message) onFailure,
      required Function() onSuccess,
      required File resume}) async {
    try {
      final res = await apiService.postMultipart(
        AppUrl.sendToEmail,
        authorize: true,
        files: {'resume': resume},
      );
      if (res.success == true) {
        onSuccess();
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> sendToSupportPeople({
    required Function(String message) onFailure,
    required Function() onSuccess,
    required AddSupportPeopleModel model,
  }) async {
    try {
      final supportPeopleJson = jsonEncode(
          model.supportPeople?.map((e) => e.toJson()).toList() ?? []);
      final res = await apiService
          .postMultipart(AppUrl.sendToSupportPeople, authorize: true, body: {
        'resumeId': model.resumeId,
        'supportPeople': supportPeopleJson
      }, files: {
        'resume': model.resume,
      });
      if (res.success == true) {
        print('Success!!!');
        onSuccess();
      } else {
        print('ERROR!!!');
        onFailure(res.message.toString());
      }
    } catch (e) {
      print('CATCH!!!');
      onFailure(e.toString());
    }
  }
}
