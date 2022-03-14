class ChatUserBean {
  Data data;
  bool success;
  int statusCode;

  ChatUserBean({this.data, this.success, this.statusCode});

  ChatUserBean.fromJson(Map<String, dynamic> json) {
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
  String id;
  String createdAt;
  String updatedAt;
  bool enabled;
  String name;
  String displayName;
  String gender;
  String mobilePhone;
  bool mobileVerify;
  String password;
  String avatar;
  String birthday;
  int age;
  String idNumber;
  String medicareCardNumber;
  String cardNumber;
  int cardLevel;
  int cardType;
  Null score;
  bool isRealPatient;
  int userId;
  String loginType;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.enabled,
        this.name,
        this.displayName,
        this.gender,
        this.mobilePhone,
        this.mobileVerify,
        this.password,
        this.avatar,
        this.birthday,
        this.age,
        this.idNumber,
        this.medicareCardNumber,
        this.cardNumber,
        this.cardLevel,
        this.cardType,
        this.score,
        this.isRealPatient,
        this.userId,
        this.loginType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    enabled = json['enabled'];
    name = json['name'];
    displayName = json['displayName'];
    gender = json['gender'];
    mobilePhone = json['mobilePhone'];
    mobileVerify = json['mobileVerify'];
    password = json['password'];
    avatar = json['avatar'];
    birthday = json['birthday'];
    age = json['age'];
    idNumber = json['idNumber'];
    medicareCardNumber = json['medicareCardNumber'];
    cardNumber = json['cardNumber'];
    cardLevel = json['cardLevel'];
    cardType = json['cardType'];
    score = json['score'];
    isRealPatient = json['isRealPatient'];
    userId = json['userId'];
    loginType = json['loginType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['enabled'] = this.enabled;
    data['name'] = this.name;
    data['displayName'] = this.displayName;
    data['gender'] = this.gender;
    data['mobilePhone'] = this.mobilePhone;
    data['mobileVerify'] = this.mobileVerify;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['birthday'] = this.birthday;
    data['age'] = this.age;
    data['idNumber'] = this.idNumber;
    data['medicareCardNumber'] = this.medicareCardNumber;
    data['cardNumber'] = this.cardNumber;
    data['cardLevel'] = this.cardLevel;
    data['cardType'] = this.cardType;
    data['score'] = this.score;
    data['isRealPatient'] = this.isRealPatient;
    data['userId'] = this.userId;
    data['loginType'] = this.loginType;
    return data;
  }
}
