import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/success_stores_repo.dart';
import 'package:second_shot/models/api_response.dart';
import 'package:second_shot/models/stories_model.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'success_stories_event.dart';
part 'success_stories_state.dart';

class SuccessStoriesBloc
    extends Bloc<SuccessStoriesEvent, SuccessStoriesState> {
  int exploreProfilePage = 1;
  int exploreTotalPage = 1;
  int matchProfilePage = 1;
  int matchProfileTotlePage = 1;
  final storiesRepo = StoriesRepo();
  SuccessStoriesBloc() : super(SuccessStoriesState(result: Result.idle())) {
    on<ExploreProfileData>((event, emit) => _getexploreProfile(event, emit));
    on<MatchProfileData>((event, emit) => _getMatchProfile(event, emit));
    on<SearchStoryEvent>((event, emit) => _searchExploreProfile(event, emit));
    on<LocalSearchStoryEvent>(
        (event, emit) => _searchMatchProfile(event, emit));
    on<SetSearchType>((event, emit) => _setSearchType(event, emit));
  }

  void _setSearchType(SetSearchType event, Emitter emit) {
    emit(state.copyWith(
        isMatchProfileTab: event.index == 0,
        filterExploreProfile: [],
        filterMatchProfileList: []));
  }

  void _getexploreProfile(ExploreProfileData event, Emitter emit) async {
    if (event.onRefresh) {
      exploreProfilePage = 1;
      exploreTotalPage = 1;
    }

    // Prevent API call if no more pages exist
    if (exploreProfilePage > exploreTotalPage) {
      emit(state.copyWith(fetchingMore: false, loading: false));
      return;
    }

    emit(state.copyWith(
        result: Result.idle(),
        fetchingMore: exploreProfilePage > 1,
        loading: true,
        exploreProfileList: event.onRefresh == true ? [] : null));

    await storiesRepo.getExploreProfile(
        page: exploreProfilePage,
        onSuccess: (ApiResponse data) {
          List<StoryModel> successList = (data.data as List)
              .map((item) => StoryModel.fromJson(item))
              .toList();

          // Ensure we update only if there are more pages
          if (data.pagination != null) {
            exploreTotalPage = data.pagination!.totalPages;
            exploreProfilePage = data.pagination!.currentPage + 1;
          }

          print('Fetched ${successList.length} profiles');
          print(
              'Current Page: $exploreProfilePage / Total Pages: $exploreTotalPage');

          emit(
            state.copyWith(
                fetchingMore: false,
                result: Result.successful('', event),
                loading: false,
                exploreProfileList: [
                  ...state.exploreProfileList,
                  ...successList
                ]),
          );
        },
        onFailure: (String e) {
          emit(
            state.copyWith(
                result: Result.error(e, event),
                loading: false,
                fetchingMore: false),
          );
        });
  }

  void _getMatchProfile(MatchProfileData event, Emitter emit) async {
    // if (matchProfilePage == matchProfileTotlePage && matchProfilePage != 1) {
    //   return;
    // }
    emit(state.copyWith(
      result: Result.idle(),
      loading: true,
      matchProfileList: event.onRefresh == true ? [] : null,
    ));

    await storiesRepo.getMatchProfile(
        page: matchProfilePage,
        onSuccess: (ApiResponse data) {
          print("match ============> $data");
          List<StoryModel> successList = (data.data as List)
              .map((item) => StoryModel.fromJson(item))
              .toList();

          emit(
            state.copyWith(
                result: Result.successful('', event),
                loading: false,
                matchProfileList: successList
                //  [...state.matchProfileList, ...successList],
                ),
          );
        },
        onFailure: (String e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _searchExploreProfile(SearchStoryEvent event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));

    await storiesRepo.searchStory(
        onSuccess: (response) {
          print("respons is $response");
          List<StoryModel> list = (response.data as List)
              .map((item) => StoryModel.fromJson(item))
              .toList();

          emit(state.copyWith(loading: false, filterExploreProfile: list));
        },
        onFailure: (error) {
          emit(state.copyWith(
              result: Result.error(error, event), loading: false));
        },
        search: event.search);
  }

  void _searchMatchProfile(LocalSearchStoryEvent event, Emitter emit) async {
    emit(state.copyWith(query: event.search.trim().toLowerCase()));

    if (event.search.isEmpty) {
      // Clear the list when search is empty
      emit(state.copyWith(filterMatchProfileList: []));
    } else {
      // Filter from the original exploreProfileList
      final filterList = state.matchProfileList.where((profile) {
        return profile.name!.toLowerCase().contains(
              event.search.toLowerCase(),
            );
      }).toList();

      print("Match List: $filterList");

      // Update filterExploreProfile
      emit(state.copyWith(filterMatchProfileList: filterList));
    }
  }
}
