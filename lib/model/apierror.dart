import 'dart:ui';

class APIError {
  String error;
  dynamic message;
  int status;
  VoidCallback onAlertPop;

  APIError({this.error, this.status, this.message, this.onAlertPop});

  APIError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}
