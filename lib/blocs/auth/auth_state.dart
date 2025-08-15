part of 'auth_bloc.dart';

class AuthState {
  final Result result;
  final bool loading;
  final String email;
  final String fullName;
  final String phNumber;
  final String address;
  final XFile? image;
  final String selectedState;
  List<String> cities;
  final String selectedCity;

  AuthState(
      {required this.result,
      this.loading = false,
      this.email = '',
      this.fullName = '',
      this.image,
      this.phNumber = '',
      this.address = '',
      this.cities = const [],
      this.selectedCity = '',
      this.selectedState = ''});

  AuthState copyWith(
      {Result? result,
      bool? loading,
      String? email,
      String? fullName,
      String? address,
      XFile? image,
      String? phNumber,
      String? selectedState,
      List<String>? cities,
      String? selectedCity}) {
    return AuthState(
        result: result ?? Result.idle(),
        loading: loading ?? this.loading,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        phNumber: phNumber ?? this.phNumber,
        image: image ?? this.image,
        cities: cities ?? this.cities,
        address: address ?? this.address,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedState: selectedState ?? this.selectedState);
  }

  factory AuthState.idle() => AuthState(result: Result.idle(), loading: false);
}
