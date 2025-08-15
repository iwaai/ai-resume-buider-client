import 'dart:convert';

import '../blocs/home/transferable_skills/transferable_skills_bloc.dart';
import '../utils/constants/result.dart';

List<LibraryModel> libraryModelFromJson(String str) => List<LibraryModel>.from(
    json.decode(str).map((x) => LibraryModel.fromJson(x)));

class LibraryModel {
  final String? id;
  final LibraryData? favoriteHobby1;
  final LibraryData? athlete;
  final LibraryData? rank;
  final LibraryData? favoriteMiddleSchoolSubject;
  final LibraryData? favoriteHobby2;

  LibraryModel({
    this.id,
    this.favoriteHobby1,
    this.athlete,
    this.rank,
    this.favoriteMiddleSchoolSubject,
    this.favoriteHobby2,
  });

  LibraryModel copyWith({
    String? id,
    LibraryData? favoriteHobby1,
    LibraryData? athlete,
    LibraryData? rank,
    LibraryData? favoriteMiddleSchoolSubject,
    LibraryData? favoriteHobby2,
  }) =>
      LibraryModel(
        id: id ?? this.id,
        favoriteHobby1: favoriteHobby1 ?? this.favoriteHobby1,
        athlete: athlete ?? this.athlete,
        rank: rank ?? this.rank,
        favoriteMiddleSchoolSubject:
            favoriteMiddleSchoolSubject ?? this.favoriteMiddleSchoolSubject,
        favoriteHobby2: favoriteHobby2 ?? this.favoriteHobby2,
      );

  factory LibraryModel.fromJson(Map<String, dynamic> json) => LibraryModel(
        id: json["_id"],
        favoriteHobby1: json["favorite_hobby1"] == null
            ? null
            : LibraryData.fromJson(json["favorite_hobby1"]),
        athlete: json["athlete"] == null
            ? null
            : LibraryData.fromJson(json["athlete"]),
        rank: json["rank"] == null ? null : LibraryData.fromJson(json["rank"]),
        favoriteMiddleSchoolSubject:
            json["favorite_middle_school_subject"] == null
                ? null
                : LibraryData.fromJson(json["favorite_middle_school_subject"]),
        favoriteHobby2: json["favorite_hobby2"] == null
            ? null
            : LibraryData.fromJson(json["favorite_hobby2"]),
      );

  CustomLibraryModel? get getLibraryModel {
    if (favoriteHobby1?.descriptionId != null) {
      return CustomLibraryModel(
        title: favoriteHobby1?.title ?? 'title',
        nodeId: favoriteHobby1?.favoriteHobbyId?.id ?? 'node_id',
        description: favoriteHobby1?.description ?? 'Description',
        descriptionId: favoriteHobby1?.descriptionId ?? 'Description_id',
        nodeName: ShowNode.favoriteHobby1,
      );
    }
    if (athlete?.descriptionId != null) {
      return CustomLibraryModel(
        title: athlete?.title ?? 'title',
        nodeId: athlete?.athleteId?.id ?? 'athlete_id',
        description: athlete?.description ?? 'Description',
        descriptionId: athlete?.descriptionId ?? 'Description_id',
        nodeName: ShowNode.atheleteSportsPosition,
      );
    }
    if (rank?.descriptionId != null) {
      return CustomLibraryModel(
        title: rank?.title ?? 'title',
        nodeId: rank?.rankId?.id ?? 'rank_id',
        description: rank?.description ?? 'Description',
        descriptionId: rank?.descriptionId ?? 'Description_id',
        nodeName: ShowNode.military,
      );
    }
    if (favoriteMiddleSchoolSubject?.descriptionId != null) {
      return CustomLibraryModel(
        title: favoriteMiddleSchoolSubject?.title ?? 'title',
        nodeId:
            favoriteMiddleSchoolSubject?.favoriteSubjectId?.id ?? 'subject_id',
        description: favoriteMiddleSchoolSubject?.description ?? 'Description',
        descriptionId:
            favoriteMiddleSchoolSubject?.descriptionId ?? 'Description_id',
        nodeName: ShowNode.favoriteSchoolSubject,
      );
    }
    if (favoriteHobby2?.descriptionId != null) {
      return CustomLibraryModel(
        nodeId: favoriteHobby2?.favoriteHobbyId?.id ?? 'node_id',
        description: favoriteHobby2?.description ?? 'Description',
        descriptionId: favoriteHobby2?.descriptionId ?? 'Description_id',
        nodeName: ShowNode.favoriteHobby2,
        title: favoriteHobby2?.title ?? 'title',
      );
    }
    return null;
  }
}

