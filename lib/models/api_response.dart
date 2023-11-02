

ApiResponse apiResponse(Map<String, dynamic> jsonData) {
  return ApiResponse.fromJson(jsonData);
}

class ApiResponse {
  ApiResponse({required this.message, this.data});

  late final String message;
  late final String? data;

  ApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["message"] = message;
    data["data"] = data;

    return data;
  }
}
