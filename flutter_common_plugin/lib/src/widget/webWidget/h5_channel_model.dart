///通信 模型
class ChannelModel {
  String route;
  Map<String, dynamic> params;

  ChannelModel({this.route, this.params});

  ChannelModel.fromJson(Map<String, dynamic> json) {
    route = json['route'];
    params = json['params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route'] = this.route;
    if (this.params != null) {
      data['params'] = this.params;
    }
    return data;
  }
}
