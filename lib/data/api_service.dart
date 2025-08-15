import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:second_shot/models/api_response.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/presentation/router/navigations.dart';
import 'package:second_shot/presentation/router/route_constants.dart';
import 'package:second_shot/services/local_storage.dart';

class ApiService {
  ///TODO: Add Base Url
  final String baseUrl = 'http://72.60.64.113';

  final LocalStorage storage = LocalStorage();

  // Helper to get headers with optional authorization
  Future<Map<String, String>> _getHeaders({bool authorize = false}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authorize) {
      String? token = storage.token;

      if (token != null) {
        print("Token in headers $token");
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // GET method
  Future<ApiResponse> get(String endpoint,
      {bool authorize = true, Map<String, dynamic>? queryParameters}) async {
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint')
          .replace(queryParameters: queryParameters);
      log('URL $uri');
      log('QueryParameters $queryParameters');
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Request timed out, Try again!');
        },
      );
      log('Response ${response.body}');
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } catch (e) {
      // Handle other exceptions
      return ApiResponse(success: false, message: '$e', data: null);
    }
  }

  // POST method
  Future<ApiResponse> post(String endpoint,
      {bool authorize = true, Map<String, dynamic>? body}) async {
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint');
      log('URL $uri');
      log('Body $body');
      final response = await http
          .post(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      )
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Request timed out, Try again!');
        },
      );
      if (response.statusCode == 200) {
        log('Success:::: ${response.body}');
      } else {
        log('Error Code: ${response.statusCode}');
        log('Error Message: ${response.body}');
      }
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } catch (e) {
      // Handle other exceptions
      return ApiResponse(success: false, message: '$e', data: null);
    }
  }

  // PUT method
  Future<ApiResponse> put(String endpoint,
      {bool authorize = true, required Map<String, dynamic> body}) async {
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint');
      log('URL $uri');
      log('Body $body');
      final response =
          await http.put(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        log('Success:::: ${response.body}');
      } else {
        log('Error Code: ${response.statusCode}');
        log('Error Message: ${response.body}');
      }
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } on Exception catch (e) {
      return ApiResponse(success: false, message: 'Error: $e', data: null);
    }
  }

  // DELETE method
  Future<ApiResponse> delete(String endpoint,
      {bool authorize = true,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? body}) async {
    print('Body: $body');
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.delete(uri,
          headers: headers, body: body != null ? jsonEncode(body) : null);
      print('Response: ${response.body}');
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } on Exception catch (e) {
      return ApiResponse(success: false, message: 'Error: $e', data: null);
    }
  }

  // Multipart POST method (e.g., for file uploads)
  Future<ApiResponse> postMultipart(
    String endpoint, {
    Map<String, dynamic>? body,
    required Map<String, File?> files,
    bool authorize = true,
  }) async {
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint');
      log('URL $uri');
      log('Body $body');
      log('Files $files');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add body fields
      body?.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add file(s)
      files.forEach((key, file) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(key, file.path));
        }
      });
      log('Request Files ${request.files}');
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Request timed out, Try again!');
        },
      );

      var response = await http.Response.fromStream(streamedResponse);
      log('Error Code ${response.statusCode}');
      log('Response ${response.body}');
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } on Exception catch (e) {
      return ApiResponse(success: false, message: 'Error: $e', data: null);
    }
  }

  // Multipart PUT method (e.g., for file uploads)
  Future<ApiResponse> putMultipart(
    String endpoint, {
    required Map<String, dynamic> body,
    required Map<String, File?> files,
    bool authorize = false,
  }) async {
    try {
      final headers = await _getHeaders(authorize: authorize);
      final uri = Uri.parse('$baseUrl$endpoint');
      log('URL $uri');
      log('Body $body');
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(headers);

      // Add body fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add file(s)
      files.forEach((key, file) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(key, file.path));
        }
      });
      print(request.files);
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Request timed out, Try again!');
        },
      );

      var response = await http.Response.fromStream(streamedResponse);
      log('Response ${response.body}');
      return _handleResponse(response);
    } on http.ClientException catch (e) {
      print('Here');
      SnackbarsType.error(
          GoRouters.routes.configuration.navigatorKey.currentContext!,
          'Please check your internet');
      return ApiResponse(
          success: false, message: 'Please check your internet', data: null);
    } on TimeoutException catch (e) {
      return ApiResponse(success: false, message: e.message, data: null);
    } on Exception catch (e) {
      return ApiResponse(success: false, message: 'Error: $e', data: null);
    }
  }

  // Unified response handler
  ApiResponse _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          if ((decoded as Map<String, dynamic>).containsKey('data')) {
            return ApiResponse(
                pagination: decoded['pagination'] == null
                    ? null
                    : Pagination.fromJson(decoded["pagination"]),
                success: true,
                message: decoded['message'],
                data: decoded['data']);
          } else {
            return ApiResponse(
                success: true, message: decoded['message'], data: decoded);
          }
        } else {
          throw decoded['message'];
        }
      case 201:
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          return ApiResponse(
              success: true,
              message: decoded['message'],
              data: decoded['data']);
        } else {
          throw decoded['message'];
        }
      case 400:
        final decoded = jsonDecode(response.body);
        return ApiResponse(
            success: decoded['success'],
            message: decoded['message'],
            data: decoded['data']);
      case 401:
        final decoded = jsonDecode(response.body);
        print('Response code is 401');
        LocalStorage().removeData();
        SnackbarsType.error(
            GoRouters.routes.configuration.navigatorKey.currentContext!,
            decoded['message']);
        GoRouters.routes.go(AppRoutes.login);
        throw decoded['message'];
      case 402:
        final decoded = jsonDecode(response.body);
        print('Response code is 402');
        // SnackbarsType.error(
        //     GoRouters.routes.configuration.navigatorKey.currentContext!,
        //     decoded['message']);
        // GoRouters.routes.configuration.navigatorKey.currentContext!.read<AuthBloc>().add(GetUserProfile());
        // Optional: you could navigate somewhere or log out
        throw decoded['message'];
      case 403:
        final decoded = jsonDecode(response.body);
        print('Response code is 403');
        // SnackbarsType.error(
        //     GoRouters.routes.configuration.navigatorKey.currentContext!,
        //     decoded['message']);
        // GoRouters.routes.configuration.navigatorKey.currentContext!.read<AuthBloc>().add(GetUserProfile());
        // Optional: you could navigate somewhere or log out
        throw decoded['message'];
      case 404:
        final decoded = jsonDecode(response.body);
        throw decoded['message'];
      case 500:
        throw 'Something went wrong';
      default:
        throw 'Something went wrong';
    }
  }
}
//   // ===== ROBUST MOCK API IMPLEMENTATION =====

