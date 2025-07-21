import 'dart:developer';

import 'package:bloc/bloc.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:second_shot/models/user_model.dart';
import 'package:second_shot/utils/constants/constant.dart';
import 'package:second_shot/utils/constants/result.dart';

import '../../data/repos/chat_bot_repo.dart';
import '../../models/chat_bot_model.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final chatBotRepo = ChatBotRepo();
  // final remoteConfig = FirebaseRemoteConfig.instance;

  AppBloc() : super(AppState.idle()) {
    on<SetUser>(
      (event, emit) => _setUser(event, emit),
    );
    on<ChatBotEvent>(_chatBotEvent);
    on<OnInitEvent>(_onInitEvent);
  }

  void _setUser(SetUser event, Emitter emit) {
    emit(
      state.copyWith(user: event.user),
    );
    log('Emit ${state.user.toJson()}');
  }

  Future<void> _chatBotEvent(ChatBotEvent event, Emitter emit) async {
    List<ChatBotModel> newList = List.from(state.botChat);
    newList.add(ChatBotModel(
        message: event.message,
        isMe: true,
        timeStamp: formatChatTime(DateTime.now())));
    newList.add(ChatBotModel(message: 'Loading', isMe: false, timeStamp: ''));
    emit(state.copyWith(loading: true, botChat: newList));
    await chatBotRepo.chatBotMessage(
        onSuccess: (String response) {
          if (newList.isNotEmpty && !newList.last.isMe) {
            newList.removeLast();
          }
          newList.add(ChatBotModel(
              message: response,
              isMe: false,
              timeStamp: formatChatTime(DateTime.now())));

          emit(state.copyWith(
              loading: false,
              result: Result.successful('message', event),
              botChat: newList));
        },
        onFailure: (String message) {
          if (newList.isNotEmpty && !newList.last.isMe) {
            newList.removeLast();
          }
          emit(state.copyWith(
              loading: false, result: Result.error(message, event)));
        },
        message: event.message);
  }

  Future<void> _onInitEvent(OnInitEvent event, Emitter emit) async {
    // Commented out Firebase Remote Config
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(minutes: 1),
    //   minimumFetchInterval: const Duration(days: 1),
    // ));
    // await remoteConfig.fetchAndActivate();
    // final appstore = remoteConfig.getString('appstore_url');
    // final playstore = remoteConfig.getString('playstore_url');
    // final web = remoteConfig.getString('web_url');
    
    // Fallback values without Firebase
    final appstore = 'https://apps.apple.com/app/secondshot';
    final playstore = 'https://play.google.com/store/apps/details?id=com.secondshot.app';
    final web = 'https://secondshot.com';
    
    emit(state.copyWith(
      appStoreURL: appstore,
      playStoreURL: playstore,
      webURL: web,
    ));
  }
}
