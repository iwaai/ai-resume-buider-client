///Registration Data Model
class RegistrationDataModel {
  RegistrationDataModel({
    required this.id,
    required this.branchOfService,
    required this.currentGradeLevel,
    required this.desiredCareerPath,
    required this.favoriteHobby1,
    required this.favoriteHobby2,
    required this.favoriteMiddleSchoolSubject,
    required this.hasJobExperience,
    required this.hasMilitaryService,
    required this.highestDegreeCompletion,
    required this.isAthlete,
    required this.isEighteenOrOlder,
    required this.majorTradeOrMilitary,
    required this.primarySport,
    required this.rank,
    required this.recentJobTitle,
    required this.sportPosition,
  });

  final String? id;
  final ForceService? branchOfService;
  final String? currentGradeLevel;
  final String? desiredCareerPath;
  final HobbyModel? favoriteHobby1;
  final HobbyModel? favoriteHobby2;
  final SubjectModel? favoriteMiddleSchoolSubject;
  final bool? hasJobExperience;
  final bool? hasMilitaryService;
  final String? highestDegreeCompletion;
  final bool? isAthlete;
  final bool? isEighteenOrOlder;
  final String? majorTradeOrMilitary;
  final SportsModel? primarySport;
  final ForceRanks? rank;
  final String? recentJobTitle;
  final SportsPositionsModel? sportPosition;

  RegistrationDataModel copyWith({
    String? id,
    ForceService? branchOfService,
    String? currentGradeLevel,
    String? desiredCareerPath,
    HobbyModel? favoriteHobby1,
    HobbyModel? favoriteHobby2,
    SubjectModel? favoriteMiddleSchoolSubject,
    bool? hasJobExperience,
    bool? hasMilitaryService,
    String? highestDegreeCompletion,
    bool? isAthlete,
    bool? isEighteenOrOlder,
    String? majorTradeOrMilitary,
    SportsModel? primarySport,
    ForceRanks? rank,
    String? recentJobTitle,
    SportsPositionsModel? sportPosition,
  }) {
    return RegistrationDataModel(
      id: id ?? this.id,
      branchOfService: branchOfService ?? this.branchOfService,
      currentGradeLevel: currentGradeLevel ?? this.currentGradeLevel,
      desiredCareerPath: desiredCareerPath ?? this.desiredCareerPath,
      favoriteHobby1: favoriteHobby1 ?? this.favoriteHobby1,
      favoriteHobby2: favoriteHobby2 ?? this.favoriteHobby2,
      favoriteMiddleSchoolSubject:
          favoriteMiddleSchoolSubject ?? this.favoriteMiddleSchoolSubject,
      hasJobExperience: hasJobExperience ?? this.hasJobExperience,
      hasMilitaryService: hasMilitaryService ?? this.hasMilitaryService,
      highestDegreeCompletion:
          highestDegreeCompletion ?? this.highestDegreeCompletion,
      isAthlete: isAthlete ?? this.isAthlete,
      isEighteenOrOlder: isEighteenOrOlder ?? this.isEighteenOrOlder,
      majorTradeOrMilitary: majorTradeOrMilitary ?? this.majorTradeOrMilitary,
      primarySport: primarySport ?? this.primarySport,
      rank: rank ?? this.rank,
      recentJobTitle: recentJobTitle ?? this.recentJobTitle,
      sportPosition: sportPosition ?? this.sportPosition,
    );
  }