//   // GET method
//   Future<ApiResponse> get(String endpoint,
//       {bool authorize = true, Map<String, dynamic>? queryParameters}) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       print('Mock GET: $endpoint');
//       print('Query Parameters: $queryParameters');
      
//       return _getMockResponse(endpoint, queryParameters: queryParameters);
//     } catch (e) {
//       print('Mock GET Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // POST method
//   Future<ApiResponse> post(String endpoint,
//       {bool authorize = true, Map<String, dynamic>? body}) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       print('Mock POST: $endpoint');
//       print('Body: $body');
      
//       return _getMockResponse(endpoint, body: body);
//     } catch (e) {
//       print('Mock POST Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // PUT method
//   Future<ApiResponse> put(String endpoint,
//       {bool authorize = true, required Map<String, dynamic> body}) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       print('Mock PUT: $endpoint');
//       print('Body: $body');
      
//       return _getMockResponse(endpoint, body: body);
//     } catch (e) {
//       print('Mock PUT Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // DELETE method
//   Future<ApiResponse> delete(String endpoint,
//       {bool authorize = true,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? body}) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       print('Mock DELETE: $endpoint');
//       print('Query Parameters: $queryParameters');
//       print('Body: $body');
      
//       return _getMockResponse(endpoint, queryParameters: queryParameters, body: body);
//     } catch (e) {
//       print('Mock DELETE Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // Multipart POST method
//   Future<ApiResponse> postMultipart(
//     String endpoint, {
//     Map<String, dynamic>? body,
//     required Map<String, File?> files,
//     bool authorize = true,
//   }) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 1000));
      
//       print('Mock POST Multipart: $endpoint');
//       print('Body: $body');
//       print('Files: ${files.keys.toList()}');
      
//       return _getMockResponse(endpoint, body: body);
//     } catch (e) {
//       print('Mock POST Multipart Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // Multipart PUT method
//   Future<ApiResponse> putMultipart(
//     String endpoint, {
//     Map<String, dynamic>? body,
//     required Map<String, File?> files,
//     bool authorize = true,
//   }) async {
//     try {
//       // Simulate network delay
//       await Future.delayed(const Duration(milliseconds: 1000));
      
//       print('Mock PUT Multipart: $endpoint');
//       print('Body: $body');
//       print('Files: ${files.keys.toList()}');
      
