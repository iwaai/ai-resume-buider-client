// models/resume_data_model.dart
import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String linkedIn;
  final String github;
  final String portfolio;
  final String twitter;
  final String instagram;
  final String behance;
  final String dribbble;
  final List<String> otherLinks;

  const PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.linkedIn = '',
    this.github = '',
    this.portfolio = '',
    this.twitter = '',
    this.instagram = '',
    this.behance = '',
    this.dribbble = '',
    this.otherLinks = const [],
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      linkedIn: json['linkedIn'] ?? '',
      github: json['github'] ?? '',
      portfolio: json['portfolio'] ?? '',
      twitter: json['twitter'] ?? '',
      instagram: json['instagram'] ?? '',
      behance: json['behance'] ?? '',
      dribbble: json['dribbble'] ?? '',
      otherLinks: List<String>.from(json['otherLinks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'linkedIn': linkedIn,
      'github': github,
      'portfolio': portfolio,
      'twitter': twitter,
      'instagram': instagram,
      'behance': behance,
      'dribbble': dribbble,
      'otherLinks': otherLinks,
    };
  }

  @override
  List<Object> get props => [
        fullName,
        email,
        phone,
        address,
        linkedIn,
        github,
        portfolio,
        twitter,
        instagram,
        behance,
        dribbble,
        otherLinks
      ];
}

class Experience extends Equatable {
  final String company;
  final String position;
  final String duration;
  final String description;
  final List<String> achievements;
  final String location;

  const Experience({
    required this.company,
    required this.position,
    required this.duration,
    required this.description,
    required this.achievements,
    this.location = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      achievements: List<String>.from(json['achievements'] ?? []),
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'duration': duration,
      'description': description,
      'achievements': achievements,
      'location': location,
    };
  }

  @override
  List<Object> get props =>
      [company, position, duration, description, achievements, location];
}

class Education extends Equatable {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String graduationYear;
  final String gpa;
  final String location;
  final List<String> achievements;

  const Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.gpa = '',
    this.location = '',
    this.achievements = const [],
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      graduationYear: json['graduationYear'] ?? '',
      gpa: json['gpa'] ?? '',
      location: json['location'] ?? '',
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'graduationYear': graduationYear,
      'gpa': gpa,
      'location': location,
      'achievements': achievements,
    };
  }

  @override
  List<Object> get props => [
        institution,
        degree,
        fieldOfStudy,
        graduationYear,
        gpa,
        location,
        achievements
      ];
}

class Project extends Equatable {
  final String title;
  final String description;
  final String duration;
  final List<String> technologies;
  final String githubLink;
  final String liveLink;
  final List<String> features;

  const Project({
    required this.title,
    required this.description,
    this.duration = '',
    this.technologies = const [],
    this.githubLink = '',
    this.liveLink = '',
    this.features = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      githubLink: json['githubLink'] ?? '',
      liveLink: json['liveLink'] ?? '',
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'technologies': technologies,
      'githubLink': githubLink,
      'liveLink': liveLink,
      'features': features,
    };
  }

  @override
  List<Object> get props => [
        title,
        description,
        duration,
        technologies,
        githubLink,
        liveLink,
        features
      ];
}

class Award extends Equatable {
  final String title;
  final String organization;
  final String year;
  final String description;

  const Award({
    required this.title,
    required this.organization,
    required this.year,
    this.description = '',
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      year: json['year'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'organization': organization,
      'year': year,
      'description': description,
    };
  }

  @override
  List<Object> get props => [title, organization, year, description];
}

class Language extends Equatable {
  final String name;
  final String proficiency;

  const Language({
    required this.name,
    this.proficiency = '',
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proficiency': proficiency,
    };
  }

  @override
  List<Object> get props => [name, proficiency];
}

class ResumeData extends Equatable {
  final PersonalInfo personalInfo;
  final String summary;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> skills;
  final List<String> certifications;
  final List<Language> languages;
  final List<Project> projects;
  final List<Award> awards;
  final List<String> hobbies;
  final List<String> references;

  const ResumeData({
    required this.personalInfo,
    required this.summary,
    required this.experience,
    required this.education,
    required this.skills,
    required this.certifications,
    required this.languages,
    required this.projects,
    required this.awards,
    required this.hobbies,
    required this.references,
  });

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      summary: json['summary'] ?? '',
      experience: (json['experience'] as List?)
              ?.map((e) => Experience.fromJson(e))
              .toList() ??
          [],
      education: (json['education'] as List?)
              ?.map((e) => Education.fromJson(e))
              .toList() ??
          [],
      skills: List<String>.from(json['skills'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      languages: (json['languages'] as List?)
              ?.map((e) => Language.fromJson(e))
              .toList() ??
          [],
      projects: (json['projects'] as List?)
              ?.map((e) => Project.fromJson(e))
              .toList() ??
          [],
      awards:
          (json['awards'] as List?)?.map((e) => Award.fromJson(e)).toList() ??
              [],
      hobbies: List<String>.from(json['hobbies'] ?? []),
      references: List<String>.from(json['references'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'summary': summary,
      'experience': experience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'skills': skills,
      'certifications': certifications,
      'languages': languages.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'awards': awards.map((e) => e.toJson()).toList(),
      'hobbies': hobbies,
      'references': references,
    };
  }

  @override
  List<Object> get props => [
        personalInfo,
        summary,
        experience,
        education,
        skills,
        certifications,
        languages,
        projects,
        awards,
        hobbies,
        references
      ];
}
