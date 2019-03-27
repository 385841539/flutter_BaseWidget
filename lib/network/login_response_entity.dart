class LoginResponseEntity {
  bool error;
  List<LoginResponseResult> results;

  LoginResponseEntity({this.error, this.results});

  LoginResponseEntity.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['results'] != null) {
      results = new List<LoginResponseResult>();
      (json['results'] as List).forEach((v) {
        results.add(new LoginResponseResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginResponseResult {
  String icon;
  String createdAt;
  String sId;
  String id;
  String title;

  LoginResponseResult(
      {this.icon, this.createdAt, this.sId, this.id, this.title});

  LoginResponseResult.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    createdAt = json['created_at'];
    sId = json['_id'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
