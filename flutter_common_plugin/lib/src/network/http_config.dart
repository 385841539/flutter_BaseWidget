class HttpConfig {
  static String baseUrl;
  static String contentType = "application/json";
  static int connectTimeOut = 1000 * 10;
  static int receiveTimeOut = 1000 * 10;
}

class ResponseErrCode {
  static const int ERR_CANCEL = -1;
  static const int ERR_CONNECT_TIME_OUT = -401;
  static const int ERR_RECEIVER_TIME_OUT = -402;
  static const int ERR_DATA_FORMAT = -403; //数据解析错误
  static const int ERR_UN_KNOW = -399; //未知错误
}

enum FBResultFul { POST, GET, DELETE, PATCH, PUT }
