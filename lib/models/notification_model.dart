class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String notificationType;
  bool isRead;
  final DateTime createdAt;
  final String? goalId;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
    this.goalId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      message: json["message"],
      notificationType: json["notification_type"],
      isRead: json["is_read"],
      createdAt: DateTime.parse(json["createdAt"]),
      goalId: json['data'] is Map
          ? (json["data"] as Map).values.toList()[0]
          : null, // Handling nested goalId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "title": title,
      "message": message,
      "notification_type": notificationType,
      "is_read": isRead,
      "createdAt": createdAt.toIso8601String(),
      "data": goalId != null ? {"goalId": goalId} : null,
    };
  }
}
