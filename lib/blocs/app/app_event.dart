part of 'app_bloc.dart';

sealed class AppEvent {}

class SetUser extends AppEvent {
  final UserModel user;
  SetUser({required this.user});
}

class ChatBotEvent extends AppEvent {
  final String message;

  ChatBotEvent({required this.message});
}

class OnInitEvent extends AppEvent {}
