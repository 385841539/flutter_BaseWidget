class FBIDCheck {
  // 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      print(tip);
      pass = false;
      return pass;
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      print(tip);
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        print(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      print(tip);
      pass = false;
    }
//  print('证件格式$pass');
    return pass;
  }

// 根据身份证号获取年龄
  static int getAgeFromCardId(String cardId) {
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return -1;
    }
    int len = (cardId + "").length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = cardId.substring(6, 10) +
          "-" +
          cardId.substring(10, 12) +
          "-" +
          cardId.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          cardId.substring(6, 8) +
          "-" +
          cardId.substring(8, 10) +
          "-" +
          cardId.substring(10, 12);
    }
    int age = getAgeFromBirthday(strBirthday);
    return age;
  }

  ///返回身份证 出生日期
  static String getBirthDayFromCardId(String cardId) {
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return "";
    }

    int len = (cardId + "").length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = cardId.substring(6, 10) +
          "-" +
          cardId.substring(10, 12) +
          "-" +
          cardId.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          cardId.substring(6, 8) +
          "-" +
          cardId.substring(8, 10) +
          "-" +
          cardId.substring(10, 12);
    }

    return strBirthday;
  }

// 根据出生日期获取年龄
  static int getAgeFromBirthday(String strBirthday) {
    if (strBirthday == null || strBirthday.isEmpty) {
      print('生日错误');
      return -1;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

// 根据身份证获取性别
  static String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }
}
