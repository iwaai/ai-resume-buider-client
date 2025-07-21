part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class OnShowDialog extends HomeEvent {}

class OnInitHome extends HomeEvent {}

class Unlock extends HomeEvent {
  final String screen;

  Unlock({required this.screen});
}