//       return _getMockResponse(endpoint, body: body);
//     } catch (e) {
//       print('Mock PUT Multipart Error: $e');
//       return ApiResponse(
//         success: false, 
//         message: 'Mock API Error: $e', 
//         data: null
//       );
//     }
//   }

//   // Centralized mock response handler
//   ApiResponse _getMockResponse(String endpoint, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? body,
//   }) {
//     // Handle endpoints with query parameters
//     String baseEndpoint = endpoint;
//     if (endpoint.contains('?')) {
//       baseEndpoint = endpoint.split('?')[0];
//     }
//     try {
//       switch (baseEndpoint) {
//         // Authentication endpoints
//         case '/api/auth/login':
//           return ApiResponse(
//             success: true,
//             message: 'Login successful',
//             data: {
//               'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
//               'user': _getCompleteUserData(body?['email'] ?? 'john@example.com')
//             }
//           );

//         case '/api/auth/sign-up':
//           return ApiResponse(
//             success: true,
//             message: 'Registration successful',
//             data: {
//               'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
//               'user': _getCompleteUserData(body?['email'] ?? 'user@example.com')
//             }
//           );

//         case '/api/auth/verify-otp':
//           return ApiResponse(
//             success: true,
//             message: 'OTP verified successfully',
//             data: {
//               'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
//               'user': _getCompleteUserData(body?['email'] ?? 'john@example.com')
//             }
//           );

//         case '/api/auth/forget-password':
//           return ApiResponse(
//             success: true,
//             message: 'Password reset email sent successfully',
//             data: null
//           );

//         case '/api/auth/reset-password':
//           return ApiResponse(
//             success: true,
//             message: 'Password reset successfully',
//             data: null
//           );

//         // User profile endpoints
//         case '/api/user/my-profile':
//           return ApiResponse(
//             success: true,
//             message: 'Profile retrieved successfully',
//             data: _getCompleteUserData('john@example.com')
//           );

//         case '/api/user/set-profile':
//         case '/api/user/update-profile':
//           return ApiResponse(
//             success: true,
//             message: 'Profile updated successfully',
//             data: _getCompleteUserData(body?['name'] ?? 'John Doe')
//           );

//         case '/api/user/change-password':
//           return ApiResponse(
//             success: true,
//             message: 'Password changed successfully',
//             data: null
//           );

//         case '/api/user/logout':
//           return ApiResponse(
//             success: true,
//             message: 'Logged out successfully',
//             data: null
//           );

//         case '/api/user/delete-account':
//           return ApiResponse(
//             success: true,
//             message: 'Account deleted successfully',
//             data: null
//           );

//         // Registration questions endpoints
//         case '/api/services/get-all-questions':
//           return ApiResponse(
//             success: true,
//             message: 'All questions retrieved successfully',
//             data: _getRegistrationQuestionsData()
//           );

//         case '/api/user/get-registration-questions':
//           return ApiResponse(
//             success: true,
//             message: 'Registration questions retrieved successfully',
//             data: {
//               'completed': true,
//               'questions': _getRegistrationQuestionsList()
//             }
//           );

//         case '/api/user/complete-registration-questions':
//           return ApiResponse(
//             success: true,
//             message: 'Registration questions completed successfully',
//             data: null
//           );

//         case '/api/user/get-registration-data':
//           return ApiResponse(
//             success: true,
//             message: 'Registration data retrieved successfully',
//             data: _getRegistrationData()
//           );

//         // Goals endpoints
//         case '/api/user/my-goals':
//           return ApiResponse(
//             success: true,
//             message: 'Goals retrieved successfully',
//             data: _getGoalsList()
//           );

//         case '/api/user/create-goal':
//           return ApiResponse(
//             success: true,
//             message: 'Goal created successfully',
//             data: _getGoalData(body)
//           );

//         case '/api/user/goal-details':
//           final goalId = queryParameters?['id'] ?? '1';
//           return ApiResponse(
//             success: true,
//             message: 'Goal details retrieved successfully',
//             data: _getGoalDetails(goalId)
//           );

//         case '/api/user/change-goal-status':
//           return ApiResponse(
//             success: true,
//             message: 'Goal status updated successfully',
//             data: null
//           );

//         case '/api/user/delete-goal':
//           return ApiResponse(
//             success: true,
//             message: 'Goal deleted successfully',
//             data: null
//           );

//         case '/api/user/add-support-people-goal':
//           return ApiResponse(
//             success: true,
//             message: 'Support people added successfully',
//             data: null
//           );

