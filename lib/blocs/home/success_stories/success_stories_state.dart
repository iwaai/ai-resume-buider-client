part of 'success_stories_bloc.dart';

class SuccessStoriesState {
  final Result result;
  final bool loading;
  final bool fetchingMore;
  final String name;
  final String profession;
  final String profileImage;
  final List<StoryModel> exploreProfileList;
  final List<StoryModel> matchProfileList;
  List<StoryModel> filterMatchProfileList;
  List<StoryModel> filterExploreProfile;
  final String query;

  bool isMatchProfileTab;

  SuccessStoriesState(
      {required this.result,
      this.loading = false,
      this.fetchingMore = false,
      this.name = '',
      this.profession = '',
      this.profileImage = '',
      this.isMatchProfileTab = true,
      this.exploreProfileList = const [],
      this.matchProfileList = const [],
      this.query = '',
      this.filterExploreProfile = const [],
      this.filterMatchProfileList = const []});

  SuccessStoriesState copyWith({
    Result? result,
    bool? loading,
    bool? fetchingMore,
    String? name,
    String? profileImage,
    String? profession,
    List<StoryModel>? exploreProfileList,
    List<StoryModel>? matchProfileList,
    final List<StoryModel>? filterMatchProfileList,
    final bool? isMatchProfileTab,
    final List<StoryModel>? filterExploreProfile,
    final String? query,
  }) {
    return SuccessStoriesState(
        result: result ?? Result.idle(),
        loading: loading ?? this.loading,
        fetchingMore: fetchingMore ?? this.fetchingMore,
        name: name ?? this.name,
        profession: profession ?? this.profileImage,
        profileImage: profileImage ?? this.profileImage,
        exploreProfileList: exploreProfileList ?? this.exploreProfileList,
        matchProfileList: matchProfileList ?? this.matchProfileList,
        filterMatchProfileList:
            filterMatchProfileList ?? this.filterMatchProfileList,
        isMatchProfileTab: isMatchProfileTab ?? this.isMatchProfileTab,
        filterExploreProfile: filterExploreProfile ?? this.filterExploreProfile,
        query: query ?? this.query);
  }
}
