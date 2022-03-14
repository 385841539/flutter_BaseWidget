class ChatLoginBean {
  Data data;
  bool success;
  int statusCode;

  ChatLoginBean({this.data, this.success, this.statusCode});

  ChatLoginBean.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class Data {
  String expiresIn;
  String token;

  Data({this.expiresIn, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    expiresIn = json['expiresIn'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiresIn'] = this.expiresIn;
    data['token'] = this.token;
    return data;
  }
}
