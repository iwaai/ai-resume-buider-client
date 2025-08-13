class AwardQuestionModel {
  final String? id;
  final String? question;
  final int? questionNo;
  final DateTime? createdAt;
  final String? image;
  final String? title;
  final String? subTitle;
  final String? singleAnswer;
  final List<String>? listAnswer;
  final String? dialoDescription;
  final String? description2;

  AwardQuestionModel(
      {this.id,
      this.question,
      this.questionNo,
      this.createdAt,
      this.image,
      this.title,
      this.subTitle,
      this.singleAnswer,
      this.listAnswer,
      this.dialoDescription,
      this.description2});

  factory AwardQuestionModel.fromJson(Map<String, dynamic> json) =>
      AwardQuestionModel(
        id: json["_id"],
        question: json["question"],
        questionNo: json["question_no"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJsonUpdateModel(AwardQuestionModel model) {
    return {
      'questionId': model.id,
      'answer': model.listAnswer ?? model.singleAnswer,
    };
  }

  AwardQuestionModel copyWith(
      {String? id,
      String? question,
      int? questionNo,
      DateTime? createdAt,
      String? image,
      String? title,
      String? subTitle,
      String? singleAnswer,
      List<String>? listAnswer,
      String? dialoDescription,
      String? answer}) {
    return AwardQuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      questionNo: questionNo ?? this.questionNo,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      singleAnswer: singleAnswer,
      listAnswer: listAnswer,
      dialoDescription: dialoDescription ?? this.dialoDescription,
      description2: answer ?? this.description2,
    );
  }
}
