import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/career_recomm_repo.dart';
import 'package:second_shot/models/career_recomm_models.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'career_recommendations_event.dart';

part 'career_recommendations_state.dart';

class CareerRecommendationsBloc
    extends Bloc<CareerRecommendationsEvent, CareerRecommendationsState> {
  final _careerRepo = CareerRecommRepo();

  CareerRecommendationsBloc() : super(CareerRecommendationsState.idle()) {
    on<GetCareerRecommendations>(
        (event, emit) => _onGetCareerRecommendations(event, emit));
    on<GetFavCareerRecommendations>(
        (event, emit) => _onGetFavoriteCareers(event, emit));
    on<MarkRecommendationFavorite>(
        (event, emit) => _onMarkRecommendationFavorite(event, emit));
    on<MarkACareerFavorite>(
        (event, emit) => _onMarkCareerFavorite(event, emit));
    on<GetCareerRecommendationByID>(
        (event, emit) => _onGetCareerRecommendationByID(event, emit));
    on<OnSelectACareerInViewDetails>(
        (event, emit) => _onSelectACareerInViewDetails(event, emit));
    on<SearchCareerRecommendations>(
        (event, emit) => _onSearchCareerRecommendations(event, emit));
    on<VerifyPassword>((event, emit) => _verifyPassword(event, emit));
  }

  Future<void> _verifyPassword(VerifyPassword event, Emitter emit) async {
    emit(state.copyWith(
      buttonLoading: true,
      isVerified: false,
      result: Result.idle(),
    ));
    await _careerRepo.verifyPassword(
        onSuccess: (bool isVerified) {
          emit(state.copyWith(
              isVerified: isVerified,
              buttonLoading: false,
              result: Result.successful('', event)));
        },
        onFailure: (String message, bool isVerified) {
          emit(state.copyWith(
              isVerified: false,
              buttonLoading: false,
              result: Result.error(message, event)));
        },
        password: event.password);
  }

  void _onSearchCareerRecommendations(
      SearchCareerRecommendations event, Emitter emit) async {
    final query = event.query.trim().toLowerCase();
    emit(state.copyWith(query: query));

    if (query.isEmpty) {
      emit(state.copyWith(searched: []));
    } else {
      final data = event.fromLibrary
          ? state.favCareerRecommendations
          : state.careerRecommendations;
      final searched = data
          .where((cR) => cR.careers.any((careerPoint) => careerPoint.career.name
              .toLowerCase()
              .contains(query.toLowerCase())))
          .toList();
      print(searched);
      emit(state.copyWith(searched: searched));
    }
  }

  void _onGetCareerRecommendations(
      GetCareerRecommendations event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await _careerRepo.getCareerRecommendations(
        onSuccess: (List<CareerRecommendation> data) {
      emit(state.copyWith(
        loading: false,
        careerRecommendations: data.reversed.toList(),
        result: Result.successful('', event),
      ));
    }, onFailure: (String message) {
      emit(
          state.copyWith(loading: false, result: Result.error(message, event)));
    });
  }

  void _onGetCareerRecommendationByID(
      GetCareerRecommendationByID event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), detailsLoading: true));
    if (event.fromLibrary) {
      await _careerRepo.getFavCareerRecommendationByID(
          favID: event.careerRecommendationId,
          onSuccess: (CareerRecommendation data) {
            final career = data.careers.first;
            emit(state.copyWith(
              detailsLoading: false,
              selectedRecommendation: data,
              selectedCareer: career,
              result: Result.successful('', event),
            ));
          },
          onFailure: (String message) {
            emit(state.copyWith(
                detailsLoading: false, result: Result.error(message, event)));
          });
    } else {
      await _careerRepo.getCareerRecommendationByID(
          careerRecommendationId: event.careerRecommendationId,
          onSuccess: (CareerRecommendation data) {
            final career = data.careers.first;
            emit(state.copyWith(
              detailsLoading: false,
              selectedRecommendation: data,
              selectedCareer: career,
              result: Result.successful('', event),
            ));
          },
          onFailure: (String message) {
            emit(state.copyWith(
                detailsLoading: false, result: Result.error(message, event)));
          });
    }
  }

  void _onMarkRecommendationFavorite(
      MarkRecommendationFavorite event, Emitter emit) async {
    if (event.fromLibrary) {
      List<CareerRecommendation> data =
          List.from(state.favCareerRecommendations);
      List<CareerRecommendation> dataOld =
          List.from(state.favCareerRecommendations);
      if (event.fromSearch) {
        List<CareerRecommendation> sData = List.from(state.searched);
        sData.removeWhere(
            (e) => e.recommendationId == event.careerRecommendationId);

        data.removeWhere(
            (e) => e.recommendationId == event.careerRecommendationId);
        emit(state.copyWith(
            result: Result.idle(),
            favCareerRecommendations: data,
            searched: sData));
      } else {
        data.removeWhere(
            (e) => e.recommendationId == event.careerRecommendationId);
        emit(state.copyWith(
            result: Result.idle(), favCareerRecommendations: data));
      }
      await _careerRepo.markRecommendationFavorite(
          careerRecommendationId: event.careerRecommendationId,
          careers: event.careers,
          onSuccess: (String msg) {
            // add(GetFavCareerRecommendations());
            emit(state.copyWith(
              loading: false,
              result: Result.successful(msg, event),
            ));
          },
          onFailure: (String message) {
            emit(state.copyWith(
                favCareerRecommendations: dataOld, // undo the change
                loading: false,
                result: Result.error(message, event)));
          });
    } else {
      List<CareerRecommendation> data = List.from(state.careerRecommendations);
      List<CareerRecommendation> dataOld =
          List.from(state.careerRecommendations);
      final index = data.indexWhere(
          (e) => e.recommendationId == event.careerRecommendationId);
      if (event.fromSearch) {
        List<CareerRecommendation> sData = List.from(state.searched);
        final sIndex = sData.indexWhere(
            (e) => e.recommendationId == event.careerRecommendationId);
        sData[sIndex] = sData[sIndex].copyWith(
          isFavorite: !sData[sIndex].isFavorite,
        );
        data[index] = data[index].copyWith(
          isFavorite: !data[index].isFavorite,
        );
        emit(state.copyWith(
            result: Result.idle(),
            careerRecommendations: data,
            searched: sData));
      } else {
        data[index] = data[index].copyWith(
          isFavorite: !data[index].isFavorite,
        );
        emit(
            state.copyWith(result: Result.idle(), careerRecommendations: data));
      }
      await _careerRepo.markRecommendationFavorite(
          careerRecommendationId: event.careerRecommendationId,
          careers: event.careers,
          onSuccess: (String msg) {
            add(GetFavCareerRecommendations());
            emit(state.copyWith(
              result: Result.successful(msg, event),
            ));
          },
          onFailure: (String message) {
            emit(state.copyWith(
                careerRecommendations: dataOld, // undo the change
                loading: false,
                result: Result.error(message, event)));
          });
    }
  }

  void _onMarkCareerFavorite(MarkACareerFavorite event, Emitter emit) async {
    emit(state.copyWith(detailsLoading: true));
    bool isLibrary = event.fromLibrary;

    List<CareerRecommendation> data = isLibrary
        ? List.from(state.favCareerRecommendations)
        : List.from(state.careerRecommendations);

    // ✅ Update search results if fromSearch is true
    List<CareerRecommendation> sData = [...state.searched];
    final sIndex = sData
        .indexWhere((e) => e.recommendationId == event.careerRecommendationId);

    if (sIndex != -1) {
      print('Found matching career in search at index $sIndex');
      final sCareers =
          List<CareerPoint>.from(state.selectedRecommendation.careers);
      print(
          'Scareersssss orig ${state.selectedRecommendation.careers.map((e) => {
                'fav': e.isFavorite,
                'name': e.career.name,
              })}');

      final sCareersIndex =
          sCareers.indexWhere((e) => e.career.id == event.careerId);

      if (sCareersIndex != -1) {
        if (isLibrary) {
          sCareers.removeAt(sCareersIndex);
        } else {
          state.selectedRecommendation.careers[sCareersIndex] =
              state.selectedRecommendation.careers[sCareersIndex].copyWith(
            isFavorite:
                !state.selectedRecommendation.careers[sCareersIndex].isFavorite,
          );
          sCareers[sCareersIndex] = sCareers[sCareersIndex]
              .copyWith(isFavorite: !sCareers[sCareersIndex].isFavorite);
          print('Scareersssss after ${sCareers.map((e) => e.isFavorite)}');
        }
        if (sCareers.isNotEmpty) {
          sData[sIndex] = sData[sIndex].copyWith(
            isFavorite: sCareers.any((e) => e.isFavorite),
            careers: sCareers,
          );
        } else {
          sData.removeAt(sIndex);
        }
      }
    }

    List<CareerRecommendation> dataOld = List.from(data);

    final index = data
        .indexWhere((e) => e.recommendationId == event.careerRecommendationId);

    if (index == -1) return;

    final careers = List<CareerPoint>.from(data[index].careers);
    final careersIndex =
        careers.indexWhere((e) => e.career.id == event.careerId);

    if (careersIndex == -1) return;

    if (isLibrary) {
      careers.removeAt(careersIndex);

      state.selectedRecommendation.careers.removeAt(careersIndex);
    } else {
      careers[careersIndex] = careers[careersIndex]
          .copyWith(isFavorite: !careers[careersIndex].isFavorite);
      state.selectedRecommendation.careers[careersIndex] =
          state.selectedRecommendation.careers[careersIndex].copyWith(
        isFavorite:
            !state.selectedRecommendation.careers[careersIndex].isFavorite,
      );
    }

    if (careers.isEmpty) {
      data.removeAt(index);
    } else {
      data[index] = data[index].copyWith(
        isFavorite: careers.any((e) => e.isFavorite),
        careers: careers,
      );
    }

    // ✅ Emit final state
    emit(state.copyWith(
      result: Result.idle(),
      // detailsLoading: true,
      favCareerRecommendations:
          isLibrary ? data : state.favCareerRecommendations,
      careerRecommendations: isLibrary ? state.careerRecommendations : data,
      searched: sData,
      selectedRecommendation: state.selectedRecommendation,
      selectedCareer: isLibrary
          ? (state.selectedRecommendation.careers.isEmpty
              ? CareerPoint.initial()
              : state.selectedRecommendation.careers.first)
          : state.selectedCareer
              .copyWith(isFavorite: !state.selectedCareer.isFavorite),
    ));

    // ✅ API Call
    await _careerRepo.markCareerFavorite(
      careerRecommendationId: event.careerRecommendationId,
      careerId: event.careerId,
      onSuccess: (String msg) {
        add(GetCareerRecommendationByID(
            careerRecommendationId: event.fromLibrary
                ? state.selectedRecommendation.favoriteID ?? ""
                : state.selectedRecommendation.recommendationId,
            fromLibrary: event.fromLibrary));
        emit(state.copyWith(
          detailsLoading: false,
          loading: false,
          result: Result.successful(msg, event),
        ));
      },
      onFailure: (String message) {
        emit(state.copyWith(
          detailsLoading: false,
          favCareerRecommendations:
              isLibrary ? dataOld : state.favCareerRecommendations,
          careerRecommendations:
              isLibrary ? state.careerRecommendations : dataOld,
          loading: false,
          result: Result.error(message, event),
        ));
      },
    );

    isLibrary
        ? add(GetFavCareerRecommendations())
        : add(GetCareerRecommendations());
  }

  void _onGetFavoriteCareers(
      GetFavCareerRecommendations event, Emitter emit) async {
    emit(state.copyWith(
      result: Result.idle(),
      loading: true,
    ));
    await _careerRepo.getCareerLikes(onSuccess: (List<FavoriteCareer> models) {
      final data = models.map((e) => e.toCareerRecommendation()).toList();
      emit(state.copyWith(
        result: Result.successful('', event),
        favCareerRecommendations: data,
        loading: false,
      ));
    }, onFailure: (String message) {
      emit(state.copyWith(
        loading: false,
        result: Result.error(message, event),
      ));
    });
  }

  void _onSelectACareerInViewDetails(
      OnSelectACareerInViewDetails event, Emitter emit) {
    emit(state.copyWith(selectedCareer: event.career));
  }
}
