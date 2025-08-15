part of 'auth_bloc.dart';

sealed class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}

class GetUserProfile extends AuthEvent {}

class UpdateUser extends AuthEvent {
  final String address;
  final String name;
  UpdateUser({required this.address, required this.name});
}

class SignUp extends AuthEvent {
  final String fullName;
  final String emailAddress;
  final String phoneNumber;
  final String password;
  final String confirmPass;
  String? idToken;

  SignUp(
      {required this.fullName,
      required this.emailAddress,
      required this.phoneNumber,
      required this.password,
      required this.confirmPass,
      this.idToken});
}

class VerifyOtp extends AuthEvent {
  final String email;
  final String otp;
  String type;

  VerifyOtp({required this.email, required this.otp, this.type = ''});
}

class ResendOtp extends AuthEvent {
  final String email;

  ResendOtp({required this.email});
}

class PickImage extends AuthEvent {
  final bool fromCamera;

  PickImage({required this.fromCamera});
}

// Load states from JSON
class LoadStates extends AuthEvent {}

class SelectState extends AuthEvent {
  String? selectedState;
  SelectState(this.selectedState);
}

// When user selects a city
class SelectCity extends AuthEvent {
  String? selectedCity;
  SelectCity(this.selectedCity);
}

class UploadProfile extends AuthEvent {
  // final String fullName;
  final String address;

  UploadProfile({
    // required this.fullName,
    required this.address,
  });
}

class ForgotPassword extends AuthEvent {
  final String email;

  ForgotPassword({required this.email});
}

class ResetPassword extends AuthEvent {
  final String password;
  final String confirmPAssword;

  ResetPassword({required this.password, required this.confirmPAssword});
}

class Logout extends AuthEvent {}

class UpdatePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPAssword;

  UpdatePassword(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPAssword});
}

class DeleteAccount extends AuthEvent {}

class RegisterWithGoogle extends AuthEvent {}

class RegisterWithApple extends AuthEvent {}

