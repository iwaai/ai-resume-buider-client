import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/transferable_skills_repo.dart';
import 'package:second_shot/models/add_support_people_model.dart';
import 'package:second_shot/models/transferable_skills_model.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'transferable_skills_event.dart';
part 'transferable_skills_state.dart';

class TransferableSkillsBloc
    extends Bloc<TransferableSkillsEvent, TransferableSkillsState> {
  final repo = TransferableSkillsRepo();

  TransferableSkillsBloc() : super(TransferableSkillsState.idle()) {
    on<GreenNodePressed>((event, emit) {
      if (state.showNode == event.showNode) {
        emit(state.copyWith(showNode: ShowNode.none)); // First, close the node
      } else {
        emit(state.copyWith(showNode: event.showNode)); // Open the new node
      }
    });

    on<GetData>((event, emit) => _getData(event, emit));
    on<ToggleLike>((event, emit) => _toggleLike(event, emit));
    on<GeneratePDFEvent>((event, emit) => _generatePDFEvent(event, emit));
    on<ShareTSkillReportEvent>(
        (event, emit) => _shareTSkillReportEvent(event, emit));
    on<SentSkillSToEmail>((event, emit) => _sentSkillSToEmail(event, emit));
  }
  Future<void> _sentSkillSToEmail(SentSkillSToEmail event, Emitter emit) async {
    // emit(state.copyWith(loading: true, result: Result.idle()));
    await repo.sendSkillsToEmail(
        onFailure: (String message) {
          emit(state.copyWith(
              loading: false, result: Result.error(message, event)));
        },
        onSuccess: () {
          emit(state.copyWith(
              loading: false, result: Result.successful('', event)));
        },
        TSkillPdf: event.TSkillPdf);
  }

  Future<void> _shareTSkillReportEvent(
      ShareTSkillReportEvent event, Emitter emit) async {
    emit(state.copyWith(loading: true, result: Result.idle()));

    await repo.sendToSupportPeople(
        onFailure: (String message) {
          emit(state.copyWith(
            result: Result.error(message, event),
            loading: false,
          ));
        },
        onSuccess: () {
          emit(state.copyWith(
              result: Result.successful('Success', event), loading: false));
        },
        model: event.model);
  }

  void _generatePDFEvent(GeneratePDFEvent event, Emitter emit) {
    emit(state.copyWith(isScreenshot: true));
  }

  void _getData(GetData event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await repo.getData(
      onSuccess: (TransferableSkillsModel model) {
        emit(state.copyWith(
            result: Result.successful('', event),
            loading: false,
            model: model));
      },
      onFailure: (String message) {
        emit(state.copyWith(
            result: Result.error(message, event), loading: false));
      },
    );
  }

  Future<void> _toggleLike(ToggleLike event, Emitter emit) async {
    print('NODE ID ${event.nodeId}');
    // Get the current model
    TransferableSkillsModel mdl = state.model!;

    mdl = _updateModel(mdl, event);
    emit(state.copyWith(/*loading: true,*/ model: mdl));

    await repo.removeFromLibrary(
      nodeName: event.nodeName,
      nodeId: event.nodeId,
      descriptionId: event.descriptionId,
      onSuccess: () {
        emit(state.copyWith(
          result: Result.successful('', event),
          loading: false,
          // model: mdl,
        ));
      },
      onFailure: (String message) {
        mdl = _updateModel(mdl, event);
        print(message);
        emit(state.copyWith(
            result: Result.error(message, event), loading: false, model: mdl));
      },
    );
  }

  TransferableSkillsModel _updateModel(
      TransferableSkillsModel model, ToggleLike event) {
    switch (event.nodeName) {
      case ShowNode.favoriteHobby1:
        return model.copyWith(
          favoriteHobby1: model.favoriteHobby1!.copyWith(
            topics: _updateTopics(model.favoriteHobby1!.topics, event),
          ),
        );
      case ShowNode.favoriteHobby2:
        return model.copyWith(
          favoriteHobby2: model.favoriteHobby2!.copyWith(
            topics: _updateTopics(model.favoriteHobby2!.topics, event),
          ),
        );
      case ShowNode.atheleteSportsPosition:
        return model.copyWith(
          athlete: model.athlete?.copyWith(
              sportPosition: model.athlete?.sportPosition?.copyWith(
            topics: _updateTopics(model.athlete?.sportPosition?.topics, event),
          )),
        );
      case ShowNode.athletePrimarySport:
        return model.copyWith(
          athlete: model.athlete?.copyWith(
              primarySport: model.athlete?.primarySport?.copyWith(
            topics: _updateTopics(model.athlete?.primarySport?.topics, event),
          )),
        );
      case ShowNode.favoriteSchoolSubject:
        return model.copyWith(
          favoriteMiddleSchoolSubject:
              model.favoriteMiddleSchoolSubject!.copyWith(
            topics:
                _updateTopics(model.favoriteMiddleSchoolSubject!.topics, event),
          ),
        );
      case ShowNode.military:
        return model.copyWith(
          military: model.military!.copyWith(
              rank: model.military?.rank?.copyWith(
            topics: _updateTopics(model.military?.rank?.topics, event),
          )),
        );
      default:
        return model; // No change if the node doesn't match
    }
  }

  List<Topic> _updateTopics(List<Topic>? topics, ToggleLike event) {
    return topics?.map((topic) {
          if (topic.id == event.descriptionId) {
            return topic.copyWith(isFavorite: !(topic.isFavorite ?? false));
          }
          return topic;
        }).toList() ??
        [];
  }
}
