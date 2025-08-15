class AppUrl {
  static const String checkFirebaseUser = '/api/auth/check-firebase-user';
  static const String login = '/api/auth/login';
  static const String signup = '/api/auth/sign-up';
  static const String otpVerify = '/api/auth/verify-otp';
  static const String resendOtp = '/api/auth/resend-email-otp';
  static const String setProfile = '/api/user/set-profile';
  static const String updateProfile = '/api/user/update-profile';
  static const String forgetPassword = '/api/auth/forget-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String updatePassword = '/api/user/change-password';
  static const String logout = '/api/user/logout';
  static const String deleteAccount = '/api/user/delete-account';
  static const String socialLogin = '/api/auth/social-login';
  static const String verifyPassword = '/api/user/verify-password';

  static const String getProfile = '/api/user/my-profile';

  ///Registration URLs
  static const String getRegistrationQuestionsData =
      '/api/services/get-all-questions';
  static const String getRegistrationData =
      '/api/user/get-registration-questions';
  static const String setRegistrationData =
      '/api/user/complete-registration-questions';
  static const String myTransferableSkills = '/api/user/my-transferable-skills';
  static const String toggleLike = '/api/user/toggle-transferable-skill';
  static const String sendSkillsToEmail = '/api/user/send-skills';
  static const String sendTSkillSupportPeople =
      '/api/user/add-support-people-transferablleSkills';
  static const String getSkillsLikes = '/api/user/get-user-transferable-skills';
  static const String getCareerLikes = '/api/user/my-favorite-careers';

  ///ResumeBuilder
  static const String getMyResumes = '/api/user/get-my-resumes';
  static const String createResume = '/api/user/create-resume';
  static const String resumeDetails = '/api/user/resume-detail';
  static const String updateResume = '/api/user/update-resume';
  static const String sendToEmail = '/api/user/send-to-email';
  static const String deleteResume = '/api/user/delete-resume';
  static const String sendToSupportPeople = '/api/user/add-support-people';

  /// /api/user/get-success-stories?
  static const String exploreProfile = '/api/user/get-success-stories';
  static const String matchProfile = '/api/user/my-match-profiles';
  static const String searchStory = '/api/user/search-success-story';

  ///  goals api
  static const String myGoals = '/api/user/my-goals';
  static const String createGoal = '/api/user/create-goal';
  static const String changeGoalStatus = '/api/user/change-goal-status';
  static const String addSupportPeople = '/api/user/add-support-people-goal';
  static const String goalDetail = '/api/user/goal-details';
  static const String deleteGoal = '/api/user/delete-goal';
  static const String updateSubGoalStatus = '/api/user/update-sub-goal-status';
  static const String searchGoal = '/api/user/search-success-story';

  /// Notifications Urls
  static const String setDeviceToken = '/api/user/store-device-token';
  static const String getNotifications = '/api/user/my-notifications';
  static const String deleteNotifications = '/api/user/delete-notification';
  static const String markNotificationsAsRead =
      '/api/user/mark-notifications-read';

  /// Career Recomm
  static const String getCareerRecommQuestions = '/api/user/get-questions';
  static const String getCareerRecommendations =
      '/api/user/my-career-recommendations';
  static const String getCareerRecommendationByID =
      '/api/user/career-recommendation-details';
  static const String getFavCareerRecommendationByID =
      '/api/user/favorite-career-details';
  static const String markRecommendationFavorite =
      '/api/user/toggle-favorite-career';
  static const String markCareerFavorite =
      '/api/user/toggle-favorite-single-career';
  static const String submitAssessment = '/api/user/submit-assessment';

  /// Setting
  static const String getNotification = '/api/user/my-notification-setting';
  static const String toggleNotifcation = '/api/user/toggle-notification';
  static const String chatBot = '/api/user/chat-with-bot';
  static const String buySubscriptionAndroid =
      '/api/subscription/verify-subscription-android';
  static const String buySubscriptionIOS =
      '/api/subscription/verify-subscription-ios';
  static const String mySubscription = '/api/subscription/my-subscription-plan';

  ///Privacy Policy and T&C Urls
  static const String privacyPolicyLink =
      'https://secondshot-app.vercel.app/privacy-policy';
  static const String termsLink =
      'https://secondshot-app.vercel.app/terms-and-condition';

  /// Awards
  static const String getFormQuestions = '/api/user/idp-questions';
  static const String submitForm = '/api/user/submit-idp-form';
  static const String updateForm = '/api/user/update-idp-form';
  static const String getAwards = '/api/user/my-idp-award';
  static const String sendFormToEmail = '/api/user/send-idp-form';
  static const String shareIdpReport = '/api/user/add-support-people-idp';
}
