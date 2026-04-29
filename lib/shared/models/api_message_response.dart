class ApiMessageResponse {
  const ApiMessageResponse({required this.message});

  final String message;

  factory ApiMessageResponse.fromJson(Map<String, dynamic> json) {
    return ApiMessageResponse(message: json['message'] as String? ?? '');
  }
}