//         case '/api/user/update-sub-goal-status':
//           return ApiResponse(
//             success: true,
//             message: 'Sub-goal status updated successfully',
//             data: null
//           );

//         case '/api/user/search-success-story':
//           return ApiResponse(
//             success: true,
//             message: 'Search completed successfully',
//             data: _getGoalsList()
//           );

//         // Career recommendations endpoints
//         case '/api/user/get-questions':
//           return ApiResponse(
//             success: true,
//             message: 'Career questions retrieved successfully',
//             data: _getCareerQuestions()
//           );

//         case '/api/user/my-career-recommendations':
//           return ApiResponse(
//             success: true,
//             message: 'Career recommendations retrieved successfully',
//             data: _getCareerRecommendations()
//           );

//         case '/api/user/career-recommendation-details':
//           final careerId = queryParameters?['id'] ?? '1';
//           return ApiResponse(
//             success: true,
//             message: 'Career recommendation details retrieved successfully',
//             data: _getCareerRecommendationDetails(careerId)
//           );

//         case '/api/user/favorite-career-details':
//           final careerId = queryParameters?['id'] ?? '1';
//           return ApiResponse(
//             success: true,
//             message: 'Favorite career details retrieved successfully',
//             data: _getCareerRecommendationDetails(careerId)
//           );

//         case '/api/user/toggle-favorite-career':
//           return ApiResponse(
//             success: true,
//             message: 'Favorite status toggled successfully',
//             data: null
//           );

//         case '/api/user/toggle-favorite-single-career':
//           return ApiResponse(
//             success: true,
//             message: 'Favorite status toggled successfully',
//             data: null
//           );

//         case '/api/user/submit-assessment':
//           return ApiResponse(
//             success: true,
//             message: 'Assessment submitted successfully',
//             data: _getCareerRecommendations()
//           );

//         case '/api/user/my-favorite-careers':
//           return ApiResponse(
//             success: true,
//             message: 'Favorite careers retrieved successfully',
//             data: _getCareerRecommendations()
//           );

//         // Transferable skills endpoints
//         case '/api/user/my-transferable-skills':
//           return ApiResponse(
//             success: true,
//             message: 'Transferable skills retrieved successfully',
//             data: _getTransferableSkills()
//           );

//         case '/api/user/toggle-transferable-skill':
//           return ApiResponse(
//             success: true,
//             message: 'Transferable skill toggled successfully',
//             data: null
//           );

//         case '/api/user/send-skills':
//           return ApiResponse(
//             success: true,
//             message: 'Skills sent successfully',
//             data: null
//           );

//         case '/api/user/add-support-people-transferablleSkills':
//           return ApiResponse(
//             success: true,
//             message: 'Support people added successfully',
//             data: null
//           );

//         case '/api/user/get-user-transferable-skills':
//           return ApiResponse(
//             success: true,
//             message: 'User transferable skills retrieved successfully',
//             data: _getTransferableSkills()
//           );

//         // Resume builder endpoints
//         case '/api/user/get-my-resumes':
//           return ApiResponse(
//             success: true,
//             message: 'Resumes retrieved successfully',
//             data: _getResumesList()
//           );

//         case '/api/user/create-resume':
//           return ApiResponse(
//             success: true,
//             message: 'Resume created successfully',
//             data: _getResumeData(body)
//           );

//         case '/api/user/resume-detail':
//           final resumeId = queryParameters?['id'] ?? '1';
//           return ApiResponse(
//             success: true,
//             message: 'Resume details retrieved successfully',
//             data: _getResumeDetails(resumeId)
//           );

//         case '/api/user/update-resume':
//           return ApiResponse(
//             success: true,
//             message: 'Resume updated successfully',
//             data: _getResumeData(body)
//           );

//         case '/api/user/delete-resume':
//           return ApiResponse(
//             success: true,
//             message: 'Resume deleted successfully',
//             data: null
//           );

//         case '/api/user/send-to-email':
//           return ApiResponse(
//             success: true,
//             message: 'Resume sent to email successfully',
//             data: null
//           );

//         case '/api/user/add-support-people':
//           return ApiResponse(
//             success: true,
//             message: 'Support people added successfully',
//             data: null
//           );

//         // Success stories endpoints
//         case '/api/user/get-success-stories':
//           return ApiResponse(
//             success: true,
//             message: 'Success stories retrieved successfully',
//             data: _getSuccessStories()
//           );

//         case '/api/user/my-match-profiles':
//           return ApiResponse(
//             success: true,
//             message: 'Match profiles retrieved successfully',
//             data: _getSuccessStories()
//           );

