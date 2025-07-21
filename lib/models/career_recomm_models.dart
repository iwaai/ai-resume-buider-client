class CareerRecommendation {
  final String recommendationId;
  final String? favoriteID;
  final DateTime createdAt;
  final List<CareerPoint> careers;
  final bool isFavorite;

  CareerRecommendation({
    required this.recommendationId,
    required this.createdAt,
    this.favoriteID,
    required this.careers,
    required this.isFavorite,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      recommendationId: json['recommendationId'],
      createdAt: DateTime.parse(json['createdAt']),
      careers: (json['careers'] as List?)
              ?.map((e) => CareerPoint.fromJson(e))
              .toList() ??
          [],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendationId': recommendationId,
      'createdAt': createdAt.toIso8601String(),
      'careers': careers.map((e) => e.toJson()).toList(),
      'is_favorite': isFavorite,
    };
  }

  CareerRecommendation copyWith({
    String? recommendationId,
    String? favoriteID,
    DateTime? createdAt,
    List<CareerPoint>? careers,
    bool? isFavorite,
  }) {
    return CareerRecommendation(
      favoriteID: favoriteID ?? this.favoriteID,
      recommendationId: recommendationId ?? this.recommendationId,
      createdAt: createdAt ?? this.createdAt,
      careers: careers ?? this.careers,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory CareerRecommendation.initial() {
    return CareerRecommendation(
      recommendationId: '',
      createdAt: DateTime.now(),
      careers: [],
      isFavorite: false,
    );
  }
}

class CareerPoint {
  final Career career;
  final int point;
  final bool isFavorite;

  CareerPoint({
    required this.career,
    required this.point,
    required this.isFavorite,
  });

  factory CareerPoint.fromJson(Map<String, dynamic> json) {
    return CareerPoint(
      career: Career.fromJson(json['career']),
      point: json['point'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'career': career.toJson(),
      'point': point,
      'is_favorite': isFavorite,
    };
  }

  factory CareerPoint.initial() {
    return CareerPoint(
      point: 0,
      career: Career.initial(),
      isFavorite: false,
    );
  }

  CareerPoint copyWith({
    int? point,
    Career? career,
    bool? isFavorite,
  }) {
    return CareerPoint(
      point: point ?? this.point,
      career: career ?? this.career,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Career {
  final String id;
  final String name;
  final String? description;
  final List<String> sampleJobTitles;
  final List<String> careerPathways;
  final List<String> educationTraining;
  final String? careerGrowthOpportunities;
  final String? careerLink;

  Career({
    required this.id,
    required this.name,
    this.description,
    required this.sampleJobTitles,
    required this.careerPathways,
    required this.educationTraining,
    this.careerGrowthOpportunities,
    this.careerLink,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      sampleJobTitles: (json['sample_job_titles'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      careerPathways: (json['career_pathways'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      educationTraining: (json['education_training'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      careerGrowthOpportunities: json['career_growth_opportunities'],
      careerLink: json['career_link'],
    );
  }

  factory Career.fromFavJson(Map<String, dynamic> json) {
    return Career(
      id: json['_id'],
      name: json['career_name'],
      description: json['description'],
      sampleJobTitles: (json['sample_job_titles'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      careerPathways: (json['career_pathways'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      educationTraining: (json['education_training'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      careerGrowthOpportunities: json['career_growth_opportunities'],
      careerLink: json['career_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sample_job_titles': sampleJobTitles,
      'career_pathways': careerPathways,
      'education_training': educationTraining,
      'career_growth_opportunities': careerGrowthOpportunities,
      'career_link': careerLink,
    };
  }

  factory Career.initial() {
    return Career(
      id: 'init',
      name: 'Initial Career',
      description: 'Initial Career Description',
      sampleJobTitles: ['Sample Job Title 1', 'Sample Job Title 2'],
      careerPathways: ['Career Pathway 1', 'Career Pathway 2'],
      educationTraining: ['Education Training 1', 'Education Training 2'],
      careerGrowthOpportunities: 'Career Growth Opportunities',
      careerLink: 'Career Link',
    );
  }
}

class FavoriteCareer {
  final String id;
  final String recommendationId;
  final List<Career> careers;
  final DateTime createdAt;

  FavoriteCareer({
    required this.id,
    required this.recommendationId,
    required this.careers,
    required this.createdAt,
  });

  factory FavoriteCareer.fromJson(Map<String, dynamic> json) {
    return FavoriteCareer(
      id: json['_id'],
      recommendationId: json['recommendationId'],
      careers:
          (json['careers'] as List).map((e) => Career.fromFavJson(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recommendationId': recommendationId,
      'careers': careers.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  FavoriteCareer copyWith({
    String? id,
    String? recommendationId,
    List<Career>? careers,
    DateTime? createdAt,
  }) {
    return FavoriteCareer(
      id: id ?? this.id,
      recommendationId: recommendationId ?? this.recommendationId,
      careers: careers ?? this.careers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FavoriteCareer.initial() {
    return FavoriteCareer(
      id: '',
      recommendationId: '',
      careers: [],
      createdAt: DateTime.now(),
    );
  }

  CareerRecommendation toCareerRecommendation() {
    return CareerRecommendation(
      recommendationId: recommendationId,
      favoriteID: id,
      createdAt: createdAt,
      isFavorite: true,
      careers: careers.map((careerInfo) {
        return CareerPoint(
          isFavorite: true,
          career: Career(
            careerGrowthOpportunities: careerInfo.careerGrowthOpportunities,
            careerLink: careerInfo.careerLink,
            description: careerInfo.description,
            careerPathways: careerInfo.careerPathways,
            educationTraining: careerInfo.educationTraining,
            sampleJobTitles: careerInfo.sampleJobTitles,
            id: careerInfo.id,
            name: careerInfo.name,
          ),
          point: 0,
        );
      }).toList(),
    );
  }
}

class CareerRecommQuestion {
  final String id;
  final String question;

  CareerRecommQuestion({
    required this.id,
    required this.question,
  });

  factory CareerRecommQuestion.fromJson(Map<String, dynamic> json) {
    return CareerRecommQuestion(
      id: json['_id'] as String,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
    };
  }

  CareerRecommQuestion copyWith({String? id, String? question}) {
    return CareerRecommQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
    );
  }
}
