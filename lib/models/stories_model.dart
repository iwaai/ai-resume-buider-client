class StoryModel {
  String? sId;
  String? name;
  String? profileImg;
  String? profession;
  String? profession2;
  String? currentProfession;
  String? education;
  String? experience;
  String? mostValuableTransferableSkill;
  String? pieceOfAdvice;
  String? youtubeLink;
  String? linkedIn;
  List<String>? careerRecommendations;
  String? school; // ✅ New field
  String? createdAt;
  String? updatedAt;
  int? iV;

  StoryModel({
    this.sId,
    this.name,
    this.profileImg,
    this.profession,
    this.profession2,
    this.currentProfession,
    this.education,
    this.experience,
    this.mostValuableTransferableSkill,
    this.pieceOfAdvice,
    this.youtubeLink,
    this.linkedIn,
    this.careerRecommendations,
    this.school, // ✅ Constructor
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  StoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImg = json['profile_img'];
    profession = json['profession'];
    profession2 = json['profession2'];
    currentProfession = json['current_profession'];
    education = json['education'];
    experience = json['experience'];
    mostValuableTransferableSkill = json['most_valuable_transferable_skill'];
    pieceOfAdvice = json['piece_of_advice'];
    youtubeLink = json['youtube_link'];
    linkedIn = json['linkedin_profile'];
    careerRecommendations = json['career_recommendations']?.cast<String>();
    school = json['school'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profile_img'] = profileImg;
    data['profession'] = profession;
    data['profession2'] = profession2;
    data['current_profession'] = currentProfession;
    data['education'] = education;
    data['experience'] = experience;
    data['most_valuable_transferable_skill'] = mostValuableTransferableSkill;
    data['piece_of_advice'] = pieceOfAdvice;
    data['youtube_link'] = youtubeLink;
    data['linkedin_profile'] = linkedIn;
    data['career_recommendations'] = careerRecommendations;
    data['school'] = school;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
