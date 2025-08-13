part of 'transferable_skills_bloc.dart';

enum ShowNode {
  none,
  favoriteHobby1,
  favoriteHobby2,
  atheleteSportsPosition,
  athletePrimarySport,
  favoriteSchoolSubject,
  military,
  centreNode
}

class TransferableSkillsState {
  ShowNode? showNode;
  Result result;
  bool loading;
  TransferableSkillsModel? model;
  bool isScreenshot;

  TransferableSkillsState({
    this.showNode,
    required this.result,
    this.loading = true,
    this.model,
    this.isScreenshot = false,
  });

  TransferableSkillsState copyWith({
    ShowNode? showNode,
    Result? result,
    bool? loading,
    bool? isScreenshot,
    TransferableSkillsModel? model,
  }) {
    return TransferableSkillsState(
      showNode: showNode ?? this.showNode,
      result: result ?? Result.idle(),
      loading: loading ?? this.loading,
      model: model ?? this.model,
      isScreenshot: isScreenshot ?? this.isScreenshot,
    );
  }

  factory TransferableSkillsState.idle() {
    return TransferableSkillsState(
        result: Result.idle(),
        loading: false,
        model: null,
        isScreenshot: false);
  }
}
