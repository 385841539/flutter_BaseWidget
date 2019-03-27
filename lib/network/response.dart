class BaseResponse {
  bool error;

  BaseResponse({this.error});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    this.error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}
