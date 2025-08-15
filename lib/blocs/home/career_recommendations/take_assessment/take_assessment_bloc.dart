import 'package:bloc/bloc.dart';
import 'package:second_shot/blocs/home/career_recommendations/career_recommendations_bloc.dart';
import 'package:second_shot/data/repos/career_recomm_repo.dart';
import 'package:second_shot/models/career_recomm_models.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'take_assessment_event.dart';
part 'take_assessment_state.dart';

class TakeAssessmentBloc
    extends Bloc<TakeAssessmentEvent, TakeAssessmentState> {
  final _careerRepo = CareerRecommRepo();
  final CareerRecommendationsBloc careerRecommendationsBloc;
  TakeAssessmentBloc(this.careerRecommendationsBloc)
      : super(TakeAssessmentState.idle()) {
    on<NextStep>((event, emit) => _onNextStep(event, emit));

    on<PreviousStep>((event, emit) => _onPreviousStep(event, emit));

    on<Reset>((event, emit) => _onReset(event, emit));

    on<SetAnswer>((event, emit) => _onSetAnswer(event, emit));

    on<Save>((event, emit) => _onSave(event, emit));

    on<GetCareerRecommendationQuestions>(
        (event, emit) => _onGetCareerRecommendationQuestions(event, emit));
  }

  void _onNextStep(NextStep event, Emitter<TakeAssessmentState> emit) {
    if (state.step < state.careerRecommendationQuestions.length) {
      emit(state.copyWith(step: state.step + 1));
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<TakeAssessmentState> emit) {
    if (state.step > 1) {
      emit(state.copyWith(step: state.step - 1));
    }
  }

  void _onReset(Reset event, Emitter<TakeAssessmentState> emit) {
    print(state.answers);

    emit(
      state.copyWith(
        step: 1,
        answers: {},
        result: Result.idle(),
      ),
    );
  }

  void _onSetAnswer(SetAnswer event, Emitter<TakeAssessmentState> emit) {
    final updatedAnswers = Map<String, dynamic>.from(state.answers);
    updatedAnswers[event.question] = event.value;
    emit(state.copyWith(answers: updatedAnswers));
    print(state.answers);
  }

  List<Map<String, dynamic>> _convertMapToList(Map<String, dynamic> data) {
    return data.entries.map((entry) {
      return {
        "questionId": entry.key,
        "answer": entry.value.toString(),
      };
    }).toList();
  }

  void _onSave(Save event, Emitter<TakeAssessmentState> emit) async {
    try {
      emit(state.copyWith(result: Result.idle(), loading: true));
      // Save logic goes here
      final answers = _convertMapToList(state.answers);
      await _careerRepo.submitAssessment(
          answers: answers,
          onSuccess: (String id) {
            careerRecommendationsBloc.add(GetCareerRecommendationByID(
                careerRecommendationId: id, fromLibrary: false));
            emit(state.copyWith(
              result: Result(ResultStatus.successful, '', event),
              loading: false,
            ));
          },
          onFailure: (String message) {
            emit(state.copyWith(
              result: Result(ResultStatus.error, message, event),
              loading: false,
            ));
          });
    } catch (e) {
      emit(state.copyWith(
          result: Result(ResultStatus.error, e.toString(), event)));
    }
  }

  void _onGetCareerRecommendationQuestions(
      GetCareerRecommendationQuestions event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await _careerRepo.getQuestions(
        onSuccess: (List<CareerRecommQuestion> data) {
      emit(state.copyWith(
        loading: false,
        careerRecommendationQuestions: data,
        result: Result.successful('', event),
      ));
    }, onFailure: (String message) {
      emit(state.copyWith(
        loading: false,
        result: Result.error(message, event),
      ));
    });
  }
}
