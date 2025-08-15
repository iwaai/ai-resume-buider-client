import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  bool success;
  String? message;
  String? error;  // New error field
  dynamic data;
  Pagination? pagination;

  ApiResponse({
    this.success = false,
    this.message,
    this.error,  // Include error in constructor
    this.data,
    this.pagination,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json["success"] ?? false,
        message: json["message"],
        error: json["error"],  // Parse the error field
        data: json["data"],
        pagination: json['pagination'] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "error": error,  // Include error in the output JSON
        "data": data,
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  final dynamic currentPage;
  final dynamic totalPages;
  final dynamic totalItems;

  Pagination(
      {required this.currentPage,
      required this.totalPages,
      required this.totalItems});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
        currentPage: json['currentPage'],
        totalPages: json['totalPages'],
        totalItems: json['totalItems']);
  }

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
      };
}
