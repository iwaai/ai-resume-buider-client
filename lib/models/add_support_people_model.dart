// To parse this JSON data, do
//
//     final addSupportPeopleModel = addSupportPeopleModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

AddSupportPeopleModel addSupportPeopleModelFromJson(String str) =>
    AddSupportPeopleModel.fromJson(json.decode(str));

String addSupportPeopleModelToJson(AddSupportPeopleModel data) =>
    json.encode(data.toJson());

class AddSupportPeopleModel {
  final String? resumeId;
  final List<SupportPerson>? supportPeople;
  final File? resume;

  AddSupportPeopleModel({this.resumeId, this.supportPeople, this.resume});

  AddSupportPeopleModel copyWith({
    String? resumeId,
    File? resume,
    List<SupportPerson>? supportPeople,
  }) =>
      AddSupportPeopleModel(
          resumeId: resumeId ?? this.resumeId,
          supportPeople: supportPeople ?? this.supportPeople,
          resume: resume ?? this.resume);

  factory AddSupportPeopleModel.fromJson(Map<String, dynamic> json) =>
      AddSupportPeopleModel(
        resumeId: json["resumeId"],
        resume: json["resume"],
        supportPeople: json["supportPeople"] == null
            ? []
            : List<SupportPerson>.from(
                json["supportPeople"]!.map((x) => SupportPerson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resumeId": resumeId,
        "resume": resume,
        "supportPeople": supportPeople == null
            ? []
            : List<dynamic>.from(supportPeople!.map((x) => x.toJson())),
      };
}

class SupportPerson {
  final String? fullName;
  final String? emailAddress;
  final String? phoneNumber;

  SupportPerson({
    this.fullName,
    this.emailAddress,
    this.phoneNumber,
  });

  SupportPerson copyWith({
    String? fullName,
    String? emailAddress,
    String? phoneNumber,
  }) =>
      SupportPerson(
        fullName: fullName ?? this.fullName,
        emailAddress: emailAddress ?? this.emailAddress,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );

  factory SupportPerson.fromJson(Map<String, dynamic> json) => SupportPerson(
        fullName: json["full_name"],
        emailAddress: json["email_address"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "email_address": emailAddress,
        // "phone_number": phoneNumber,
      };
}

class AddSupportPeopleInTSkill {
  final File file;
  final List<SupportPerson> supportPeople;

  AddSupportPeopleInTSkill({required this.file, required this.supportPeople});

  Map<String, dynamic> toJson() => {
        "transferablleSkills": file,
        "supportPeople":
            List<dynamic>.from(supportPeople.map((x) => x.toJson())),
      };
}
