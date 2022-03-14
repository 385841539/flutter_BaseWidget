import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_common_plugin/base_lib.dart';
import 'package:web_socket_channel/io.dart';


class SocketModel extends BaseProvide {

  String host;
  int port;
  BuildContext context;


  int packageLen;

  IOWebSocketChannel channel;

  String responseText;

  Socket mSocket;

  SocketModel(this.context) {
    // SocketManage.initSocket();
    // SocketUtils.socketTo();
  }

  @override
  Future requestData() {
    // TODO: 页面所需请求
  }

  void connectSocket() async {
    print("---开始链接:---");
    connectWebSocket();

    // connectOriWebSocket();
    //
    // runZoned(() async {
    //   var server = await HttpServer.bind('127.0.0.1', 8090);
    //   server.listen((HttpRequest req) async {
    //     if (req.uri.path == '/ws') {
    //       var socket = await WebSocketTransformer.upgrade(req);
    //       socket.listen(handleMsg);
    //     }
    //   });
    // }, onError: (e) => print("An error occurred."));
    //
    // var socket = await WebSocket.connect('ws://127.0.0.1:8090/ws');
    // socket.add('Hello, World!');
    //
    //

    // Socket.connect('127.0.0.1', 8081).then((socket) {
    //   socket.write('Hello, World!');
    // });
    // connectSocketTest("192.168.2.4", 8881);
  }

  void handleMsg(event) {}

  ///https://www.jianshu.com/p/86e1d1b54be5
  void connectSocketTest(String host, int port) async {
    this.host = host;
    this.port = port;
    try {
      await Socket.connect(host, port, timeout: Duration(seconds: 5))
          .then((socket) {
        // ignore: missing_return
        mSocket = socket;
        print('---------连接成功------------$mSocket');

        // socket.listen(_receivedMsgHandler,
        //     onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
        socket.listen((event) {},
            onError: (Object e, StackTrace trace) {}, onDone: () {});

        sendMessage("你好啊");
      });
    } catch (e) {
      print("连接socket出现异常，e=${e.toString()}");
    }
  }

  void sendMessage(dynamic message) {
    print(
        "---channel---sink--null--${channel == null}--${channel?.sink == null}");
    channel?.sink?.add("$message");
    // mSocket.add(("$message" + "EOF").codeUnits);
    // mSocket.flush();
  }

//存放子数据
  List<int> mutableData = List<int>();

  // void _receivedMsgHandler(Uint8List data){
  //   //
  //   // mutableData.addAll(data);
  //   // while(true){
  //   //   packageLen = _getPackageLength(mutableData);
  //   //   if(mutableData.length - 4 >= packageLen){
  //   //     // if(getMessageData != null){
  //   //     //   getMessageData(Uint8List.fromList(mutableData));
  //   //     // }
  //   //     if(mutableData == null){break;}
  //   //     //清空处理过的数据流
  //   //     mutableData?.replaceRange(0, packageLen+4, []);
  //   //     packageLen = 0;
  //   //     if(mutableData.length < 4){
  //   //       break;
  //   //     }
  //   //   }else{
  //   //     break;
  //   //   }
  //   // }
  // }
//获取包长
  int _getPackageLength(List<int> data) {
    // List<int> list = 'xxx'.codeUnits;
    // // Uint8List bytes = Uint8List.fromList(list);
    // // String string = String.fromCharCodes(bytes);
    // //
    // String hh="aaa";
    // hh.codeUnits;

    Uint8List uint8Data = Uint8List.fromList(mutableData);
    ByteData data = ByteData.sublistView(uint8Data);
    int length = data.getInt32(0);
    return length;
  }

  void _receivedMsgHandler(Uint8List event) {}

  _errorHandler() {}

  void _doneHandler() {}

  ///socket 链接
  Future connectWebSocket() async {
    try {
      try {
        channel = IOWebSocketChannel.connect('ws://echo.websocket.org',
            pingInterval: Duration(seconds: 10));
      } on Exception catch (e, s) {
        print("--111111---$s");
      }
      print("---开始链接:--${channel == null}-");

      channel.protocol;

      listen(channel);

      print("--channel.protocol--${channel.protocol}-");
      print("--channel.protocol--${channel.closeCode}-");
      print("--channel.protocol--${channel.closeReason}-");
      notifyListeners();
    } catch (e) {
      print("---链接异常请重试;-${channel == null}---${e.toString()}");
    }
    
    channel.stream.handleError(onError);
    return "";
  }

  void listen(IOWebSocketChannel channel) {
    channel.stream.listen((event) {
      responseText = event;
      notifyListeners();
      print("---收到--$event");
    });
  }

  onError(e) {
    print("--111-e--$e--${e.toString()}");
  }

  Future connectOriWebSocket() async {
    WebSocket webSocket1 = await WebSocket.connect('ws://echo.websocket.org').catchError((e){
      print("---e--${e.toString()}--");
    });

    webSocket1.listen((_) {}, onDone: () {
      print('Local Dart ws connection: closed with\n\t' +
          'code: ${webSocket1.closeCode}\n\t' +
          'reason: ${webSocket1.closeReason}');
    });
    // addError( error, [StackTrace stackTrace]);
    // webSocket1.addError(errCatch);
    webSocket1.close(4001, 'Custom close reason.');

  }


  // void close(IOWebSocketChannel channel) {
  //   channel.sink.close();
  // }

  // void addError(Type object, error, List<dynamic> list) {}
}