class CustomLibraryModel {
  final String nodeId;
  final String title;
  final String description;
  final String descriptionId;
  final ShowNode nodeName;

  CustomLibraryModel({
    required this.nodeId,
    required this.title,
    required this.description,
    required this.descriptionId,
    required this.nodeName,
  });

  CustomLibraryModel copyWith(
      {String? nodeId,
      String? title,
      String? description,
      String? descriptionId,
      ShowNode? nodeName,
      Result? result}) {
    return CustomLibraryModel(
      nodeId: nodeId ?? this.nodeId,
      title: title ?? this.title,
      description: description ?? this.description,
      descriptionId: descriptionId ?? this.descriptionId,
      nodeName: nodeName ?? this.nodeName,
    );
  }
}

class LibraryData {
  final Library? favoriteHobbyId;
  final Library? athleteId;
  final Library? rankId;
  final Library? favoriteSubjectId;
  final String? descriptionId;
  final String? description;
  final String? title;

  LibraryData({
    this.descriptionId,
    this.description,
    this.title,
    this.favoriteHobbyId,
    this.athleteId,
    this.rankId,
    this.favoriteSubjectId,
  });

  LibraryData copyWith({
    Library? favoriteHobbyId,
    Library? athleteId,
    Library? rankId,
    Library? favoriteSubjectId,
    String? descriptionId,
    String? description,
    String? title,
  }) =>
      LibraryData(
        favoriteHobbyId: favoriteHobbyId ?? this.favoriteHobbyId,
        athleteId: athleteId ?? this.athleteId,
        rankId: rankId ?? this.rankId,
        favoriteSubjectId: favoriteSubjectId ?? this.favoriteSubjectId,
        descriptionId: descriptionId ?? this.descriptionId,
        description: description ?? this.description,
        title: title ?? this.title,
      );

  factory LibraryData.fromJson(Map<String, dynamic> json) => LibraryData(
        favoriteHobbyId: json["favorite_hobbyId"] == null
            ? null
            : Library.fromJson(json["favorite_hobbyId"]),
        athleteId: json["athleteId"] == null
            ? null
            : Library.fromJson(json["athleteId"]),
        rankId:
            json["rankId"] == null ? null : Library.fromJson(json["rankId"]),
        favoriteSubjectId: json["favoriteSubjectId"] == null
            ? null
            : Library.fromJson(json["favoriteSubjectId"]),
        descriptionId: json["descriptionId"],
        description: json["description"],
        title: json["title"],
      );
}

class Library {
  final String? id;
  final String? hobbieName;
  final String? positionName;
  final String? rankName;
  final String? subjectName;

  Library({
    this.id,
    this.hobbieName,
    this.positionName,
    this.rankName,
    this.subjectName,
  });

  Library copyWith({
    String? id,
    String? hobbieName,
    String? positionName,
    String? rankName,
    String? subjectName,
  }) =>
      Library(
        id: id ?? this.id,
        hobbieName: hobbieName ?? this.hobbieName,
        positionName: positionName ?? this.positionName,
        rankName: rankName ?? this.rankName,
        subjectName: subjectName ?? this.subjectName,
      );

  factory Library.fromJson(Map<String, dynamic> json) => Library(
        id: json["_id"],
        hobbieName: json["hobbie_name"],
        positionName: json["position_name"],
        rankName: json["rank_name"],
        subjectName: json["subject_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hobbie_name": hobbieName,
        "position_name": positionName,
        "rank_name": rankName,
        "subject_name": subjectName,
      };
}
