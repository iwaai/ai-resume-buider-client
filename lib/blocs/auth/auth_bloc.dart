import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/blocs/home/notifications/notifications_bloc.dart';
import 'package:second_shot/data/repos/auth_repo.dart';
import 'package:second_shot/models/user_model.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepo = AuthRepo();
  final ImagePicker _imagePicker = ImagePicker();

  Map<String, dynamic> stateCityData = {};
  final AppBloc appBloc;
  final NotificationsBloc notificationsBloc;

  AuthBloc(this.appBloc, this.notificationsBloc) : super(AuthState.idle()) {
    on<Login>((event, emit) => _login(event, emit));
    on<GetUserProfile>((event, emit) => _getUserProfile(event, emit));
    on<SignUp>((event, emit) => _register(event, emit));
    on<VerifyOtp>((event, emit) => _verifyOtp(event, emit));
    on<ResendOtp>((event, emit) => resendOtp(event, emit));
    on<PickImage>((event, emit) => _pickImage(event, emit));
    on<LoadStates>((event, emit) => _onLoadStates(event, emit));
    on<SelectState>((event, emit) => _selectState(event, emit));
    on<SelectCity>((event, emit) => _selectCity(event, emit));
    on<UploadProfile>((event, emit) => _uploadProfile(event, emit));
    on<UpdateUser>((event, emit) => _updateProfile(event, emit));
    on<ForgotPassword>((event, emit) => _forgotPassword(event, emit));
    on<ResetPassword>((event, emit) => _resetPassword(event, emit));
    on<Logout>((event, emit) => _logout(event, emit));
    on<UpdatePassword>((event, emit) => _updatePassword(event, emit));
    on<DeleteAccount>((event, emit) => _deleteAccount(event, emit));
    on<RegisterWithGoogle>((event, emit) => registerWithGoogle(event, emit));
    on<RegisterWithApple>((event, emit) => registerWithApple(event, emit));
  }

  void _login(Login event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.login(
        email: event.email,
        password: event.password,
        onSuccess: () {
          emit(
            state.copyWith(
                result: Result.successful('', event), loading: false),
          );
        },
        onFailure: (String e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _getUserProfile(GetUserProfile event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));

    await authRepo.getUser(onSuccess: (UserModel user) {
      appBloc.add(SetUser(user: user));
      emit(
        state.copyWith(result: Result.successful('', event), loading: false),
      );
    }, onFailure: (String e) {
      emit(
        state.copyWith(result: Result.error(e, event), loading: false),
      );
    });
  }

  void _register(SignUp event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.registerUser(
        fullName: event.fullName,
        email: event.emailAddress,
        password: event.password,
        confirmpassword: event.confirmPass,
        phoneNumber: event.phoneNumber,
        onSuccess: () {
          emit(
            state.copyWith(
              result: Result.successful('', event),
              loading: false,
              email: event.emailAddress,
              phNumber: event.phoneNumber,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _verifyOtp(VerifyOtp event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.otpVerify(
        email: event.email,
        otp: event.otp,
        type: event.type,
        onSuccess: () {
          emit(
            state.copyWith(
              result: Result.successful('', event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void resendOtp(ResendOtp event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.resendOtp(
        email: event.email,
        onSuccess: (res) {
          emit(
            state.copyWith(
              result: Result.successful(res, event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  Future<void> _pickImage(PickImage event, Emitter emit) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
          source: event.fromCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 30);

      if (pickedFile != null) {
        emit(state.copyWith(image: pickedFile));
      } else {
        emit(state.copyWith(result: Result.error("No Image Picked", event)));
      }
    } catch (e) {
      emit(state.copyWith(
          result: Result.error("Error picking image: $e", event)));
    }
  }

  void _uploadProfile(UploadProfile event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.uploadProfile(
        state: state.selectedState,
        city: state.selectedCity,
        address: event.address,
        profileImg: state.image,
        onSuccess: () {
          emit(AuthState.idle().copyWith(
            result: Result.successful('', event),
            loading: false,
          ));
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _updateProfile(UpdateUser event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.updateUser(
        state: state.selectedState,
        city: state.selectedCity,
        address: event.address,
        profileImg: state.image,
        onSuccess: (UserModel user) {
          emit(AuthState.idle().copyWith(
            result: Result.successful('Updated Successfully', event),
            loading: false,
          ));
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        },
        name: event.name);
  }

  void _onLoadStates(LoadStates event, Emitter emit) async {
    try {
      emit(state.copyWith(loading: true, result: Result.idle()));

      final String jsonString = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> rawData = json.decode(jsonString);

      // 🔥 Ensure that all city lists are List<String>
      stateCityData = rawData.map((key, value) {
        return MapEntry(key, List<String>.from(value as List));
      });

      emit(
          state.copyWith(loading: false, result: Result.successful('', event)));
    } catch (e) {
      emit(state.copyWith(
          result: Result.error('Error loading States: $e', event),
          loading: false));
    }
  }

  void _selectState(SelectState event, Emitter emit) {
    emit(state);
    print("Selected State: ${event.selectedState}");
    List<String> cities = stateCityData[event.selectedState] as List<String>;

    var updateState = state.copyWith(
        selectedState: event.selectedState,
        cities: cities,
        selectedCity: "" // Reset city
        );

    emit(updateState);

    print("Updated Cities: $cities");
    print("Selected City Reset to: ${state.selectedCity}");
  }

  void _selectCity(SelectCity event, Emitter emit) {
    emit(state.copyWith(selectedCity: event.selectedCity));
  }

  void _forgotPassword(ForgotPassword event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.forgotPassword(
        email: event.email,
        onSuccess: (res) {
          emit(
            state.copyWith(
                result: Result.successful(res, event),
                loading: false,
                email: event.email),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _resetPassword(ResetPassword event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.resetPassword(
        email: state.email,
        password: event.password,
        conformPassword: event.confirmPAssword,
        onSuccess: (res) {
          emit(
            state.copyWith(
              result: Result.successful(res, event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _logout(Logout event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.logout(
        deviceId: notificationsBloc.deviceId.isEmpty
            ? null
            : notificationsBloc.deviceId,
        onSuccess: (res) {
          emit(
            AuthState.idle().copyWith(
              result: Result.successful(res, event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
    notificationsBloc.add(OnLogout());
    appBloc.add(SetUser(user: UserModel.initial()));
    LocalStorage().removeData();
  }

  void _updatePassword(UpdatePassword event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.updatePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        conformPassword: event.confirmPAssword,
        onSuccess: (res) {
          emit(
            state.copyWith(
              result: Result.successful(res, event),
              loading: false,
            ),
          );
        },
        onFailure: (e) {
          emit(
            state.copyWith(result: Result.error(e, event), loading: false),
          );
        });
  }

  void _deleteAccount(DeleteAccount event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.deleteAccount(onSuccess: (res) {
      emit(
        AuthState.idle().copyWith(
          result: Result.successful(res, event),
          loading: false,
        ),
      );
    }, onFailure: (e) {
      emit(
        state.copyWith(result: Result.error(e, event), loading: false),
      );
    });
  }

  void registerWithGoogle(RegisterWithGoogle event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.registerWithGoogle(onSuccess: () {
      // LocalStorage().removeData();
      emit(
        state.copyWith(
          result: Result.successful('', event),
          loading: false,
        ),
      );
    }, onFailure: (e) {
      emit(
        state.copyWith(result: Result.error(e, event), loading: false),
      );
    });
  }

  void registerWithApple(RegisterWithApple event, Emitter emit) async {
    emit(state.copyWith(result: Result.idle(), loading: true));
    await authRepo.registerWithApple(onSuccess: () {
      emit(
        state.copyWith(
          result: Result.successful('', event),
          loading: false,
        ),
      );
    }, onFailure: (e) {
      emit(
        state.copyWith(result: Result.error(e, event), loading: false),
      );
    });
  }
}
