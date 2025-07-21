part of 'success_stories_bloc.dart';

abstract class SuccessStoriesEvent {
  SuccessStoriesEvent();
}

class ExploreProfileData extends SuccessStoriesEvent {
  final bool onRefresh;

  ExploreProfileData({this.onRefresh = false});
}

class MatchProfileData extends SuccessStoriesEvent {
  final bool onRefresh;

  MatchProfileData({this.onRefresh = false});
}

class SearchStoryEvent extends SuccessStoriesEvent {
  final String search;
  SearchStoryEvent({required this.search});
}

class LocalSearchStoryEvent extends SuccessStoriesEvent {
  final String search;
  LocalSearchStoryEvent({required this.search});
}

class SetSearchType extends SuccessStoriesEvent {
  final int index;

  SetSearchType({required this.index});
}
