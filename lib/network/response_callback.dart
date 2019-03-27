import 'package:flutter_base_widget/network/response.dart';

typedef void Success<T extends BaseResponse>(T data);
typedef void Failed(int code, String errorMsg);

//abstract class IpAction {
//  void getIpDetail(String id, Success<IpDetail> onSuccess, Failed onFailed);
//}
