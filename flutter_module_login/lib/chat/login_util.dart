import 'package:flutter/cupertino.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/chat/global/globals.dart';
import 'package:flutter_module_login/chat/longconnection/chatroom/chat_room_plugin.dart';
import 'package:flutter_module_login/chat/longconnection/long_connection.dart';

import 'chat_host.dart';
import 'global/global_shared_info.dart';
import 'model/chat_login_bean.dart';
import 'model/login_model.dart';

class ChatTestUtil {
  static void loginDemoAccount(BuildContext context) async {
    Map params = Map();
    // '417833': '33eb0109fe10402f9f9f60bd555ef9ce'
    params['mobilePhone'] = "417833";
    params['password'] = "33eb0109fe10402f9f9f60bd555ef9ce";
    // BaseResponseEntity entity =
    //     await DioHttp.postRequest(Urls.PATIENTS_LOGIN, params: params);
    // if (entity.success && entity.data != null) {
    //   GlobalSharedInfo.token = entity.data['token'];
    //   _judgeRegister();
    //   _setupLongConnection();
    // } else {
    //   Fluttertoast.showToast(msg: "登录失败" + entity.statusCode.toString());
    // }
    GlobalSharedInfo.token = "";
    FBHttpUtil.post(context, ChatHost.PATIENTS_LOGIN, params: params)
        .then((value) async {
      ChatLoginBean chatLoginBean = ChatLoginBean.fromJson(value);
      GlobalSharedInfo.token = chatLoginBean.data.token;
      print("--value--$value");
      await getUserInfo(context);

    }).catchError((e) {
      print("--e:$e");
      FBToastUtils.show(e.toString());
    });
  }

  static getUserInfo(BuildContext context) async {
    var userInfo = await FBHttpUtil.get(context, ChatHost.PATIENT_INFO);

    print("userInfo---$userInfo");

    ChatUserBean chatBean=ChatUserBean.fromJson(userInfo);
    GlobalSharedInfo.userId=chatBean.data.id;
    _setupLongConnection();
  }

  static _setupLongConnection() async {

    // if (Globals.longConnection == null || Globals.chatRoomPlugin == null) {
    //   final identity = LongConnectionIdentity(
    //       GlobalSharedInfo.token, GlobalSharedInfo.userId);
    //   Globals.longConnection =
    //       new LongConnection(ChatHost.SOCKET_URL, identity);
    //   Globals.chatRoomPlugin = new ChatRoomPlugin();
    //
    //   // Globals.longConnection.addPlugin(Globals.webRTCPlugin);
    //   Globals.longConnection.addPlugin(Globals.chatRoomPlugin);
    //
    //   Globals.longConnection.connect();
    // }
  }
}
