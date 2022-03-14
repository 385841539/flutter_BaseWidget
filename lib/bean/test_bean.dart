class TestResult {
  int code;
  String msg;
  Result result;

  TestResult({this.code, this.msg, this.result});

  TestResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String title;
  int integral;
  String date;

  Result({this.title, this.integral, this.date});

  Result.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    integral = json['integral'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['integral'] = this.integral;
    data['date'] = this.date;
    return data;
  }
}