//         case '/api/user/search-success-story':
//           return ApiResponse(
//             success: true,
//             message: 'Search completed successfully',
//             data: _getSuccessStories()
//           );

//         // Notifications endpoints
//         case '/api/user/store-device-token':
//           return ApiResponse(
//             success: true,
//             message: 'Device token stored successfully',
//             data: null
//           );

//         case '/api/user/my-notifications':
//           return ApiResponse(
//             success: true,
//             message: 'Notifications retrieved successfully',
//             data: _getNotificationsList()
//           );

//         case '/api/user/delete-notification':
//           return ApiResponse(
//             success: true,
//             message: 'Notification deleted successfully',
//             data: null
//           );

//         case '/api/user/mark-notifications-read':
//           return ApiResponse(
//             success: true,
//             message: 'Notifications marked as read successfully',
//             data: null
//           );

//         case '/api/user/my-notification-setting':
//           return ApiResponse(
//             success: true,
//             message: 'Notification settings retrieved successfully',
//             data: _getNotificationSettings()
//           );

//         case '/api/user/toggle-notification':
//           return ApiResponse(
//             success: true,
//             message: 'Notification setting toggled successfully',
//             data: null
//           );

//         // Chat bot endpoint
//         case '/api/user/chat-with-bot':
//           return ApiResponse(
//             success: true,
//             message: 'Chat response generated successfully',
//             data: _getChatResponse(body?['message'] ?? 'Hello')
//           );

//         // Subscription endpoints
//         case '/api/subscription/verify-subscription-android':
//         case '/api/subscription/verify-subscription-ios':
//           return ApiResponse(
//             success: true,
//             message: 'Subscription verified successfully',
//             data: _getSubscriptionData()
//           );

//         case '/api/subscription/my-subscription-plan':
//           return ApiResponse(
//             success: true,
//             message: 'Subscription plan retrieved successfully',
//             data: _getSubscriptionData()
//           );

//         // Awards endpoints
//         case '/api/user/idp-questions':
//           return ApiResponse(
//             success: true,
//             message: 'IDP questions retrieved successfully',
//             data: _getAwardQuestions()
//           );

//         case '/api/user/submit-idp-form':
//           return ApiResponse(
//             success: true,
//             message: 'IDP form submitted successfully',
//             data: _getAwardData()
//           );

//         case '/api/user/update-idp-form':
//           return ApiResponse(
//             success: true,
//             message: 'IDP form updated successfully',
//             data: _getAwardData()
//           );

//         case '/api/user/my-idp-award':
//           return ApiResponse(
//             success: true,
//             message: 'IDP awards retrieved successfully',
//             data: _getAwardsList()
//           );

//         case '/api/user/send-idp-form':
//           return ApiResponse(
//             success: true,
//             message: 'IDP form sent successfully',
//             data: null
//           );

//         case '/api/user/add-support-people-idp':
//           return ApiResponse(
//             success: true,
//             message: 'Support people added successfully',
//             data: null
//           );

//         // Default case for unknown endpoints
//         default:
//           print('Unknown endpoint: $endpoint');
//           return ApiResponse(
//             success: false,
//             message: 'Endpoint not found: $endpoint',
//             data: null
//           );
//       }
//     } catch (e) {
//       print('Error in mock response for $endpoint: $e');
//       return ApiResponse(
//         success: false,
//         message: 'Mock API Error: $e',
//         data: null
//       );
//     }
//   }

//   // Helper methods for generating mock data
//   Map<String, dynamic> _getCompleteUserData(String email) {
//     return {
//       '_id': '1',
//       'name': 'John Doe',
//       'email': email,
//       'phone': '+1234567890',
//       'profile_img': 'https://via.placeholder.com/150x150/007AFF/FFFFFF?text=JD',
//       'state': 'California',
//       'city': 'San Francisco',
//       'address': '123 Main St',
//       'is_profile_completed': true,
//       'is_subscription_paid': true,
//       'is_registration_question_completed': true,
//       'current_subscription_plan': 'premium'
//     };
//   }

