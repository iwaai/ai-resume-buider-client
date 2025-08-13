class TransferableSkillsModel {
  final String? id;
  final int? v;
  final Athlete? athlete;
  final FavoriteHobby? favoriteHobby1;
  final FavoriteHobby? favoriteHobby2;
  final FavoriteMiddleSchoolSubject? favoriteMiddleSchoolSubject;
  final bool? hasMilitaryService;
  final bool? isAthlete;
  final Military? military;

  TransferableSkillsModel({
    this.id,
    this.v,
    this.athlete,
    this.favoriteHobby1,
    this.favoriteHobby2,
    this.favoriteMiddleSchoolSubject,
    this.hasMilitaryService,
    this.isAthlete,
    this.military,
  });

  TransferableSkillsModel copyWith({
    String? id,
    int? v,
    Athlete? athlete,
    FavoriteHobby? favoriteHobby1,
    FavoriteHobby? favoriteHobby2,
    FavoriteMiddleSchoolSubject? favoriteMiddleSchoolSubject,
    bool? hasMilitaryService,
    bool? isAthlete,
    Military? military,
  }) =>
      TransferableSkillsModel(
        id: id ?? this.id,
        v: v ?? this.v,
        athlete: athlete ?? this.athlete,
        favoriteHobby1: favoriteHobby1 ?? this.favoriteHobby1,
        favoriteHobby2: favoriteHobby2 ?? this.favoriteHobby2,
        favoriteMiddleSchoolSubject:
            favoriteMiddleSchoolSubject ?? this.favoriteMiddleSchoolSubject,
        hasMilitaryService: hasMilitaryService ?? this.hasMilitaryService,
        isAthlete: isAthlete ?? this.isAthlete,
        military: military ?? this.military,
      );

  factory TransferableSkillsModel.fromJson(Map<String, dynamic> json) =>
      TransferableSkillsModel(
        id: json["_id"],
        v: json["__v"],
        athlete:
            json["athlete"] == null ? null : Athlete.fromJson(json["athlete"]),
        favoriteHobby1: json["favorite_hobby1"] == null
            ? null
            : FavoriteHobby.fromJson(json["favorite_hobby1"]),
        favoriteHobby2: json["favorite_hobby2"] == null
            ? null
            : FavoriteHobby.fromJson(json["favorite_hobby2"]),
        favoriteMiddleSchoolSubject:
            json["favorite_middle_school_subject"] == null
                ? null
                : FavoriteMiddleSchoolSubject.fromJson(
                    json["favorite_middle_school_subject"]),
        hasMilitaryService: json["has_military_service"],
        isAthlete: json["is_athlete"],
        military: json["military"] == null
            ? null
            : Military.fromJson(json["military"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "athlete": athlete?.toJson(),
        "favorite_hobby1": favoriteHobby1?.toJson(),
        "favorite_hobby2": favoriteHobby2?.toJson(),
        "favorite_middle_school_subject": favoriteMiddleSchoolSubject?.toJson(),
        "has_military_service": hasMilitaryService,
        "is_athlete": isAthlete,
        "military": military?.toJson(),
      };
}

class Athlete {
  final PrimarySport? primarySport;
  final SportPosition? sportPosition;

  Athlete({
    this.primarySport,
    this.sportPosition,
  });

  Athlete copyWith({
    PrimarySport? primarySport,
    SportPosition? sportPosition,
  }) =>
      Athlete(
        primarySport: primarySport ?? this.primarySport,
        sportPosition: sportPosition ?? this.sportPosition,
      );

  factory Athlete.fromJson(Map<String, dynamic> json) => Athlete(
        primarySport: json["primary_sport"] == null
            ? null
            : PrimarySport.fromJson(json["primary_sport"]),
        sportPosition: json["sport_position"] == null
            ? null
            : SportPosition.fromJson(json["sport_position"]),
      );

  Map<String, dynamic> toJson() => {
        "primary_sport": primarySport?.toJson(),
        "sport_position": sportPosition?.toJson(),
      };
}

class PrimarySport {
  final String? id;
  final String? sportName;
  final List<Topic>? topics;

  PrimarySport({this.id, this.sportName, this.topics});

  PrimarySport copyWith({
    String? id,
    String? sportName,
    List<Topic>? topics,
  }) =>
      PrimarySport(
        id: id ?? this.id,
        sportName: sportName ?? this.sportName,
        topics: topics ?? this.topics,
      );

  factory PrimarySport.fromJson(Map<String, dynamic> json) => PrimarySport(
        id: json["_id"],
        sportName: json["sport_name"],
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sport_name": sportName,
        "topics": topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}

class SportPosition {
  final String? id;
  final String? positionName;
  final List<Topic>? topics;

  SportPosition({
    this.id,
    this.positionName,
    this.topics,
  });

  SportPosition copyWith({
    String? id,
    String? positionName,
    List<Topic>? topics,
  }) =>
      SportPosition(
        id: id ?? this.id,
        positionName: positionName ?? this.positionName,
        topics: topics ?? this.topics,
      );

  factory SportPosition.fromJson(Map<String, dynamic> json) => SportPosition(
        id: json["_id"],
        positionName: json["position_name"],
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "position_name": positionName,
        "topics": topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}

class Topic {
  final String? title;
  final String? description;
  final String? id;
  final bool? isFavorite;

  Topic({
    this.title,
    this.description,
    this.id,
    this.isFavorite,
  });

  Topic copyWith({
    String? title,
    String? description,
    String? id,
    bool? isFavorite,
  }) =>
      Topic(
        title: title ?? this.title,
        description: description ?? this.description,
        id: id ?? this.id,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        title: json["title"],
        description: json["description"],
        id: json["_id"],
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "_id": id,
        "is_favorite": isFavorite,
      };
}

class FavoriteHobby {
  final String? id;
  final String? hobbieName;
  final List<Topic>? topics;

  FavoriteHobby({
    this.id,
    this.hobbieName,
    this.topics,
  });

  FavoriteHobby copyWith({
    String? id,
    String? hobbieName,
    List<Topic>? topics,
  }) =>
      FavoriteHobby(
        id: id ?? this.id,
        hobbieName: hobbieName ?? this.hobbieName,
        topics: topics ?? this.topics,
      );

  factory FavoriteHobby.fromJson(Map<String, dynamic> json) => FavoriteHobby(
        id: json["_id"],
        hobbieName: json["hobbie_name"],
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hobbie_name": hobbieName,
        "topics": topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}

class FavoriteMiddleSchoolSubject {
  final String? id;
  final String? subjectName;
  final List<Topic>? topics;

  FavoriteMiddleSchoolSubject({
    this.id,
    this.subjectName,
    this.topics,
  });

  FavoriteMiddleSchoolSubject copyWith({
    String? id,
    String? subjectName,
    List<Topic>? topics,
  }) =>
      FavoriteMiddleSchoolSubject(
        id: id ?? this.id,
        subjectName: subjectName ?? this.subjectName,
        topics: topics ?? this.topics,
      );

  factory FavoriteMiddleSchoolSubject.fromJson(Map<String, dynamic> json) =>
      FavoriteMiddleSchoolSubject(
        id: json["_id"],
        subjectName: json["subject_name"],
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subject_name": subjectName,
        "topics": topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}

class Military {
  final BranchOfService? branchOfService;
  final Rank? rank;

  Military({
    this.branchOfService,
    this.rank,
  });

  Military copyWith({
    BranchOfService? branchOfService,
    Rank? rank,
  }) =>
      Military(
        branchOfService: branchOfService ?? this.branchOfService,
        rank: rank ?? this.rank,
      );

  factory Military.fromJson(Map<String, dynamic> json) => Military(
        branchOfService: json["branch_of_service"] == null
            ? null
            : BranchOfService.fromJson(json["branch_of_service"]),
        rank: json["rank"] == null ? null : Rank.fromJson(json["rank"]),
      );

  Map<String, dynamic> toJson() => {
        "branch_of_service": branchOfService?.toJson(),
        "rank": rank?.toJson(),
      };
}

class BranchOfService {
  final String? id;
  final String? serviceName;

  BranchOfService({
    this.id,
    this.serviceName,
  });

  BranchOfService copyWith({
    String? id,
    String? serviceName,
  }) =>
      BranchOfService(
        id: id ?? this.id,
        serviceName: serviceName ?? this.serviceName,
      );

  factory BranchOfService.fromJson(Map<String, dynamic> json) =>
      BranchOfService(
        id: json["_id"],
        serviceName: json["service_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "service_name": serviceName,
      };
}

class Rank {
  final String? id;
  final String? rankName;
  final List<Topic>? topics;

  Rank({
    this.id,
    this.rankName,
    this.topics,
  });

  Rank copyWith({
    String? id,
    String? rankName,
    List<Topic>? topics,
  }) =>
      Rank(
        id: id ?? this.id,
        rankName: rankName ?? this.rankName,
        topics: topics ?? this.topics,
      );

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json["_id"],
        rankName: json["rank_name"],
        topics: json["topics"] == null
            ? []
            : List<Topic>.from(json["topics"]!.map((x) => Topic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rank_name": rankName,
        "topics": topics == null
            ? []
            : List<dynamic>.from(topics!.map((x) => x.toJson())),
      };
}
