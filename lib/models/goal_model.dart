import 'package:second_shot/utils/constants/constant.dart';

class CreateGoalModel {
  String? goalId;
  dynamic mainGoalName;
  String? deadline;
  List<SubGoals>? subGoals;
  List<SupportPeople>? supportPeople;
  String? status;
  String? subGoalStatus;
  String? createdAt;

  CreateGoalModel(
      {this.mainGoalName,
      this.deadline,
      this.subGoals,
      this.supportPeople,
      this.subGoalStatus,
      this.status,
      this.createdAt,
      this.goalId});
  CreateGoalModel.fromJson(Map<String, dynamic> json) {
    mainGoalName = json['main_goal_name'];
    deadline = json['deadline'];
    if (json['sub_goals'] != null) {
      subGoals = <SubGoals>[];
      json['sub_goals'].forEach((v) {
        subGoals!.add(SubGoals.fromJson(v));
      });
    }
    if (json['support_people'] != null) {
      supportPeople = <SupportPeople>[];
      json['support_people'].forEach((v) {
        supportPeople!.add(SupportPeople.fromJson(v));
      });
    }
    status = json['status'];
    subGoalStatus = json['sub_goal_status'];
    createdAt = json['createdAt'];
    goalId = json['_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (goalId != null) data['_id'] = goalId;
    data['main_goal_name'] = mainGoalName;
    data['deadline'] = deadline;
    if (subGoals != null) {
      data['sub_goals'] = subGoals!.map((v) => v.toJson()).toList();
    }
    if (supportPeople != null) {
      data['support_people'] = supportPeople!.map((v) => v.toJson()).toList();
    }
    if (status != null) data['status'] = status;
    if (subGoalStatus != null) data['sub_goal_status'] = subGoalStatus;
    if (createdAt != null) data['createdAt'] = createdAt;

    return data;
  }

  CreateGoalModel copyWith({
    String? mainGoalName,
    String? deadline,
    String? subGoalStatus,
    List<SubGoals>? subGoals,
    List<SupportPeople>? supportPeople,
    String? status,
    String? createdAt,
    String? goalId,
  }) {
    return CreateGoalModel(
        mainGoalName: mainGoalName ?? this.mainGoalName,
        deadline: deadline ?? this.deadline,
        subGoals: subGoals ?? this.subGoals,
        supportPeople: supportPeople ?? this.supportPeople,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        goalId: goalId ?? this.goalId,
        subGoalStatus: subGoalStatus ?? this.subGoalStatus);
  }
}

class SubGoals {
  String? name;
  DateTime? deadline;
  bool? isCompleted;
  String? id;

  SubGoals({this.name, this.deadline, this.isCompleted, this.id});

  SubGoals.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    deadline =
        json['deadline'] != null ? DateTime.parse(json['deadline']) : null;
    isCompleted = json['is_completed'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (deadline != null) {
      data['deadline'] = deadline!.toUtc().toIso8601String();
    }
    if (isCompleted != null) data['is_completed'] = isCompleted;
    if (id != null) data['_id'] = id;

    return data;
  }

  SubGoals copyWith(
      {String? name, DateTime? deadline, bool? isCompleted, String? id}) {
    return SubGoals(
      name: name ?? this.name,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted,
      id: id ?? this.id,
    );
  }
}

class SupportPeople {
  String? fullName;
  String? emailAddress;
  String? phoneNumber;

  SupportPeople(
      {this.fullName, this.emailAddress, this.phoneNumber = "(123) 456-7890"});

  SupportPeople.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    emailAddress = json['email_address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['email_address'] = emailAddress;
    data['phone_number'] = sanitizePhoneNumber(phoneNumber.toString());
    return data;
  }

  SupportPeople copyWith({
    String? fullName,
    String? emailAddress,
    String? phoneNumber,
  }) {
    return SupportPeople(
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
