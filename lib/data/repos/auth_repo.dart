import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/user_model.dart';
import 'package:second_shot/services/local_storage.dart';
import 'package:second_shot/utils/constants/app_url.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepo {
  final apiService = ApiService();
  final storageService = LocalStorage();

  Future<void> login({
    required String email,
    required String password,
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "email": email,
      "password": password,
    };
    try {
      final response =
          await apiService.post(AppUrl.login, body: body, authorize: false);
      if (response.success == true) {
        debugPrint("============> ${response.data}");
        storageService.setAccessToken(response.data['token']);
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> getUser({
    required Function(UserModel user) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getProfile, authorize: true);
      if (response.success == true) {
        final user = UserModel.fromJson(response.data);
        storageService.setUser(user);
        onSuccess(user);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmpassword,
    required String phoneNumber,
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      // CHECK FIREBASE USER
      final checkUserBody = {"email": email};
      final response1 = await apiService.post(AppUrl.checkFirebaseUser,
          body: checkUserBody, authorize: false);

      debugPrint("check user repsone ${response1.message}");
      
      // Commented out Firebase Auth registration
      // Step 1: Register the user in Firebase
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);

      // Get Firebase ID token
      // String? idToken = await userCredential.user?.getIdToken();
      // if (idToken == null) {
      //   onFailure("Failed to get Firebase ID token.");
      //   return;
      // }

      // Step 2: Register the user in your backend
      final body = {
        "name": fullName,
        "email": email,
        "phone": phoneNumber,
        "password": password,
        "confirm_password": confirmpassword,
        // "idToken": idToken, // Commented out Firebase token
      };

      final response =
          await apiService.post(AppUrl.signup, body: body, authorize: false);

      if (response.success == true) {
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } on Exception catch (e) {
      // Handle errors without Firebase Auth
      onFailure("Registration failed: $e");
    } catch (e) {
      onFailure("An unexpected error occurred: $e");
    }
  }

  Future<void> registerWithGoogle({
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      // Commented out Google Sign-in and Firebase Auth
      // Step 1: Sign in with Google
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) {
      //   onFailure("Google Sign-In was canceled.");
      //   return;
      // }

      // final GoogleSignInAuthentication googleAuth =
      //     await googleUser.authentication;
      // final AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithCredential(credential);

      // Get Firebase ID token
      // String? idToken = await userCredential.user?.getIdToken();
      // if (idToken == null) {
      //   onFailure("Failed to get Firebase ID token.");
      //   return;
      // }

      // Extract user information
      // String email = userCredential.user?.email ?? "";
      // String name = userCredential.user?.displayName ?? "";
      // debugPrint("Email is $email");
      // debugPrint("Name is $name");

      // Step 2: Send login request to backend
      // final body = {
      //   "email": email,
      //   "idToken": idToken, // Send Firebase token for verification
      //   "name": name
      // };

      // final response = await apiService.post(AppUrl.socialLogin,
      //     body: body, authorize: false);

      // if (response.success == true) {
      //   storageService.setAccessToken(response.data['token']);
      //   onSuccess();
      // } else {
      //   onFailure(response.message.toString());
      // }
      
      onFailure("Google Sign-in is currently disabled");
    } on Exception catch (e) {
      // Handle errors without Firebase Auth
      onFailure("Google Sign-in failed: $e");
    } catch (e) {
      onFailure("An unexpected error occurred: $e");
    }
  }

  Future<void> registerWithApple({
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      // Commented out Apple Sign-in and Firebase Auth
      // Step 1: Perform Apple Sign-In
      // final AuthorizationCredentialAppleID appleCredential =
      //     await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );

      // Create Firebase credentials from Apple ID token
      // final OAuthCredential credential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   accessToken: appleCredential.authorizationCode,
      // );

      // UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithCredential(credential);

      // Get Firebase ID token
      // String? idToken = await userCredential.user?.getIdToken();
      // if (idToken == null) {
      //   onFailure("Failed to get Firebase ID token.");
      //   return;
      // }

      // Extract user information
      // String email = userCredential.user?.email ?? "";
      // String name = userCredential.user?.displayName ?? "User";
      // if (name.isEmpty &&
      //     appleCredential.givenName != null &&
      //     appleCredential.familyName != null) {
      //   name = "${appleCredential.givenName} ${appleCredential.familyName}";
      // }

      // debugPrint("apple Email is $email");
      // debugPrint("apple Name is $name");

      // Step 2: Send login request to backend
      // final body = {
      //   "email": email,
      //   "idToken": idToken, // Send Firebase token for verification
      //   "name": name
      // };

      // final response = await apiService.post(AppUrl.socialLogin,
      //     body: body, authorize: false);

      // if (response.success == true) {
      //   storageService.setAccessToken(response.data['token']);
      //   onSuccess();
      // } else {
      //   onFailure(response.message.toString());
      // }
      
      onFailure("Apple Sign-in is currently disabled");
    } on Exception catch (e) {
      // Handle errors without Firebase Auth
      onFailure("Apple Sign-in failed: $e");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      onFailure("An unexpected error occurred. Please try again.");
    }
  }

  Future<void> otpVerify({
    required String email,
    required String otp,
    required String type,
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "email": email,
      "otp": otp,
      if (type.isNotEmpty) "type": type, // Add only if not empty
    };

    try {
      final response =
          await apiService.post(AppUrl.otpVerify, body: body, authorize: false);
      if (response.success == true) {
        if (type == 'signup') {
          storageService.setAccessToken(response.data['token']);
        }
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> resendOtp({
    required String email,
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "email": email,
    };
    try {
      final response =
          await apiService.post(AppUrl.resendOtp, body: body, authorize: false);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> uploadProfile({
    required String state,
    required String city,
    required String address,
    required XFile? profileImg,
    required Function() onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "state": state,
      "address": address,
      "city": city,
    };
    try {
      final response = await apiService.postMultipart(
        AppUrl.setProfile,
        body: body,
        files: {
          "profile_img": File(profileImg?.path ?? ''),
        },
        authorize: true,
      );
      if (response.success == true) {
        onSuccess();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> forgotPassword({
    required String email,
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "email": email,
    };
    try {
      final response = await apiService.post(AppUrl.forgetPassword,
          body: body, authorize: false);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String conformPassword,
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "email": email,
      "password": password,
      "confirm_password": conformPassword
    };
    try {
      final response = await apiService.post(AppUrl.resetPassword,
          body: body, authorize: false);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> logout({
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
    String? deviceId,
  }) async {
    try {
      final response = await apiService.post(AppUrl.logout,
          body: deviceId == null ? null : {'deviceId': deviceId},
          authorize: true);
      if (response.success == true) {
        // await GoogleSignIn().signOut(); // This line was commented out in the original file
        // await FirebaseAuth.instance.signOut(); // This line was commented out in the original file
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String conformPassword,
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "confirm_password": conformPassword
    };
    try {
      final response = await apiService.post(AppUrl.updatePassword,
          body: body, authorize: true);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> deleteAccount({
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.delete(AppUrl.deleteAccount, authorize: true);
      if (response.success == true) {
        // await GoogleSignIn().signOut(); // This line was commented out in the original file
        // await FirebaseAuth.instance.signOut(); // This line was commented out in the original file
        onSuccess(response.message.toString());
        storageService.removeData();
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updateUser({
    required String state,
    required String city,
    required String address,
    required String name,
    required XFile? profileImg,
    required Function(UserModel user) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "state": state,
      "address": address,
      "city": city,
      "name": name,
    };

    debugPrint("body $body");

    try {
      final response = await apiService.putMultipart(
        AppUrl.updateProfile,
        body: body,
        files: {
          if (profileImg != null) "profile_img": File(profileImg.path),
        },
        authorize: true,
      );
      if (response.success == true) {
        final user = UserModel.fromJson(response.data);
        storageService.setUser(user);
        onSuccess(user);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> updateFCM({
    required String fcm,
    required String deviceID,
    required Function(String messageSuccess) onSuccess,
    required Function(String message) onFailure,
  }) async {
    final body = {
      "deviceToken": fcm,
      "deviceId": deviceID,
    };
    try {
      final response = await apiService.post(AppUrl.setDeviceToken, body: body);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
