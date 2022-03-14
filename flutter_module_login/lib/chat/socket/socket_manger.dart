// import 'package:adhara_socket_io/adhara_socket_io.dart';
// import 'package:event_bus/event_bus.dart';
// import 'package:flutter_common_plugin/base_lib.dart';
// import 'package:flutter_module_login/chat/chat_host.dart';
//
// class SocketUtils {
//   static SocketIOManager manager;
//   static SocketIO socket;
//
//   // static EventBus eventBus;
//   static Future socketTo() async {
//     // eventBus=EventBus();
//     print('登录IM');
//     manager = SocketIOManager();
//     //该部分需要根据自己实际业务实现
//     String token = "";
//     // await SPUtils.getToken();
//     print(token);
//     // if (token != null) {
//     //   token = token.substring(7);
//     // }
//     print(token);
//     //配置socket链接信息
//     SocketOptions socketOptions = new SocketOptions(
//       "http://192.168.2.4:8011",
//       // "http://172.25.62.182:12020",
//       // ChatHost.SOCKET_URL,
//       // query: {
//       //   'token': token,
//       //   'source': 'CONSULTANT',
//       // },
//       transports: [Transports.WEB_SOCKET, Transports.POLLING],
//       enableLogging: true,
//     );
//     socket = await manager.createInstance(socketOptions)
//     //     .then((value) {
//     //   print("---value--$value");
//     // })
//         .catchError((err) {
//       print("--err--1$err---${err.toString()}");
//     });
//     socket.onConnect((res) {
//       print('onConnect--------socket链接成功---------');
//       getRooms();
//     });
//     socket.onError((data) {
//       print("error---${data.toString()}===$data");
//     });
//     socket.on('connect', (res) {
//       print('connect----------');
//     });
//     //房间列表
//     socket.on('rooms', (rooms) {
//       // eventBus.fire(new ResultEvent(rooms));
//     });
//     //消息历史
//     socket.on('history', (data) {
//       logger.e('消息历史:' + data.toString());
//       // eventBus.fire(new MsgHistoryResultEvent(data));
//     });
//     socket.on('delete', (data) {
//       print('消息删除delete：' + data.toString());
//     });
//     socket.on('message', (data) {
//       print('新消息：' + data.toString());
//       // eventBus.fire(new MessageEvent(data));
//     });
//     socket.connect();
//   }
//
// //下面是客户端发送数据包
//   //获取会话列表
//   static getRooms() {
//     print("-getRooms--");
//     if (socket != null) {
//       print('获取会话列表');
//       socket.emit('rooms', []);
//     }
//   }
// // //发送消息
// //   static sendMsg(MessageBean messageBean) {
// //     //实时更新到聊天界面
// //     eventBus.fire(messageBean);
// //     if (socket != null) {
// //       socket.emit('sendMessage', [
// //           {
// //           'msg': messageBean.msg
// //           }
// //       }
// //           ]);
// //     }
// // }
//
// }