//   Map<String, dynamic> _getRegistrationQuestionsData() {
//     return {
//       'services': [
//         {'_id': '1', 'service_name': 'Army'},
//         {'_id': '2', 'service_name': 'Navy'},
//         {'_id': '3', 'service_name': 'Air Force'},
//         {'_id': '4', 'service_name': 'Marines'},
//         {'_id': '5', 'service_name': 'Coast Guard'}
//       ],
//       'ranks': [
//         {'_id': '1', 'rank_name': 'Private'},
//         {'_id': '2', 'rank_name': 'Corporal'},
//         {'_id': '3', 'rank_name': 'Sergeant'},
//         {'_id': '4', 'rank_name': 'Lieutenant'},
//         {'_id': '5', 'rank_name': 'Captain'}
//       ],
//       'sports': [
//         {'_id': '1', 'sport_name': 'Football'},
//         {'_id': '2', 'sport_name': 'Basketball'},
//         {'_id': '3', 'sport_name': 'Baseball'},
//         {'_id': '4', 'sport_name': 'Soccer'},
//         {'_id': '5', 'sport_name': 'Tennis'}
//       ],
//       'sportPositions': [
//         {'_id': '1', 'position_name': 'Quarterback'},
//         {'_id': '2', 'position_name': 'Forward'},
//         {'_id': '3', 'position_name': 'Pitcher'},
//         {'_id': '4', 'position_name': 'Striker'},
//         {'_id': '5', 'position_name': 'Server'}
//       ],
//       'hobbies': [
//         {'_id': '1', 'hobbie_name': 'Reading'},
//         {'_id': '2', 'hobbie_name': 'Gaming'},
//         {'_id': '3', 'hobbie_name': 'Cooking'},
//         {'_id': '4', 'hobbie_name': 'Traveling'},
//         {'_id': '5', 'hobbie_name': 'Photography'}
//       ],
//       'subjects': [
//         {'_id': '1', 'subject_name': 'Mathematics'},
//         {'_id': '2', 'subject_name': 'Science'},
//         {'_id': '3', 'subject_name': 'English'},
//         {'_id': '4', 'subject_name': 'History'},
//         {'_id': '5', 'subject_name': 'Art'}
//       ]
//     };
//   }

//   List<Map<String, dynamic>> _getRegistrationQuestionsList() {
//     return [
//       {
//         'id': 1,
//         'question': 'What is your highest level of education?',
//         'type': 'dropdown',
//         'options': ['High School', 'Bachelor\'s', 'Master\'s', 'PhD']
//       }
//     ];
//   }

//   Map<String, dynamic> _getRegistrationData() {
//     return {
//       'current_grade_level': 'Bachelor\'s',
//       'major_trade_or_military': 'Computer Science',
//       'highest_degree_completion': 'Bachelor\'s',
//       'is_eighteen_or_older': true,
//       'has_military_service': false,
//       'is_athlete': true,
//       'primary_sport': 'Football',
//       'sport_position': 'Quarterback',
//       'favorite_hobby1': 'Reading',
//       'favorite_hobby2': 'Gaming',
//       'favorite_middle_school_subject': 'Mathematics',
//       'has_job_experience': true,
//       'recent_job_title': 'Software Developer',
//       'desired_career_path': 'Technology'
//     };
//   }

//   List<Map<String, dynamic>> _getGoalsList() {
//     final now = DateTime.now();
//     return [
//       {
//         'id': '1',
//         'title': 'Learn Flutter Development',
//         'description': 'Master Flutter framework for mobile app development',
//         'status': 'in_progress',
//         'created_at': now.toString(),
//         'updated_at': now.toString()
//       },
//       {
//         'id': '2',
//         'title': 'Get AWS Certification',
//         'description': 'Obtain AWS Solutions Architect certification',
//         'status': 'pending',
//         'created_at': now.toString(),
//         'updated_at': now.toString()
//       }
//     ];
//   }

//   Map<String, dynamic> _getGoalData(Map<String, dynamic>? body) {
//     return {
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'title': body?['title'] ?? 'New Goal',
//       'description': body?['description'] ?? 'Goal description',
//       'status': 'pending',
//       'created_at': DateTime.now().toIso8601String(),
//       'updated_at': DateTime.now().toIso8601String()
//     };
//   }

//   Map<String, dynamic> _getGoalDetails(String goalId) {
//     final now = DateTime.now();
//     return {
//       'id': goalId,
//       'title': 'Learn Flutter Development',
//       'description': 'Master Flutter framework for mobile app development',
//       'status': 'in_progress',
//       'sub_goals': [
//         {
//           'id': '1',
//           'title': 'Complete Flutter Basics',
//           'status': 'completed'
//         },
//         {
//           'id': '2',
//           'title': 'Build First App',
//           'status': 'in_progress'
//         }
//       ],
//       'created_at': now.toString(),
//       'updated_at': now.toString()
//     };
//   }

