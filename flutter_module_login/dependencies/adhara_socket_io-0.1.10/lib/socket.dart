import 'package:flutter/services.dart';
import 'dart:convert' show jsonDecode;

typedef void SocketEventListener(dynamic data);

class SocketIO {
  ///  Constants for default events handled by socket...
  ///  Refer [https://socket.io/docs/client-api/#Event-%E2%80%98connect%E2%80%99](https://socket.io/docs/client-api/#Event-%E2%80%98connect%E2%80%99)
  ///  Socket Connect event
  static const String CONNECT = "connect";

  ///  Socket Disconnect event
  static const String DISCONNECT = "disconnect";

  ///  Socket Connection Error event
  static const String CONNECT_ERROR = "connect_error";

  ///  Socket Connection timeout event
  static const String CONNECT_TIMEOUT = "connect_timeout";

  ///  Socket Error event
  static const String ERROR = "error";

  ///  Socket Connecting event
  static const String CONNECTING = "connecting";

  ///  Socket Reconnect event
  static const String RECONNECT = "reconnect";

  ///  Socket Reconnect Error event
  static const String RECONNECT_ERROR = "reconnect_error";

  ///  Socket Reconnect Failed event
  static const String RECONNECT_FAILED = "reconnect_failed";

  ///  Socket Reconnecting event
  static const String RECONNECTING = "reconnecting";

  ///  Socket Ping event
  static const String PING = "ping";

  ///  Socket Pong event
  static const String PONG = "pong";

  ///Socket/Connection identifier
  int id;

  ///Store listeners
  Map<String, List<Function>> _listeners = {};

  ///Method channel to interact with android/iOS
  final MethodChannel _channel;

  ///Create a socket object with identifier received from platform API's
  SocketIO(this.id)
      : _channel =
            new MethodChannel("adhara_socket_io:socket:${id.toString()}") {
    _channel.setMethodCallHandler((call) {
      if (call.method == 'incoming') {
        final String eventName = call.arguments['eventName'];
        final List<dynamic> arguments = call.arguments['args'];
        _handleData(eventName, arguments);
      }
    });
  }

  ///connect this socket to server
  connect() async {
    await _channel.invokeMethod("connect");
  }

  ///listen to an event
  on(String eventName, SocketEventListener listener) async {
    if (_listeners[eventName] == null) {
      _listeners[eventName] = [];
    }
    _listeners[eventName].add(listener);
    await _channel.invokeMethod("on", {"eventName": eventName});
  }

  ///stop listening to an event.
  ///Send the same function reference to stop that particular listener
  off(String eventName, [SocketEventListener listener]) async {
    if (listener == null) {
      _listeners[eventName] = [];
    } else {
      _listeners[eventName].remove(listener);
    }
    if (_listeners[eventName].length == 0) {
      await _channel.invokeMethod("off", {"eventName": eventName});
    }
  }

  ///send data to socket server
  emit(String eventName, List<dynamic> arguments, {bool ack: true, int ackTimeoutSeconds: 60}) async {
    return await _channel.invokeMethod('emit', {
      'eventName': eventName,
      'arguments': arguments,
      'ack': ack,
      'ackTimeout': ackTimeoutSeconds
    });
  }

  ///Data listener called by platform API
  _handleData(String eventName, List arguments) {
    _listeners[eventName]?.forEach((Function listener) {
      if (arguments.length == 0) {
        arguments = [null];
      } else {
        arguments = arguments.map((_) {
          try {
            return jsonDecode(_);
          } catch (e) {
            return _;
          }
        }).toList();
      }
      Function.apply(listener, arguments);
    });
  }

  //Utility methods for listeners. De-registering can be handled using off(eventName, fn)
  ///Listen to connect event
  onConnect(SocketEventListener listener) async => await on(CONNECT, listener);

  ///Listen to disconnect event
  onDisconnect(SocketEventListener listener) async =>
      await on(DISCONNECT, listener);

  ///Listen to connection error event
  onConnectError(SocketEventListener listener) async =>
      await on(CONNECT_ERROR, listener);

  ///Listen to connection timeout event
  onConnectTimeout(SocketEventListener listener) async =>
      await on(CONNECT_TIMEOUT, listener);

  ///Listen to error event
  onError(SocketEventListener listener) async => await on(ERROR, listener);

  ///Listen to connecting event
  onConnecting(SocketEventListener listener) async =>
      await on(CONNECTING, listener);

  ///Listen to reconnect event
  onReconnect(SocketEventListener listener) async =>
      await on(RECONNECT, listener);

  ///Listen to reconnect error event
  onReconnectError(SocketEventListener listener) async =>
      await on(RECONNECT_ERROR, listener);

  ///Listen to reconnect failed event
  onReconnectFailed(SocketEventListener listener) async =>
      await on(RECONNECT_FAILED, listener);

  ///Listen to reconnecting event
  onReconnecting(SocketEventListener listener) async =>
      await on(RECONNECTING, listener);

  ///Listen to ping event
  onPing(SocketEventListener listener) async => await on(PING, listener);

  ///Listen to pong event
  onPong(SocketEventListener listener) async => await on(PONG, listener);
}
