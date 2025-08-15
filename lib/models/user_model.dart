class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImg;
  final String state;
  final String city;
  final String address;
  final bool isProfileCompleted;
  final bool isSubscriptionPaid;
  final bool isRegistrationQuestionCompleted;
  final String currentSubscriptionPlan;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImg,
    required this.state,
    required this.city,
    required this.address,
    required this.isProfileCompleted,
    required this.isSubscriptionPaid,
    required this.isRegistrationQuestionCompleted,
    required this.currentSubscriptionPlan,
  });

  factory UserModel.initial() {
    return UserModel(
        id: '',
        name: '',
        email: '',
        phone: '',
        profileImg: '',
        state: '',
        city: '',
        address: '',
        isProfileCompleted: false,
        isSubscriptionPaid: false,
        isRegistrationQuestionCompleted: false,
        currentSubscriptionPlan: '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImg: json['profile_img'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      isProfileCompleted: json['is_profile_completed'] ?? false,
      isSubscriptionPaid: json['is_subscription_paid'] ?? false,
      isRegistrationQuestionCompleted:
          json['is_registration_question_completed'] ?? false,
      currentSubscriptionPlan: json['current_subscription_plan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_img': profileImg,
      'state': state,
      'city': city,
      'address': address,
      'is_profile_completed': isProfileCompleted,
      'is_subscription_paid': isSubscriptionPaid,
      'is_registration_question_completed': isRegistrationQuestionCompleted,
      'current_subscription_plan': currentSubscriptionPlan,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImg,
    String? state,
    String? city,
    String? address,
    bool? isProfileCompleted,
    bool? isSubscriptionPaid,
    bool? isRegistrationQuestionCompleted,
    String? currentSubscriptionPlan,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImg: profileImg ?? this.profileImg,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      isSubscriptionPaid: isSubscriptionPaid ?? this.isSubscriptionPaid,
      isRegistrationQuestionCompleted: isRegistrationQuestionCompleted ??
          this.isRegistrationQuestionCompleted,
      currentSubscriptionPlan:
          currentSubscriptionPlan ?? this.currentSubscriptionPlan,
    );
  }
}
