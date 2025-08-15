import 'dart:convert';

import 'package:second_shot/models/registration_data_model.dart';
import 'package:second_shot/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/router/route_constants.dart';

class LocalStorage {
  LocalStorage._privateConstructor();

  static final LocalStorage _instance = LocalStorage._privateConstructor();

  factory LocalStorage() {
    return _instance;
  }

  late SharedPreferences _prefs;

  final String _accessToken = 'access-token';
  final String _userKey = 'user-data';
  final String _registrationQuestions = 'registration-questions';
  final String _registrationData = 'registration-data';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setRegistrationQuestions(Map<String, dynamic> data) async {
    print('setting registration questions in storage');
    await _prefs.setString(_registrationQuestions, jsonEncode(data));
  }

  Future<void> setRegistrationData(RegistrationDataModel data) async {
    print('setting registration data in storage');
    await _prefs.setString(_registrationData, jsonEncode(data.toJson()));
  }

  Future<void> setAccessToken(String token) async {
    await _prefs.setString(_accessToken, token);
  }

  Future<void> setUser(UserModel user) async {
    await _prefs.setString(_userKey, _userToString(user));
  }

  String? get token => _prefs.getString(_accessToken);

  UserModel? get user => _stringToUser(_prefs.getString(_userKey) ?? "");

  Map<String, dynamic>? get registrationQuestions =>
      (jsonDecode(_prefs.getString(_registrationQuestions) ?? ''));

  RegistrationDataModel? get registrationData =>
      (RegistrationDataModel.fromJson(
          jsonDecode(_prefs.getString(_registrationData) ?? '')));

  bool get isLoggedIn =>
      _prefs.containsKey(_userKey) && _prefs.containsKey(_accessToken);

  bool get isUserOTPVerified =>
      !_prefs.containsKey(_userKey) && _prefs.containsKey(_accessToken);

  bool get containsRegistrationQuestions =>
      _prefs.containsKey(_registrationQuestions);

  bool get containsRegistrationData => _prefs.containsKey(_registrationData);

  void removeData() {
    _prefs.remove(_userKey);
    _prefs.remove(_accessToken);
    _prefs.remove(_registrationData);
    print('Removed data');
  }

  Future<void> removeRegistration() async {
    await _prefs.remove(_registrationData);
    print('Removed data');
  }

  String _userToString(UserModel user) {
    return jsonEncode(user.toJson());
  }

  UserModel? _stringToUser(String data) {
    try {
      return UserModel.fromJson(jsonDecode(data));
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  isDialogShown(String screen) {
    return _prefs.containsKey(screen);
  }

  setDialogState(String screen) {
    _prefs.setBool(screen, true);
  }

  void clearDialogs() {
    _prefs
      ..remove(AppRoutes.homeScreen)
      ..remove(AppRoutes.transferableSkills)
      ..remove(AppRoutes.careerRecommendations)
      ..remove(AppRoutes.resumeBuilder)
      ..remove(AppRoutes.goalSettings)
      ..remove(AppRoutes.myLibrary)
      ..remove(AppRoutes.successStories);
  }
}
