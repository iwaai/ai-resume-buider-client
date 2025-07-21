import 'dart:convert';
import 'dart:io';

import 'package:second_shot/models/AwardAnswerModel.dart';
import 'package:second_shot/models/AwardQuestionModel.dart';

import '../../models/add_support_people_model.dart';
import '../../models/library_model.dart';
import '../../utils/constants/app_url.dart';
import '../../utils/constants/assets.dart';
import '../api_service.dart';

class MyLibraryRepo {
  final apiService = ApiService();

  Future<void> getSkillsLikes({
    required Function(List<LibraryModel> models) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.get(AppUrl.getSkillsLikes, authorize: true);

      if (response.success) {
        final modelList = (response.data as List).map((e) {
          return LibraryModel.fromJson(e);
        }).toList();
        print('Model List ${modelList.length}');
        onSuccess(modelList);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getFormQuestions({
    required Function(List<AwardQuestionModel> models) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.get(AppUrl.getFormQuestions, authorize: true);

      if (response.success) {
        final fetchedModels = (response.data as List)
            .map((e) => AwardQuestionModel.fromJson(e))
            .toList();

        /// Manual mapping for static values
        final mappedModels = List<AwardQuestionModel>.generate(5, (index) {
          final model = fetchedModels[index];

          switch (index + 1) {
            case 1:
              return AwardQuestionModel(
                  id: model.id,
                  question: model.question,
                  questionNo: model.questionNo,
                  createdAt: model.createdAt,
                  image: AssetConstants.rookieAward,
                  title: 'Getting in the Game',
                  subTitle:
                      'Identifying Top Transferable Skills:\nAdaptability and Flexibility. Congratulations!',
                  singleAnswer: model.singleAnswer,
                  dialoDescription:
                      "the Rookie Award for Identifying Top Transferable Skills.",
                  description2: "Congratulations!");
            case 2:
              return AwardQuestionModel(
                  id: model.id,
                  question: model.question,
                  questionNo: model.questionNo,
                  createdAt: model.createdAt,
                  // image: AssetConstants.playBook,
                  image: AssetConstants.gameAward,
                  title: 'Ready to Compete',
                  subTitle: 'Exploring Career Choices',
                  singleAnswer: model.singleAnswer,
                  dialoDescription:
                      "the Playbook Pro Award for identifying her top Career Choice:",
                  description2: "Congratulations!");
            case 3:
              return AwardQuestionModel(
                id: model.id,
                question: model.question,
                questionNo: model.questionNo,
                createdAt: model.createdAt,
                image: AssetConstants.mvpAward,
                // image: AssetConstants.gameAward,
                title: 'Most Valuable Player',
                subTitle:
                    'Selecting a College, Trade School, or Company to research or apply to.',
                singleAnswer: model.singleAnswer,
                dialoDescription: "the Game Time Award for selecting the",
                description2: "to further research and apply. Congratulations!",
              );
            case 4:
              return AwardQuestionModel(
                  id: model.id,
                  question: model.question,
                  questionNo: model.questionNo,
                  createdAt: model.createdAt,
                  image: AssetConstants.careerAward,
                  title: 'Undefeated',
                  subTitle: 'Creating a LinkedIn Profile',
                  singleAnswer: model.singleAnswer,
                  dialoDescription:
                      "the Career Champion Award for completing her LinkedIn Profile.",
                  description2: '');

            case 5:
              return AwardQuestionModel(
                  id: model.id,
                  question: model.question,
                  questionNo: model.questionNo,
                  createdAt: model.createdAt,
                  image: AssetConstants.hallOfFame,
                  title: 'The Goat',
                  subTitle: 'Creating a Statement of Focus',
                  singleAnswer: model.singleAnswer,
                  dialoDescription:
                      "the Hall of Fame Award for completing her Individual Development Plan. Congratulations!",
                  description2: '');
            default:
              return model;
          }
        });

        onSuccess(mappedModels);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updateAwardForm(
      {required Function() onSuccess,
      required Function(String message) onFailure,
      required AwardQuestionModel model,
      bool isListAnswer = false}) async {
    var body = {
      'questionId': model.id,
      'answer': isListAnswer == true ? model.listAnswer : model.singleAnswer,
    };
    try {
      final response =
          await apiService.post(AppUrl.updateForm, body: body, authorize: true);
      if (response.success) {
        onSuccess();
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getAwards({
    required Function(List<AwardAnswerModel> answerModels) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getAwards, authorize: true);
      if (response.success) {
        final List<AwardAnswerModel> fetchedModels =
            (response.data['data'] as List).map((e) {
          if (e['answer'] is List) {
            return AwardAnswerModel.fromJsonListAnswer(e);
          } else {
            return AwardAnswerModel.fromJsonSingleAnswer(e);
          }
        }).toList();
        onSuccess(fetchedModels);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> sendAwardReportToEmail(
      {required File awardReport,
      required Function() onSuccess,
      required Function(String message) onFailure}) async {
    try {
      final response = await apiService.postMultipart(
        AppUrl.sendFormToEmail,
        authorize: true,
        files: {'idp-awards': awardReport},
      );
      if (response.success) {
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> shareIdpReport(
      {required Function() onSuccess,
      required Function(String message) onFailure,
      required File report,
      required List<SupportPerson> supportPeople}) async {
    final listOfSupportPersons =
        jsonEncode(supportPeople.map((e) => e.toJson()).toList());
    try {
      final response = await apiService.postMultipart(AppUrl.shareIdpReport,
          files: {'idp-awards': report},
          body: {'supportPeople': listOfSupportPersons});
      if (response.success) {
        print('SUCCESS');
        onSuccess();
      } else {
        print('FAILURE');
        onFailure(response.message.toString());
      }
    } catch (e) {
      print('ERROR::: ${e.toString()}');
      print('CATCH');
      onFailure(e.toString());
    }
  }
}