//   List<Map<String, dynamic>> _getCareerRecommendations() {
//     return [
//       {
//         'id': '1',
//         'title': 'Software Developer',
//         'description': 'Develop software applications and systems',
//         'is_favorite': true,
//         'category': 'Technology'
//       },
//       {
//         'id': '2',
//         'title': 'Data Scientist',
//         'description': 'Analyze and interpret complex data',
//         'is_favorite': false,
//         'category': 'Technology'
//       }
//     ];
//   }

//   Map<String, dynamic> _getCareerRecommendationDetails(String careerId) {
//     return {
//       'id': careerId,
//       'title': 'Software Developer',
//       'description': 'Develop software applications and systems',
//       'requirements': ['Programming skills', 'Problem solving', 'Team work'],
//       'salary_range': '\$60,000 - \$120,000',
//       'education': 'Bachelor\'s in Computer Science',
//       'is_favorite': true
//     };
//   }

//   List<Map<String, dynamic>> _getCareerQuestions() {
//     return [
//       {
//         'id': 1,
//         'question': 'What type of work environment do you prefer?',
//         'options': ['Office', 'Remote', 'Hybrid', 'Outdoor']
//       }
//     ];
//   }

//   List<Map<String, dynamic>> _getTransferableSkills() {
//     return [
//       {
//         'id': '1',
//         'name': 'Leadership',
//         'description': 'Ability to lead and motivate teams',
//         'is_liked': true
//       },
//       {
//         'id': '2',
//         'name': 'Communication',
//         'description': 'Effective verbal and written communication',
//         'is_liked': false
//       }
//     ];
//   }

//   List<Map<String, dynamic>> _getResumesList() {
//     final now = DateTime.now();
//     final dateStr = now.toIso8601String();
//     return [
//       {
//         'id': '1',
//         'title': 'Software Developer Resume',
//         'createdAt': dateStr,
//         'updatedAt': dateStr,
//         'experience': [
//           {
//             'job_title': 'Software Engineer',
//             'company': 'Tech Corp',
//             'start_date': now.subtract(Duration(days: 365 * 2)).toIso8601String(),
//             'end_date': now.toIso8601String(),
//             'description': 'Worked on Flutter apps'
//           }
//         ],
//         'education': [
//           {
//             'institution': 'University of Example',
//             'degree': 'BSc Computer Science',
//             'field_of_study': 'Computer Science',
//             'start_year': 2015,
//             'end_year': 2019
//           }
//         ],
//         'licenses_and_certifications': [
//           {
//             'certification_name': 'Certified Flutter Dev',
//             'issuing_organization': 'Google',
//             'issue_date': now.subtract(Duration(days: 365)).toIso8601String(),
//             'expiration_date': now.add(Duration(days: 365)).toIso8601String()
//           }
//         ],
//         'honors_and_awards': [
//           {
//             'award_name': 'Best Developer',
//             'awarding_organization': 'Tech Awards',
//             'date_Received': now.subtract(Duration(days: 200)).toIso8601String(),
//             'description': 'Awarded for outstanding performance.'
//           }
//         ],
//         'volunteer_experience': [
//           {
//             'organization_name': 'Open Source Org',
//             'role': 'Contributor',
//             'start_year': 2020,
//             'end_year': 2022,
//             'description': 'Contributed to open source.'
//           }
//         ]
//       }
//     ];
//   }

//   Map<String, dynamic> _getResumeData(Map<String, dynamic>? body) {
//     final now = DateTime.now();
//     final dateStr = now.toIso8601String();
//     return {
//       'id': now.millisecondsSinceEpoch.toString(),
//       'title': body?['title'] ?? 'New Resume',
//       'createdAt': dateStr,
//       'updatedAt': dateStr,
//       'experience': [
//         {
//           'job_title': 'Software Engineer',
//           'company': 'Tech Corp',
//           'start_date': now.subtract(Duration(days: 365 * 2)).toIso8601String(),
//           'end_date': now.toIso8601String(),
//           'description': 'Worked on Flutter apps'
//         }
//       ],
//       'education': [
//         {
//           'institution': 'University of Example',
//           'degree': 'BSc Computer Science',
//           'field_of_study': 'Computer Science',
//           'start_year': 2015,
//           'end_year': 2019
//         }
//       ],
//       'licenses_and_certifications': [
//         {
//           'certification_name': 'Certified Flutter Dev',
//           'issuing_organization': 'Google',
//           'issue_date': now.subtract(Duration(days: 365)).toIso8601String(),
//           'expiration_date': now.add(Duration(days: 365)).toIso8601String()
//         }
//       ],
//       'honors_and_awards': [
//         {
//           'award_name': 'Best Developer',
//           'awarding_organization': 'Tech Awards',
//           'date_Received': now.subtract(Duration(days: 200)).toIso8601String(),
//           'description': 'Awarded for outstanding performance.'
//         }
//       ],
//       'volunteer_experience': [
//         {
//           'organization_name': 'Open Source Org',
//           'role': 'Contributor',
//           'start_year': 2020,
//           'end_year': 2022,
//           'description': 'Contributed to open source.'
//         }
//       ]
//     };
//   }

