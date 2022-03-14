// import 'dart:convert';
//
// import 'package:adhara_socket_io/adhara_socket_io.dart';
// import 'package:adhara_socket_io/socket.dart';
// import 'package:event_bus/event_bus.dart';
// import 'package:flutter/foundation.dart';
//
// enum LongConnectionState {
//   ConnectionIdle,
//   ConnectionOpening,
//   ConnectionOpened,
//   ConnectionClosed,
//   ConnectionError,
// }
//
// class LongConnectionIdentity {
//   String token;
//   String userId;
//
//   LongConnectionIdentity(this.token, this.userId);
// }
//
// class LongConnectionEvent {
//   String namespace;
//   String eventName;
//
//   LongConnectionState status;
//   dynamic error;
//
//   dynamic payload;
//
//   LongConnectionEvent.onStateChangeEvent(status) {
//     this.eventName = 'onStateChange';
//     this.status = status;
//   }
//
//   LongConnectionEvent.businessEvent(namespace, eventName, payload) {
//     assert(eventName != 'onStateChange',
//         'business event name SHOUDL NOT be onStateChange');
//
//     this.namespace = namespace;
//     this.eventName = eventName;
//     this.payload = payload;
//   }
// }
//
// class LongConnectionPlugin extends EventBus {
//   LongConnection longConnection;
//   String namespace;
//
//   Map<LongConnectionState, SocketEventListener> statusListeners = new Map();
//   Map<String, SocketEventListener> businessListeners = new Map();
//
//   LongConnectionPlugin(this.namespace);
//
//   setup(longConnection) {
//     this.longConnection = longConnection;
//
//     longConnection
//         .on<LongConnectionEvent>()
//         .listen((LongConnectionEvent event) {
//       if (event.eventName == 'onStateChange') {
//         final SocketEventListener listener = this.statusListeners[event.status];
//         if (listener != null) {
//           listener(event.error);
//         }
//       } else {
//         // 防止 plugin 之间消息污染，只能接收自己 namespace 相关的消息
//         if (this.namespace == event.namespace) {
//           final SocketEventListener listener =
//               this.businessListeners[event.eventName];
//           if (listener != null) {
//             listener(event.payload);
//           }
//         }
//       }
//     });
//   }
//
//   onStatusEvent(LongConnectionState state, SocketEventListener listener) {
//     this.statusListeners[state] = listener;
//   }
//
//   onBusinessEvent(String eventName, SocketEventListener listener) {
//     this.businessListeners[eventName] = listener;
//   }
//
//   send(eventName, payload) {
//     this.longConnection.send(this.namespace, eventName, payload, ack: false);
//   }
//
//   sendWithAck(eventName, payload, {int ackTimeoutSeconds: 60}) async {
//     final acks = await this.longConnection.send(this.namespace, eventName, payload, ack: true, ackTimeoutSeconds: ackTimeoutSeconds);
//     final result = acks[0];
//
//     if (result == 'NO ACK') {
//       throw result;
//     }
//
//     return result;
//   }
//
//   fire(dynamic event) {
//     super.fire(event);
//     this.longConnection.fire(event);
//   }
// }
//
// class LongConnection extends EventBus {
//   String host;
//   LongConnectionIdentity identity;
//
//   SocketIO socketIO;
//   LongConnectionState state = LongConnectionState.ConnectionIdle;
//
//   List<LongConnectionPlugin> plugins = new List();
//
//   LongConnection(String host, LongConnectionIdentity identity) {
//     this.host = host;
//     this.identity = identity;
//   }
//
//   _setupSocket(SocketIO socket) {
//     socket.on("connect", (_) {
//       print('connected');
//
//       this.fire(LongConnectionEvent.onStateChangeEvent(
//           LongConnectionState.ConnectionOpened));
//     });
//
//     socket.on('connect_error', (error) {
//       print('Connection error:' + error.toString());
//
//       final event = LongConnectionEvent.onStateChangeEvent(
//           LongConnectionState.ConnectionError);
//       event.error = error;
//       this.fire(event);
//     });
//
//     socket.on("disconnect", (_) {
//       print('Closed by server!');
//
//       this.fire(LongConnectionEvent.onStateChangeEvent(
//           LongConnectionState.ConnectionClosed));
//     });
//
//     socket.on('error', (error) {
//       print('error:' + error.toString());
//
//       final event = LongConnectionEvent.onStateChangeEvent(
//           LongConnectionState.ConnectionError);
//       event.error = error;
//       this.fire(event);
//     });
//
//     socket.on('event', (data) {
//       debugPrint('> longlink on receive: ' + jsonEncode(data));
//
//       final namespace = data['namespace'];
//       final eventName = data["event"];
//       final payload = data["payload"];
//
//       this.fire(
//           LongConnectionEvent.businessEvent(namespace, eventName, payload));
//     });
//   }
//
//   addPlugin(LongConnectionPlugin plugin) {
//     plugins.add(plugin);
//     plugin.setup(this);
//   }
//
//   send(namespace, event, payload, {bool ack: true, int ackTimeoutSeconds: 60}) async {
//     if (socketIO == null) {
//       throw ArgumentError("cant not send, socket is not established");
//     }
//
//     final payloadDict = {"namespace": namespace, "event": event, "payload": payload};
//
//     print('> longlink send: ' + jsonEncode(payloadDict));
//
//     return this.socketIO.emit('event', [
//       payloadDict
//     ],
//         // ack: ack, ackTimeoutSeconds: ackTimeoutSeconds
//     );
//   }
//
//   void connect() async {
//     print("---host-${this.host}--token-${this.identity.token}-");
//     if (this.socketIO == null) {
//       // this.socketIO = await SocketIOManager().createInstance(this.host,
//       //     query: {"token": this.identity.token});
//
//       this._setupSocket(this.socketIO);
//     }
//
//     this.socketIO.connect();
//   }
//
//   close() async {
//     if (this.socketIO == null) {
//       return;
//     }
//
//     await SocketIOManager().clearInstance(this.socketIO);
//     this.socketIO = null;
//   }
// }
