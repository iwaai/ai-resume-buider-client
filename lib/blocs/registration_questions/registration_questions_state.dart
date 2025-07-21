// registration_state.dart
part of 'registration_questions_bloc.dart';

class RegistrationQuestionsState {
  String? selectedEducation;
  String educationalExpertise;
  List<String> allExpertise;
  String? q2Answer;
  bool? q3Answer;
  bool? q4Answer;
  List<ForceRanks> searchedRanks;
  List<ForceRanks> filteredRanks;
  ForceService? q4BranchAnswer;
  ForceRanks? q4rank;
  bool? q5Answer;
  SportsModel? q5Sport;
  List<SportsPositionsModel> filteredPositions;
  SportsPositionsModel? q5position;
  List<HobbyModel> hobbiesList;
  HobbyModel? q6Hobby;
  HobbyModel? q7Hobby;
  SubjectModel? q8subject;
  bool? q9Answer;
  String? q9JobTitle;

  String? q10Career;
  int step;

  bool isHighSchoolOrMiddleSchool;
  bool isAbove18;

  Result result;

  bool loading;
  RegistrationDataModel? registrationData;

  RegistrationQuestionsState({
    this.selectedEducation,
    this.educationalExpertise = 'default',
    this.allExpertise = const [],
    this.q2Answer,
    this.q3Answer,
    this.q4Answer,
    this.searchedRanks = const [],
    this.filteredRanks = const [],
    this.q4BranchAnswer,
    this.q4rank,
    this.q5Answer,
    this.q5Sport,
    this.q5position,
    this.hobbiesList = const [],
    this.filteredPositions = const [],
    this.q6Hobby,
    this.q7Hobby,
    this.q8subject,
    this.q9Answer,
    this.q9JobTitle,
    this.q10Career = 'default',
    this.step = 1,
    this.isHighSchoolOrMiddleSchool = false,
    this.isAbove18 = false,
    required this.result,
    this.loading = false,
    this.registrationData,
  });

  RegistrationQuestionsState copyWith({
    String? selectedEducation,
    String? educationalExpertise,
    List<String>? allExpertise,
    String? q2Answer,
    bool? q3Answer,
    bool? q4Answer,
    List<ForceRanks>? searchedRanks,
    List<ForceRanks>? filteredRanks,
    ForceService? q4BranchAnswer,
    ForceRanks? q4rank,
    bool? q5Answer,
    SportsModel? q5Sport,
    SportsPositionsModel? q5position,
    List<SportsPositionsModel>? filteredPositions,
    List<HobbyModel>? hobbiesList,
    HobbyModel? q6Hobby,
    HobbyModel? q7Hobby,
    SubjectModel? q8subject,
    bool? q9Answer,
    String? q9JobTitle,
    String? q10Career,
    int? step,
    bool? isHighSchoolOrMiddleSchool,
    bool? isAbove18,
    Result? result,
    bool? loading,
    RegistrationDataModel? registrationData,
  }) {
    return RegistrationQuestionsState(
      result: result ?? this.result,
      selectedEducation: selectedEducation ?? this.selectedEducation,
      educationalExpertise: educationalExpertise ?? this.educationalExpertise,
      allExpertise: allExpertise ?? this.allExpertise,
      q2Answer: q2Answer ?? this.q2Answer,
      q3Answer: q3Answer ?? this.q3Answer,
      q4Answer: q4Answer ?? this.q4Answer,
      searchedRanks: searchedRanks ?? this.searchedRanks,
      filteredRanks: filteredRanks ?? this.filteredRanks,
      q4BranchAnswer: q4BranchAnswer ?? this.q4BranchAnswer,
      q4rank: q4rank ?? this.q4rank,
      q5Answer: q5Answer ?? this.q5Answer,
      q5Sport: q5Sport ?? this.q5Sport,
      q5position: q5position ?? this.q5position,
      hobbiesList: hobbiesList ?? this.hobbiesList,
      filteredPositions: filteredPositions ?? this.filteredPositions,
      q6Hobby: q6Hobby ?? this.q6Hobby,
      q7Hobby: q7Hobby ?? this.q7Hobby,
      q8subject: q8subject ?? this.q8subject,
      q9Answer: q9Answer ?? this.q9Answer,
      q9JobTitle: q9JobTitle ?? this.q9JobTitle,
      q10Career: q10Career ?? this.q10Career,
      step: step ?? this.step,
      isHighSchoolOrMiddleSchool:
          isHighSchoolOrMiddleSchool ?? this.isHighSchoolOrMiddleSchool,
      isAbove18: isAbove18 ?? this.isAbove18,
      loading: loading ?? this.loading,
      registrationData: registrationData ?? this.registrationData,
    );
  }

  factory RegistrationQuestionsState.idle() {
    return RegistrationQuestionsState(
      result: Result.idle(),
      loading: false,
    );
  }
}