  factory RegistrationDataModel.fromJson(Map<String, dynamic> json) {
    return RegistrationDataModel(
      id: json["_id"],
      branchOfService: json["branch_of_service"] == null
          ? null
          : ForceService.fromJson(json["branch_of_service"]),
      currentGradeLevel: json["current_grade_level"],
      desiredCareerPath: json["desired_career_path"],
      favoriteHobby1: json["favorite_hobby1"] == null
          ? null
          : HobbyModel.fromJson(json["favorite_hobby1"]),
      favoriteHobby2: json["favorite_hobby2"] == null
          ? null
          : HobbyModel.fromJson(json["favorite_hobby2"]),
      favoriteMiddleSchoolSubject:
          json["favorite_middle_school_subject"] == null
              ? null
              : SubjectModel.fromJson(json["favorite_middle_school_subject"]),
      hasJobExperience: json["has_job_experience"],
      hasMilitaryService: json["has_military_service"],
      highestDegreeCompletion: json["highest_degree_completion"],
      isAthlete: json["is_athlete"],
      isEighteenOrOlder: json["is_eighteen_or_older"],
      majorTradeOrMilitary: json["major_trade_or_military"],
      primarySport: json["primary_sport"] == null
          ? null
          : SportsModel.fromJson(json["primary_sport"]),
      rank: json["rank"] == null ? null : ForceRanks.fromJson(json["rank"]),
      recentJobTitle: json["recent_job_title"],
      sportPosition: json["sport_position"] == null
          ? null
          : SportsPositionsModel.fromJson(json["sport_position"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "branch_of_service": branchOfService?.toJson(),
        "current_grade_level": currentGradeLevel,
        "desired_career_path": desiredCareerPath,
        "favorite_hobby1": favoriteHobby1?.toJson(),
        "favorite_hobby2": favoriteHobby2?.toJson(),
        "favorite_middle_school_subject": favoriteMiddleSchoolSubject?.toJson(),
        "has_job_experience": hasJobExperience,
        "has_military_service": hasMilitaryService,
        "highest_degree_completion": highestDegreeCompletion,
        "is_athlete": isAthlete,
        "is_eighteen_or_older": isEighteenOrOlder,
        "major_trade_or_military": majorTradeOrMilitary,
        "primary_sport": primarySport,
        "rank": rank?.toJson(),
        "recent_job_title": recentJobTitle,
        "sport_position": sportPosition,
      };

  factory RegistrationDataModel.idle() => RegistrationDataModel(
        id: '',
        branchOfService: null,
        currentGradeLevel: '',
        desiredCareerPath: '',
        favoriteHobby1: null,
        favoriteHobby2: null,
        favoriteMiddleSchoolSubject: null,
        hasJobExperience: false,
        hasMilitaryService: false,
        highestDegreeCompletion: '',
        isAthlete: false,
        isEighteenOrOlder: false,
        majorTradeOrMilitary: '',
        primarySport: null,
        rank: null,
        recentJobTitle: '',
        sportPosition: null,
      );
}

/// Registration Form Models

sealed class RegistrationFormDataModel {
  final String id;
  final String name;

  RegistrationFormDataModel({required this.id, required this.name});
}

///TODO: Implement Data models from here
///Note: Model based dropdown widget usage in q4 widget of registration

class ForceService extends RegistrationFormDataModel {
  ForceService({required super.id, required super.name});

  factory ForceService.fromJson(Map<String, dynamic> json) {
    return ForceService(
      id: json['_id'],
      name: json['service_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service_name': name,
    };
  }

  factory ForceService.idle() {
    return ForceService(
      id: '',
      name: '',
    );
  }
}

class ForceRanks extends RegistrationFormDataModel {
  ForceRanks({required super.id, required super.name, required this.service});
  final ForceService? service;

  factory ForceRanks.fromJson(Map<String, dynamic> json) {
    return ForceRanks(
      id: json['_id'],
      name: json['rank_name'],
      service: json['serviceId'] == null
          ? null
          : ForceService.fromJson(json['serviceId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rank_name': name,
      'service': service?.toJson(),
    };
  }

  factory ForceRanks.idle() {
    return ForceRanks(
      id: '',
      name: '',
      service: ForceService.idle(),
    );
  }
}

class SportsModel extends RegistrationFormDataModel {
  SportsModel({required super.id, required super.name});

  factory SportsModel.fromJson(Map<String, dynamic> json) {
    return SportsModel(
      id: json['_id'],
      name: json['sport_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sport_name': name,
    };
  }

  factory SportsModel.idle() {
    return SportsModel(
      id: '',
      name: '',
    );
  }
}

class SportsPositionsModel extends RegistrationFormDataModel {
  SportsPositionsModel(
      {required super.id, required super.name, required this.sport});
  final SportsModel? sport;

  factory SportsPositionsModel.fromJson(Map<String, dynamic> json) {
    return SportsPositionsModel(
      id: json['_id'],
      name: json['position_name'] ?? "",
      sport: json['sportId'] != null
          ? SportsModel.fromJson(json['sportId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'position_name': name,
      'sportId': sport?.toJson(),
    };
  }

  factory SportsPositionsModel.idle() {
    return SportsPositionsModel(
      id: '',
      name: '',
      sport: SportsModel.idle(),
    );
  }
}

class HobbyModel extends RegistrationFormDataModel {
  HobbyModel({required super.id, required super.name});

  factory HobbyModel.fromJson(Map<String, dynamic> json) {
    return HobbyModel(
      id: json['_id'],
      name: json['hobbie_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'hobbie_name': name,
    };
  }

  factory HobbyModel.idle() {
    return HobbyModel(
      id: '',
      name: '',
    );
  }
}

class SubjectModel extends RegistrationFormDataModel {
  SubjectModel({required super.id, required super.name});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'],
      name: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subject_name': name,
    };
  }

  factory SubjectModel.idle() {
    return SubjectModel(
      id: '',
      name: '',
    );
  }
}