//   Map<String, dynamic> _getResumeDetails(String resumeId) {
//     final now = DateTime.now();
//     final dateStr = now.toIso8601String();
//     return {
//       'id': resumeId,
//       'title': 'Software Developer Resume',
//       'sections': [
//         {
//           'type': 'personal_info',
//           'data': {
//             'name': 'John Doe',
//             'email': 'john@example.com',
//             'phone': '+1234567890'
//           }
//         }
//       ],
//       'createdAt': dateStr,
//       'updatedAt': dateStr,
//       'experience': [
//         {
//           'job_title': 'Software Engineer',
//           'company': 'Tech Corp',
//           'start_date': now.subtract(Duration(days: 365 * 2)).toIso8601String(),
//           'end_date': now.toIso8601String(),
//           'description': 'Worked on Flutter apps'
//         }
//       ],
//       'education': [
//         {
//           'institution': 'University of Example',
//           'degree': 'BSc Computer Science',
//           'field_of_study': 'Computer Science',
//           'start_year': 2015,
//           'end_year': 2019
//         }
//       ],
//       'licenses_and_certifications': [
//         {
//           'certification_name': 'Certified Flutter Dev',
//           'issuing_organization': 'Google',
//           'issue_date': now.subtract(Duration(days: 365)).toIso8601String(),
//           'expiration_date': now.add(Duration(days: 365)).toIso8601String()
//         }
//       ],
//       'honors_and_awards': [
//         {
//           'award_name': 'Best Developer',
//           'awarding_organization': 'Tech Awards',
//           'date_Received': now.subtract(Duration(days: 200)).toIso8601String(),
//           'description': 'Awarded for outstanding performance.'
//         }
//       ],
//       'volunteer_experience': [
//         {
//           'organization_name': 'Open Source Org',
//           'role': 'Contributor',
//           'start_year': 2020,
//           'end_year': 2022,
//           'description': 'Contributed to open source.'
//         }
//       ]
//     };
//   }

//   List<Map<String, dynamic>> _getSuccessStories() {
//     return [
//       {
//         'id': '1',
//         'name': 'Sarah Johnson',
//         'title': 'From Military to Tech',
//         'story': 'Successfully transitioned from military service to software development',
//         'image': 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Success'
//       }
//     ];
//   }

//   List<Map<String, dynamic>> _getNotificationsList() {
//     final now = DateTime.now();
//     return [
//       {
//         'id': '1',
//         'title': 'New Career Recommendation',
//         'message': 'You have new career recommendations available',
//         'is_read': false,
//         'created_at': now.toString()
//       }
//     ];
//   }

//   Map<String, dynamic> _getNotificationSettings() {
//     return {
//       'push_notifications': true,
//       'email_notifications': true,
//       'career_updates': true,
//       'goal_reminders': true
//     };
//   }

//   Map<String, dynamic> _getChatResponse(String message) {
//     final now = DateTime.now();
//     return {
//       'response': 'Thank you for your message: "$message". How can I help you today?',
//       'timestamp': now.toString()
//     };
//   }

//   Map<String, dynamic> _getSubscriptionData() {
//     final now = DateTime.now();
//     return {
//       'plan': 'premium',
//       'status': 'active',
//       'expires_at': now.add(const Duration(days: 30)).toString(),
//       'features': ['Unlimited career recommendations', 'Resume builder', 'Goal tracking']
//     };
//   }

//   List<Map<String, dynamic>> _getAwardQuestions() {
//     return [
//       {
//         'id': 1,
//         'question': 'What are your career goals?',
//         'type': 'text'
//       }
//     ];
//   }

//   Map<String, dynamic> _getAwardData() {
//     final now = DateTime.now();
//     return {
//       'id': '1',
//       'title': 'Career Development Award',
//       'status': 'completed',
//       'created_at': now.toString()
//     };
//   }

//   List<Map<String, dynamic>> _getAwardsList() {
//     final now = DateTime.now();
//     return [
//       {
//         'id': '1',
//         'title': 'Career Development Award',
//         'status': 'completed',
//         'created_at': now.toString()
//       }
//     ];
//   }
// }
