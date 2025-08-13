// To parse this JSON data, do
//
//     final resumeModel = resumeModelFromJson(jsonString);

class ResumeModel {
  final bool isEdit;
  final String? id;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? address;
  final Objective? objective;
  final List<Experience>? experience;
  final List<Education>? education;
  final List<LicensesAndCertification>? licensesAndCertifications;

  final List<String>? softSkills;
  final List<String>? technicalSkills;
  final List<HonorsAndAward>? honorsAndAwards;
  final List<VolunteerExperience>? volunteerExperience;
  final List<dynamic>? supportPeople;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ResumeModel({
    this.isEdit = false,
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.objective,
    this.experience = const [Experience()],
    this.education = const [Education()],
    this.licensesAndCertifications = const [LicensesAndCertification()],
    this.softSkills,
    this.technicalSkills,
    this.honorsAndAwards = const [HonorsAndAward()],
    this.volunteerExperience = const [VolunteerExperience()],
    this.supportPeople,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ResumeModel copyWith({
    bool? isEdit,
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    Objective? objective,
    List<Experience>? experience,
    List<Education>? education,
    List<LicensesAndCertification>? licensesAndCertifications,
    List<String>? softSkills,
    List<String>? technicalSkills,
    List<HonorsAndAward>? honorsAndAwards,
    List<VolunteerExperience>? volunteerExperience,
    List<dynamic>? supportPeople,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      ResumeModel(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          fullName: fullName ?? this.fullName,
          email: email ?? this.email,
          phone: phone ?? this.phone,
          address: address ?? this.address,
          objective: objective ?? this.objective,
          experience: experience ?? this.experience,
          education: education ?? this.education,
          licensesAndCertifications:
              licensesAndCertifications ?? this.licensesAndCertifications,
          softSkills: softSkills ?? this.softSkills,
          technicalSkills: technicalSkills ?? this.technicalSkills,
          honorsAndAwards: honorsAndAwards ?? this.honorsAndAwards,
          volunteerExperience: volunteerExperience ?? this.volunteerExperience,
          supportPeople: supportPeople ?? this.supportPeople,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          v: v ?? this.v,
          isEdit: isEdit ?? this.isEdit);

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
        id: json["_id"],
        userId: json["userId"],
        fullName: json["full_name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        objective: json["objective"] == null
            ? null
            : Objective.fromJson(json["objective"]),
        experience: json["experience"] == null
            ? []
            : List<Experience>.from(
                json["experience"]!.map((x) => Experience.fromJson(x))),
        education: json["education"] == null
            ? []
            : List<Education>.from(
                json["education"]!.map((x) => Education.fromJson(x))),
        licensesAndCertifications: json["licenses_and_certifications"] == null
            ? []
            : List<LicensesAndCertification>.from(
                json["licenses_and_certifications"]!
                    .map((x) => LicensesAndCertification.fromJson(x))),
        softSkills: json["soft_skills"] == null
            ? []
            : List<String>.from(json["soft_skills"]!.map((x) => x)),
        technicalSkills: json["technical_skills"] == null
            ? []
            : List<String>.from(json["technical_skills"]!.map((x) => x)),
        honorsAndAwards: json["honors_and_awards"] == null
            ? []
            : List<HonorsAndAward>.from(json["honors_and_awards"]!
                .map((x) => HonorsAndAward.fromJson(x))),
        volunteerExperience: json["volunteer_experience"] == null
            ? []
            : List<VolunteerExperience>.from(json["volunteer_experience"]!
                .map((x) => VolunteerExperience.fromJson(x))),
        supportPeople: json["support_people"] == null
            ? []
            : List<dynamic>.from(json["support_people"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  // Map<String, dynamic> toJson() => {
  //       "_id": id,
  //       "userId": userId,
  //       "full_name": fullName,
  //       "email": email,
  //       "phone": phone,
  //       "address": address,
  //       "objective": objective?.toJson(),
  //       "experience": experience == null
  //           ? []
  //           : List<dynamic>.from(experience!.map((x) => x.toJson())),
  //       "education": education == null
  //           ? []
  //           : List<dynamic>.from(education!.map((x) => x.toJson())),
  //       "licenses_and_certifications": licensesAndCertifications == null
  //           ? []
  //           : List<dynamic>.from(
  //               licensesAndCertifications!.map((x) => x.toJson())),
  //       "soft_skills": softSkills == null
  //           ? []
  //           : List<dynamic>.from(softSkills!.map((x) => x)),
  //       "technical_skills": technicalSkills == null
  //           ? []
  //           : List<dynamic>.from(technicalSkills!.map((x) => x)),
  //       "honors_and_awards": honorsAndAwards == null
  //           ? []
  //           : List<dynamic>.from(honorsAndAwards!.map((x) => x.toJson())),
  //       "volunteer_experience": volunteerExperience == null
  //           ? []
  //           : List<dynamic>.from(volunteerExperience!.map((x) => x.toJson())),
  //       "support_people": supportPeople == null
  //           ? []
  //           : List<dynamic>.from(supportPeople!.map((x) => x)),
  //       "createdAt": createdAt?.toIso8601String(),
  //       "updatedAt": updatedAt?.toIso8601String(),
  //       "__v": v,
  //     };

  Map<String, dynamic> toJsonCreateResume() {
    bool isListEmptyOrContainsOnlyNulls(List<dynamic>? list) {
      return list == null ||
          list.isEmpty ||
          list.every((item) =>
              item == null ||
              (item is Map && item.values.every((value) => value == null)));
    }

    return {
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "address": address,
      "objective": objective?.toJson(),
      "experience": experience == null
          ? []
          : List<dynamic>.from(experience!.map((x) => x.toJson())),
      "education": isListEmptyOrContainsOnlyNulls(
              education?.map((e) => e.toJson()).toList())
          ? []
          : List<dynamic>.from(education!.map((x) => x.toJson())),
      "licenses_and_certifications": isListEmptyOrContainsOnlyNulls(
              licensesAndCertifications?.map((e) => e.toJson()).toList())
          ? []
          : List<dynamic>.from(
              licensesAndCertifications!.map((x) => x.toJson())),
      "soft_skills": isListEmptyOrContainsOnlyNulls(softSkills)
          ? []
          : List<dynamic>.from(softSkills!.map((x) => x)),
      "technical_skills": isListEmptyOrContainsOnlyNulls(technicalSkills)
          ? []
          : List<dynamic>.from(technicalSkills!.map((x) => x)),
      "honors_and_awards": honorsAndAwards == null
          ? []
          : List<dynamic>.from(honorsAndAwards!.map((x) => x.toJson())),
      "volunteer_experience": volunteerExperience == null
          ? []
          : List<dynamic>.from(volunteerExperience!.map((x) => x.toJson())),
    };
  }

  // Map<String, dynamic> toJsonEditResume() => {
  //       "resume_id": id,
  //       "full_name": fullName,
  //       "email": email,
  //       "phone": phone,
  //       "address": address,
  //       "objective": objective?.toJson(),
  //       "experience": experience == null
  //           ? []
  //           : List<dynamic>.from(experience!.map((x) => x.toJson())),
  //       "education": education == null
  //           ? []
  //           : List<dynamic>.from(education!.map((x) => x.toJson())),
  //       "licenses_and_certifications": licensesAndCertifications == null
  //           ? []
  //           : List<dynamic>.from(
  //               licensesAndCertifications!.map((x) => x.toJson())),
  //       "soft_skills": softSkills == null
  //           ? []
  //           : List<dynamic>.from(softSkills!.map((x) => x)),
  //       "technical_skills": technicalSkills == null
  //           ? []
  //           : List<dynamic>.from(technicalSkills!.map((x) => x)),
  //       "honors_and_awards": honorsAndAwards == null
  //           ? []
  //           : List<dynamic>.from(honorsAndAwards!.map((x) => x.toJson())),
  //       "volunteer_experience": volunteerExperience == null
  //           ? []
  //           : List<dynamic>.from(volunteerExperience!.map((x) => x.toJson())),
  //     };

  ///Use it
  Map<String, dynamic> toJsonEditResume() {
    bool isListEmptyOrContainsOnlyNulls(List<dynamic>? list) {
      return list == null ||
          list.isEmpty ||
          list.every((item) =>
              item == null ||
              (item is Map && item.values.every((value) => value == null)));
    }

    return {
      "resume_id": id,
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "address": address,
      "objective": objective?.toJson(),
      "experience": experience == null
          ? []
          : List<dynamic>.from(experience!.map((x) => x.toJson())),
      "education": isListEmptyOrContainsOnlyNulls(
              education?.map((e) => e.toJson()).toList())
          ? []
          : List<dynamic>.from(education!.map((x) => x.toJson())),
      "licenses_and_certifications": isListEmptyOrContainsOnlyNulls(
              licensesAndCertifications?.map((e) => e.toJson()).toList())
          ? []
          : List<dynamic>.from(
              licensesAndCertifications!.map((x) => x.toJson())),
      "soft_skills": isListEmptyOrContainsOnlyNulls(softSkills)
          ? []
          : List<dynamic>.from(softSkills!.map((x) => x)),
      "technical_skills": isListEmptyOrContainsOnlyNulls(technicalSkills)
          ? []
          : List<dynamic>.from(technicalSkills!.map((x) => x)),
      "honors_and_awards": honorsAndAwards == null
          ? []
          : List<dynamic>.from(honorsAndAwards!.map((x) => x.toJson())),
      "volunteer_experience": volunteerExperience == null
          ? []
          : List<dynamic>.from(volunteerExperience!.map((x) => x.toJson())),
    };
  }

  factory ResumeModel.initial() {
    return ResumeModel();
  }

  bool get isNull =>
      id == null &&
      userId == null &&
      fullName == null &&
      email == null &&
      phone == null &&
      address == null &&
      objective ==
          null /*&&
      (experience ?? []).isEmpty &&
      (education ?? []).isEmpty &&
      (licensesAndCertifications ?? []).isEmpty &&
      (softSkills ?? []).isEmpty &&
      (technicalSkills ?? []).isEmpty &&
      (supportPeople ?? []).isEmpty &&
      (honorsAndAwards ?? []).isEmpty*/
      ;
}

class Education {
  final String? institution;
  final String? degree;
  final String? fieldOfStudy;
  final int? startYear;
  final int? endYear;

  const Education({
    this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startYear,
    this.endYear,
  });

  Education copyWith({
    String? institution,
    String? degree,
    String? fieldOfStudy,
    int? startYear,
    int? endYear,
    String? description,
  }) =>
      Education(
          institution: institution ?? this.institution,
          degree: degree ?? this.degree,
          fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
          startYear: startYear ?? this.startYear,
          endYear: endYear ?? this.endYear);

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        institution: json["institution"],
        degree: json["degree"],
        fieldOfStudy: json["field_of_study"],
        startYear: json["start_year"],
        endYear: json["end_year"],
      );

  Map<String, dynamic> toJson() => {
        "institution": institution,
        "degree": degree,
        "field_of_study": fieldOfStudy,
        "start_year": startYear,
        "end_year": endYear,
        // "description": description,
      };
}

class Experience {
  final String? jobTitle;
  final String? company;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isChecked;
  final String? description;

  const Experience({
    this.jobTitle,
    this.company,
    this.startDate,
    this.endDate,
    this.description,
    this.isChecked = false,
  });

  Experience copyWith({
    String? jobTitle,
    String? company,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isChecked,
  }) {
    return Experience(
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        jobTitle: json["job_title"],
        company: json["company"],
        isChecked: json["end_date"] == null,
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "job_title": jobTitle,
        "company": company,
        "start_date": startDate?.toIso8601String(),
        "end_date": isChecked ? null : endDate?.toIso8601String(),
        "description": description,
      };
}

class HonorsAndAward {
  final String? awardName;
  final String? awardingOrganization;
  final DateTime? dateReceived;
  final String? description;

  const HonorsAndAward({
    this.awardName,
    this.awardingOrganization,
    this.dateReceived,
    this.description,
  });

  HonorsAndAward copyWith({
    String? awardName,
    String? awardingOrganization,
    DateTime? dateReceived,
    String? description,
  }) =>
      HonorsAndAward(
        awardName: awardName ?? this.awardName,
        awardingOrganization: awardingOrganization ?? this.awardingOrganization,
        dateReceived: dateReceived ?? this.dateReceived,
        description: description ?? this.description,
      );

  factory HonorsAndAward.fromJson(Map<String, dynamic> json) => HonorsAndAward(
        awardName: json["award_name"],
        awardingOrganization: json["awarding_organization"],
        dateReceived: json["date_Received"] == null
            ? null
            : DateTime.parse(json["date_Received"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "award_name": awardName,
        "awarding_organization": awardingOrganization,
        "date_Received": dateReceived?.toIso8601String(),
        "description": description,
      };
}

class LicensesAndCertification {
  final String? certificationName;
  final String? issuingOrganization;
  final DateTime? issueDate;
  final DateTime? expirationDate;

  const LicensesAndCertification({
    this.certificationName,
    this.issuingOrganization,
    this.issueDate,
    this.expirationDate,
  });

  LicensesAndCertification copyWith({
    String? certificationName,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expirationDate,
  }) =>
      LicensesAndCertification(
          certificationName: certificationName ?? this.certificationName,
          issuingOrganization: issuingOrganization ?? this.issuingOrganization,
          issueDate: issueDate ?? this.issueDate,
          expirationDate: expirationDate ?? this.expirationDate);

  factory LicensesAndCertification.fromJson(Map<String, dynamic> json) =>
      LicensesAndCertification(
        certificationName: json["certification_name"],
        issuingOrganization: json["issuing_organization"],
        issueDate: json["issue_date"] == null
            ? null
            : DateTime.parse(json["issue_date"]),
        expirationDate: json["expiration_date"] == null
            ? null
            : DateTime.parse(json["expiration_date"]),
      );

  Map<String, dynamic> toJson() => {
        "certification_name": certificationName,
        "issuing_organization": issuingOrganization,
        "issue_date": issueDate?.toIso8601String(),
        "expiration_date": expirationDate?.toIso8601String(),
      };
}

class Objective {
  final String? description;

  Objective({
    this.description,
  });

  Objective copyWith({
    String? description,
  }) =>
      Objective(
        description: description ?? this.description,
      );

  factory Objective.fromJson(Map<String, dynamic> json) => Objective(
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
      };
}

class VolunteerExperience {
  final String? organizationName;
  final String? role;
  final int? startYear;
  final int? endYear;
  final String? description;

  const VolunteerExperience({
    this.organizationName,
    this.role,
    this.startYear,
    this.endYear,
    this.description,
  });

  VolunteerExperience copyWith({
    String? organizationName,
    String? role,
    int? startYear,
    int? endYear,
    String? description,
  }) =>
      VolunteerExperience(
        organizationName: organizationName ?? this.organizationName,
        role: role ?? this.role,
        startYear: startYear ?? this.startYear,
        endYear: endYear ?? this.endYear,
        description: description ?? this.description,
      );

  factory VolunteerExperience.fromJson(Map<String, dynamic> json) =>
      VolunteerExperience(
        organizationName: json["organization_name"],
        role: json["role"],
        startYear: json["start_year"],
        endYear: json["end_year"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "organization_name": organizationName,
        "role": role,
        "start_year": startYear,
        "end_year": endYear,
        "description": description,
      };
}
