import 'dart:convert';
import 'dart:io';

import 'package:second_shot/blocs/home/transferable_skills/transferable_skills_bloc.dart';
import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/transferable_skills_model.dart';
import 'package:second_shot/utils/constants/app_url.dart';

import '../../models/add_support_people_model.dart';

class TransferableSkillsRepo {
  final apiService = ApiService();

  Future<void> getData(
      {required Function(TransferableSkillsModel model) onSuccess,
      required Function(String message) onFailure}) async {
    try {
      final response =
          await apiService.get(AppUrl.myTransferableSkills, authorize: true);
      if (response.success) {
        final model = TransferableSkillsModel.fromJson(response.data);
        onSuccess(model);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> removeFromLibrary({
    required Function() onSuccess,
    required Function(String message) onFailure,
    required String nodeId,
    required String descriptionId,
    required ShowNode nodeName,
  }) async {
    try {
      final Map<String, dynamic> requestBody =
          _buildRequestBody(nodeName, nodeId, descriptionId);

      if (requestBody.isEmpty) {
        onFailure("Invalid node type.");
        return;
      }

      final response = await apiService.post(
        AppUrl.toggleLike,
        authorize: true,
        body: requestBody,
      );

      if (response.success) {
        onSuccess();
      } else {
        onFailure(response.message ?? "Failed");
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Map<String, dynamic> _buildRequestBody(
      ShowNode nodeName, String nodeId, String descriptionId) {
    switch (nodeName) {
      case ShowNode.favoriteHobby1:
        return {
          "favorite_hobby1": {
            "favorite_hobbyId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      case ShowNode.favoriteHobby2:
        return {
          "favorite_hobby2": {
            "favorite_hobbyId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      case ShowNode.atheleteSportsPosition:
        return {
          "athlete": {
            "athleteId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      case ShowNode.athletePrimarySport:
        return {
          "sport": {
            "sportId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      case ShowNode.favoriteSchoolSubject:
        return {
          "favorite_middle_school_subject": {
            "favoriteSubjectId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      case ShowNode.military:
        return {
          "rank": {
            "rankId": nodeId,
            "descriptionId": descriptionId,
          }
        };
      default:
        return {}; // Return empty map for invalid cases
    }
  }

  Future<void> sendToSupportPeople({
    required Function(String message) onFailure,
    required Function() onSuccess,
    required AddSupportPeopleInTSkill model,
  }) async {
    try {
      final tSkillSupportPeople =
          jsonEncode(model.supportPeople.map((e) => e.toJson()).toList());
      final res = await apiService.postMultipart(AppUrl.sendTSkillSupportPeople,
          authorize: true,
          body: {
            'supportPeople': tSkillSupportPeople
          },
          files: {
            'transferablleSkills': model.file,
          });
      if (res.success == true) {
        onSuccess();
      } else {
        onFailure(res.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> sendSkillsToEmail(
      {required Function(String message) onFailure,
      required Function() onSuccess,
      required File TSkillPdf}) async {
    try {
      final res = await apiService.postMultipart(
        AppUrl.sendSkillsToEmail,
        authorize: true,
        files: {'transferablleSkills': TSkillPdf},
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
}
