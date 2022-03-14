import 'dart:async';

import 'package:flutter/services.dart';
import 'package:adhara_socket_io/socket.dart';

class SocketIOManager {
  static const MethodChannel _channel = const MethodChannel('adhara_socket_io');

  Map<int, SocketIO> _sockets = {};

  ///Create a [SocketIO] instance
  ///[uri] - Socket Server URL
  ///[query] - Query params to send to server as a Map
  ///returns [SocketIO]
  Future<SocketIO> createInstance(String uri,
      {Map<String, String> query, bool enableLogging: false}) async {
    int index = await _channel.invokeMethod('newInstance',
        {'uri': uri, 'query': query, 'enableLogging': enableLogging});
    SocketIO socket = SocketIO(index);
    _sockets[index] = socket;
    return socket;
  }

  ///Disconnect a socket instance and remove from stored sockets list
  Future clearInstance(SocketIO socket) async {
    await _channel.invokeMethod('clearInstance', {'id': socket.id});
    _sockets.remove(socket.id);
  }
}
