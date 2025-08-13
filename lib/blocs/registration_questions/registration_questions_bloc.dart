import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/registration_repo.dart';
import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/result.dart';
import 'package:second_shot/utils/enums.dart';

part 'registration_questions_event.dart';
part 'registration_questions_state.dart';

class RegistrationQuestionsBloc
    extends Bloc<RegistrationQuestionsEvent, RegistrationQuestionsState> {
  final RegistrationRepo registrationRepo = RegistrationRepo();
  final LocalStorage localStorage = LocalStorage();

  List<ForceService> forces = [];
  List<ForceRanks> allRanks = [];
  List<SportsModel> sports = [];
  List<SportsPositionsModel> sportsPosition = [];
  List<HobbyModel> hobbies = [];
  List<SubjectModel> subjects = [];

  RegistrationQuestionsBloc() : super(RegistrationQuestionsState.idle()) {
    on<UpdateQ1EducationEvent>((event, emit) {
      _updateQ1Education(event.education, emit);
    });

    on<UpdateQ1ExpertiseEvent>((event, emit) {
      _updateQ1Expertise(event.expertise, emit);
    });

    on<ResetExpertiseListEvent>((event, emit) {
      _resetExpertiseList(emit);
    });

    on<SearchEducationEvent>((event, emit) {
      _searchEducation(event.query, emit);
    });

    on<UpdateQ2AnswerEvent>((event, emit) {
      _updateQ2Answer(event.answer, emit);
    });

    on<UpdateQ3AnswerEvent>((event, emit) {
      _updateQ3Answer(event.answer, emit);
    });

    on<UpdateQ4AnswerEvent>((event, emit) {
      _updateQ4Answer(event.answer, emit);
    });

    on<UpdateQ4BranchAnswerEvent>((event, emit) {
      _updateQ4BranchAnswer(event.branch, emit);
    });

    on<UpdateQ4RankEvent>((event, emit) {
      _updateQ4Rank(event.rank, emit);
    });

    on<UpdateQ5AnswerEvent>((event, emit) {
      _updateQ5Answer(event.answer, emit);
    });

    on<SearchRankEvent>((event, emit) {
      _searchRanks(event.query, emit);
    });

    on<ResetRankListEvent>((event, emit) {
      _resetRankList(emit);
    });

    on<UpdateQ5SportEvent>((event, emit) {
      _updateQ5Sport(event.sport, emit);
    });

    on<UpdateQ5PositionEvent>((event, emit) {
      _updateQ5Position(event.position, emit);
    });

    on<ResetHobbiesEvent>((event, emit) {
      _resetHobbies(emit);
    });

    on<SearchHobbiesEvent>((event, emit) {
      _searchHobbies(event.query, emit);
    });

    on<UpdateQ6HobbyEvent>((event, emit) {
      _updateQ6Hobby(event.hobby, emit);
    });

    on<ResetSecondHobbiesEvent>((event, emit) {
      _resetSecHobbies(emit);
    });

    on<UpdateQ7HobbyEvent>((event, emit) {
      _updateQ7Hobby(event.hobby, emit);
    });

    on<UpdateQ8SubjectEvent>((event, emit) {
      _updateQ8Subject(event.subject, emit);
    });

    on<UpdateQ9AnswerEvent>((event, emit) {
      _updateQ9Answer(event.answer, emit);
    });

    on<UpdateQ9JobTitleEvent>((event, emit) {
      _updateQ9JobTitle(event.jobTitle, emit);
    });

    on<UpdateQ10CareerEvent>((event, emit) {
      _updateQ10Career(event, emit);
    });

    on<NextStepEvent>((event, emit) {
      _nextStep(emit);
    });

    on<PreviousStepEvent>((event, emit) {
      _previousStep(emit);
    });

    on<ResetStepsEvent>((event, emit) {
      emit(state.copyWith(step: 1));
    });

    on<EmptyFormEvent>((event, emit) {
      emit(RegistrationQuestionsState.idle());
    });

    on<UpdateAnswersForEditEvent>((event, emit) {
      _updateAnswersForEdit(emit);
    });

    on<GetRegistrationQuestionsDataEvent>(
        (event, emit) => _getRegistrationQuestionsData(event, emit));

    on<GetRegistrationDataEvent>(
        (event, emit) => _getRegistrationData(event, emit));

    on<SubmitEvent>((event, emit) => _submit(event, emit));
  }

  // Private Methods

  void _submit(SubmitEvent event, Emitter emit) async {
    print('Called');
    emit(state.copyWith(
        loading: true,
        result: Result.idle())); // Ensure state updates before async call

    Map<String, dynamic> data = {
      'current_grade_level': state.selectedEducation,
      'major_trade_or_military': state.educationalExpertise,
      'highest_degree_completion': state.q2Answer,
      'is_eighteen_or_older': state.q3Answer,
      'has_military_service': state.q4Answer,
      'branch_of_service': state.q4BranchAnswer?.id,
      'rank': state.q4rank?.id,
      'is_athlete': state.q5Answer,
      'primary_sport': state.q5Sport?.id,
      'sport_position': state.q5position?.id,
      'favorite_hobby1': state.q6Hobby?.id,
      'favorite_hobby2': state.q7Hobby?.id,
      'favorite_middle_school_subject': state.q8subject?.id,
      'has_job_experience': state.q9Answer,
      'recent_job_title': state.q9JobTitle,
      'desired_career_path': state.q10Career,
    };

    if (state.selectedEducation == 'Middle School' ||
        state.selectedEducation == 'High School') {
      data.remove('highest_degree_completion');
      data['has_military_service'] = false;
      data['is_eighteen_or_older'] = false;
    }

    if (state.selectedEducation != 'Middle School' ||
        state.selectedEducation != 'High School') {
      data['highest_degree_completion'] = 'default';
    }
    if (state.q3Answer == false) {
      data['has_military_service'] = false;
      data
        ..remove('branch_of_service')
        ..remove('rank');
    }
    if (state.q4Answer == false) {
      data
        ..remove('branch_of_service')
        ..remove('rank');
    }
    if (state.q5Answer == false) {
      data
        ..remove('primary_sport')
        ..remove('sport_position');
    }
    if (state.q9Answer == false) {
      data.remove('recent_job_title');
    }
    await registrationRepo.setRegistrationData(
      body: data,
      onSuccess: () {
        if (localStorage.user != null) {
          localStorage.setUser(localStorage.user!
              .copyWith(isRegistrationQuestionCompleted: true));
        }
        localStorage.removeRegistration();
        emit(RegistrationQuestionsState.idle().copyWith(
            result: Result.successful('', event),
            loading: false,
            step: 1,
            registrationData: RegistrationDataModel.idle()));

        print(state.selectedEducation);
      },
      onFailure: (String error) {
        emit(
            state.copyWith(result: Result.error(error, event), loading: false));
      },
    );
  }

  void _updateQ1Education(
      String? education, Emitter<RegistrationQuestionsState> emit) {
    final updatedState = state.copyWith(selectedEducation: education);
    bool skipQ2;
    List<String> expertiseList;
    if (education == Education.highSchool.toString() ||
        education == Education.middleSchool.toString()) {
      expertiseList = highSchoolSpecializations;
      skipQ2 = true;
    } else {
      expertiseList = afterHighSchoolSpecializations;
      skipQ2 = false;
    }
    emit(updatedState.copyWith(
        isHighSchoolOrMiddleSchool: skipQ2,
        allExpertise: expertiseList,
        educationalExpertise: 'default'));
  }

  void _updateQ1Expertise(
      String? expertise, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(educationalExpertise: expertise));
  }

  void _resetExpertiseList(Emitter<RegistrationQuestionsState> emit) {
    List<String> expertiseList;
    if (state.selectedEducation == Education.highSchool.toString() ||
        state.selectedEducation == Education.middleSchool.toString()) {
      expertiseList = highSchoolSpecializations;
    } else {
      expertiseList = afterHighSchoolSpecializations;
    }
    emit(state.copyWith(allExpertise: expertiseList));
  }

  void _searchEducation(
      String? query, Emitter<RegistrationQuestionsState> emit) {
    List<String> filteredExpertiseList;
    if (state.selectedEducation == Education.middleSchool.toString() ||
        state.selectedEducation == Education.highSchool.toString()) {
      filteredExpertiseList = highSchoolSpecializations
          .where((e) => e.toLowerCase().contains(query!.toLowerCase()))
          .toList();
    } else {
      filteredExpertiseList = afterHighSchoolSpecializations
          .where((e) => e.toLowerCase().contains(query!.toLowerCase()))
          .toList();
    }
    emit(state.copyWith(allExpertise: filteredExpertiseList));
  }

  void _searchRanks(String? query, Emitter<RegistrationQuestionsState> emit) {
    if (query == null || query.isEmpty) {
      emit(state.copyWith(searchedRanks: []));
      return;
    }
    final temp = state.filteredRanks
        .where((e) =>
            e.name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(searchedRanks: temp));
  }

  void _updateQ2Answer(
      String answer, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q2Answer: answer));
  }

  void _updateQ3Answer(bool answer, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q3Answer: answer, isAbove18: answer == true ? false : true));
  }

  void _updateQ4Answer(bool answer, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q4Answer: answer,
        q4BranchAnswer: ForceService.idle(),
        q4rank: ForceRanks.idle()));
  }

  void _updateQ4BranchAnswer(
      ForceService? branch, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q4BranchAnswer: branch, q4rank: ForceRanks.idle()));
    _resetRankList(emit);
  }

  void _resetRankList(Emitter<RegistrationQuestionsState> emit) {
    List<ForceRanks> ranks = allRanks
        .where((e) => e.service!.id == state.q4BranchAnswer?.id)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(state.copyWith(filteredRanks: ranks, searchedRanks: []));
  }

  void _updateQ4Rank(
      ForceRanks? rank, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q4rank: rank));
  }

  void _updateQ5Answer(bool answer, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q5Answer: answer,
        q5Sport: SportsModel.idle(),
        q5position: SportsPositionsModel.idle()));
  }

  void _updateQ5Sport(
      SportsModel sport, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q5Sport: sport, q5position: SportsPositionsModel.idle()));
    _resetSportsPositionList(emit);
  }

  void _resetSportsPositionList(Emitter<RegistrationQuestionsState> emit) {
    List<SportsPositionsModel> positions = sportsPosition
        .where((e) => e.sport!.id == state.q5Sport!.id)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    emit(state.copyWith(filteredPositions: positions, searchedRanks: []));
  }

  void _updateQ5Position(
      dynamic position, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q5position: position));
  }

  void _resetHobbies(Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(hobbiesList: hobbies));
    print('reset hobbies ${state.hobbiesList.length}');
    print('reset hobbies ${hobbies.length}');
  }

  void _searchHobbies(String? query, Emitter<RegistrationQuestionsState> emit) {
    List<HobbyModel> filteredHobbies = query == null
        ? hobbies
        : hobbies
            .where((hobby) => hobby.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
    emit(state.copyWith(hobbiesList: filteredHobbies));
  }

  void _updateQ6Hobby(
      HobbyModel? hobby, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q6Hobby: hobby,
        q7Hobby: (hobby?.id ?? '') == state.q7Hobby?.id
            ? HobbyModel.idle()
            : state.q7Hobby));
  }

  void _resetSecHobbies(Emitter<RegistrationQuestionsState> emit) {
    List<HobbyModel> sec = [...hobbies];
    sec.removeWhere(
        (e) => e.name.toLowerCase() == state.q6Hobby!.name.toLowerCase());
    emit(state.copyWith(hobbiesList: sec));
  }

  void _updateQ7Hobby(
      HobbyModel? hobby, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q7Hobby: hobby));
  }

  void _updateQ8Subject(
      SubjectModel? subject, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q8subject: subject));
  }

  void _updateQ9Answer(bool answer, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q9Answer: answer, q9JobTitle: answer == false ? "" : null));
  }

  void _updateQ9JobTitle(
      String? jobTitle, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(q9JobTitle: jobTitle));
  }

  void _updateQ10Career(
      UpdateQ10CareerEvent event, Emitter<RegistrationQuestionsState> emit) {
    emit(state.copyWith(
        q10Career: event.career, result: Result.successful('', event)));
  }

  void _nextStep(Emitter<RegistrationQuestionsState> emit) {
    int incBy = 1;
    if ((state.isAbove18 == true && state.step == 3)) {
      incBy = 2;
    }
    if (state.isHighSchoolOrMiddleSchool == true && state.step == 1) {
      incBy = 3;
    }
    final int newStep = state.q4Answer == true
        ? (state.step <= 10 ? state.step + incBy : state.step)
        : (state.step <= 9 ? state.step + incBy : state.step);
    emit(state.copyWith(step: newStep));
  }

  void _previousStep(Emitter<RegistrationQuestionsState> emit) {
    int decBy = 1;
    if (state.isAbove18 == true && state.step == 5) {
      decBy = 2;
    }
    if (state.isHighSchoolOrMiddleSchool == true && state.step == 4) {
      decBy = 3;
    }
    print(decBy);
    final int newStep = state.step > 1 ? state.step - decBy : state.step;
    emit(state.copyWith(step: newStep));
  }

  void _updateAnswersForEdit(Emitter emit) {
    add(UpdateQ1EducationEvent(state.registrationData!.currentGradeLevel));
    add(UpdateQ1ExpertiseEvent(state.registrationData!.majorTradeOrMilitary));
    add(UpdateQ2AnswerEvent(
        state.registrationData!.highestDegreeCompletion ?? ''));
    add(UpdateQ3AnswerEvent(
        state.registrationData!.isEighteenOrOlder ?? false));
    add(UpdateQ4AnswerEvent(
        state.registrationData!.hasMilitaryService ?? false));
    if (state.registrationData!.isEighteenOrOlder == true) {
      add(UpdateQ4BranchAnswerEvent(state.registrationData!.branchOfService));
      add(UpdateQ4RankEvent(state.registrationData!.rank));
    }
    add(UpdateQ5AnswerEvent(state.registrationData!.isAthlete ?? false));
    if (state.registrationData!.isAthlete == true) {
      add(UpdateQ5SportEvent(state.registrationData!.primarySport!));
      add(UpdateQ5PositionEvent(state.registrationData!.sportPosition));
    }
    add(UpdateQ6HobbyEvent(state.registrationData!.favoriteHobby1));
    add(UpdateQ7HobbyEvent(state.registrationData!.favoriteHobby2));
    add(UpdateQ8SubjectEvent(
        state.registrationData!.favoriteMiddleSchoolSubject));
    add(UpdateQ9AnswerEvent(state.registrationData!.hasJobExperience ?? false));
    if (state.registrationData!.hasJobExperience == true) {
      add(UpdateQ9JobTitleEvent(state.registrationData!.recentJobTitle));
    }
    add(UpdateQ10CareerEvent(state.registrationData!.desiredCareerPath));
  }

  void _getRegistrationQuestionsData(
      GetRegistrationQuestionsDataEvent event, Emitter emit) async {
    try {
      emit(
        state.copyWith(
          loading: true,
          result: Result.idle(),
        ),
      );
      if (localStorage.containsRegistrationQuestions == false) {
        await registrationRepo.getQuestions(onSuccess: (data) {
          localStorage.setRegistrationQuestions(data);
          _setQuestionsData(data);

          emit(
            state.copyWith(
              result: Result.successful('', event),
              loading: false,
            ),
          );
        }, onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
      } else {
        final data = localStorage.registrationQuestions ?? {};
        _setQuestionsData(data);
        emit(
          state.copyWith(
            result: Result.successful('', event),
            loading: false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void _setQuestionsData(Map<String, dynamic> data) {
    // Handle null values safely
    final servicesList = data['services'] as List? ?? [];
    final ranksList = data['ranks'] as List? ?? [];
    final sportsList = data['sports'] as List? ?? [];
    final sportPositionsList = data['sportPositions'] as List? ?? [];
    final hobbiesList = data['hobbies'] as List? ?? [];
    final subjectsList = data['subjects'] as List? ?? [];

    forces = servicesList
        .map((e) => ForceService.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    allRanks = ranksList
        .map((e) => ForceRanks.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    sports = sportsList
        .map((e) => SportsModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    sportsPosition = sportPositionsList
        .map((e) => SportsPositionsModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    hobbies = hobbiesList
        .map((e) => HobbyModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    subjects = subjectsList
        .map((e) => SubjectModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void _getRegistrationData(
      GetRegistrationDataEvent event, Emitter emit) async {
    if ((localStorage.user?.isRegistrationQuestionCompleted ?? false) == true) {
      try {
        emit(state.copyWith(loading: true, result: Result.idle()));
        if (localStorage.containsRegistrationData == false) {
          await registrationRepo.getData(onSuccess: (data) {
            localStorage.setRegistrationData(data);
            emit(
              state.copyWith(
                registrationData: data,
                result: Result.successful('', event),
                loading: false,
              ),
            );
          }, onFailure: (e) {
            emit(
              state.copyWith(result: Result.error(e, event), loading: false),
            );
          });
        } else {
          final data = localStorage.registrationData;
          emit(
            state.copyWith(
              registrationData: data,
              result: Result.successful('', event),
              loading: false,
            ),
          );
        }
        // _updateAnswersForEdit(emit);
      } catch (e) {
        rethrow;
      }
    }
  }
}
