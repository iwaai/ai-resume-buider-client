part of 'home_bloc.dart';

final class HomeState {
  final Result? result;
  final bool loading;
  List<String> dialogShown;

  HomeState({
    this.dialogShown = const [],
    this.result,
    this.loading = false,
  });

  HomeState copyWith(
      {List<String>? dialogShown,
      List<String>? botChat,
      bool? loading,
      Result? result}) {
    return HomeState(
      dialogShown: dialogShown ?? this.dialogShown,
      result: result ?? this.result,
      loading: loading ?? this.loading,
    );
  }
}
