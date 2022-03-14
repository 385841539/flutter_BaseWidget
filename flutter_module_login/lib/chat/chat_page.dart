import 'package:flutter/material.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:flutter_module_login/chat/login_util.dart';
import 'package:flutter_module_login/chat/provide/SocketModel.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends BaseState<ChatPage, SocketModel> {
  int i=0;

  @override
  List<Widget> getMainChildrenWidget(BuildContext context) {
    return [
      RaisedButton(
        onPressed: () {
          ChatTestUtil.loginDemoAccount(context);
        },
        child: Text("先登录进入房间"),
      ),
      RaisedButton(
        onPressed: () {
          provide?.connectSocket();
        },
        child: Text("socket链接"),
      ),
      RaisedButton(
        onPressed: () {
          provide?.sendMessage("你好啊");
          provide?.sendMessage(i++);
          // model?.sendMessage(0.11);
          // model?.sendMessage(true);
          // model?.sendMessage(false);
        },
        child: Text("发送消息"),
      ),
      new Text(provide?.responseText ?? ""),
      // StreamBuilder(
      //   stream: model?.channel?.stream,
      //   builder: (context, snapshot) {
      //     //网络不通会走到这
      //     if (snapshot.hasError) {
      //       "网络不通..${snapshot.hashCode}.";
      //     } else if (snapshot.hasData) {
      //       "echo: " + snapshot.data;
      //     }
      //     return new Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 24.0),
      //       child: new Text("---"),
      //     );
      //   },
      // ),
      //
      // new StreamBuilder(
      //   stream: model?.channel?.stream,
      //   builder: (context, snapshot) {
      //     return ;
      //   },
      // )
    ];
  }

  @override
  Widget getMainWidget(BuildContext context) {
    return null;
  }

  @override
  BaseProvide registerProvide() {
    // TODO: implement registerProvide
    return SocketModel(context);
  }
}
