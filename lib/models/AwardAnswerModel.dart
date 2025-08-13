class AwardAnswerModel {
  final Question? question;
  final List<String>? listAnswer;
  final String? singleAnswer;
  final bool isListAnswer;

  AwardAnswerModel({
    this.question,
    this.listAnswer,
    this.singleAnswer,
    this.isListAnswer = false,
  });

  factory AwardAnswerModel.fromJsonListAnswer(Map<String, dynamic> json) => AwardAnswerModel(
    question: json["question"] == null ? null : Question.fromJson(json["question"]),
    listAnswer: json["answer"] == null ? [] : List<String>.from(json["answer"]!.map((x) => x)),
  );
  factory AwardAnswerModel.fromJsonSingleAnswer(Map<String, dynamic> json) => AwardAnswerModel(
    question: json["question"] == null ? null : Question.fromJson(json["question"]),
    singleAnswer: json["answer"]
  );
  // Map<String, dynamic> toJson() => {
  //   "question": question?.toJson(),
  //   "answer": listAnswer == null ? [] : List<dynamic>.from(listAnswer!.map((x) => x)),
  //   "answer2": singleAnswer,
  // };
}

class Question {
  final String? id;
  final String? question;

  Question({
    this.id,
    this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["_id"],
    question: json["question"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "question": question,
  };
}
