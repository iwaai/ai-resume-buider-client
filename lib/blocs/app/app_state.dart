part of 'app_bloc.dart';

class AppState {
  final UserModel user;
  final Result result;
  final bool loading;
  final List<ChatBotModel> botChat;
  final String appStoreURL;
  final String playStoreURL;
  final String webURL;

  const AppState(
      {required this.user,
      required this.result,
      required this.botChat,
      required this.appStoreURL,
      required this.playStoreURL,
      required this.webURL,
      this.loading = false});

  AppState copyWith({
    UserModel? user,
    Result? result,
    List<ChatBotModel>? botChat,
    bool? loading,
    String? appStoreURL,
    String? playStoreURL,
    String? webURL,
  }) {
    return AppState(
        user: user ?? this.user,
        result: result ?? this.result,
        botChat: botChat ?? this.botChat,
        appStoreURL: appStoreURL ?? this.appStoreURL,
        playStoreURL: playStoreURL ?? this.playStoreURL,
        webURL: webURL ?? this.webURL,
        loading: loading ?? this.loading);
  }

  factory AppState.idle() {
    return AppState(
        loading: false,
        user: UserModel.initial(),
        result: Result.idle(),
        botChat: const [],
        appStoreURL: '',
        playStoreURL: '',
        webURL: '');
  }
}
