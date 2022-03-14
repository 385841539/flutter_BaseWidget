// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_module_login/chat/longconnection/chatroom/chat_room_message.dart';
// import 'package:flutter_module_login/chat/longconnection/long_connection.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatRoomEvent {
//   String eventName;
//
//   String direction;
//   List<Message> messages;
//
//   Map<String, Message> roomsNewMessages;
//
//   ChatRoomEvent(this.eventName);
//
//   // 当前聊天室消息
//   ChatRoomEvent.inRoomNewMessageEvent(
//       List<Message> messages, String direction) {
//     this.eventName = 'inRoomNewMessageEvent';
//     this.messages = messages;
//     this.direction = direction;
//   }
//
//   // 当前聊天室以外其他聊天室最新消息
//   ChatRoomEvent.outRoomNewMessageEvent(Map<String, Message> roomsNewMessages) {
//     this.eventName = 'outRoomNewMessageEvent';
//     this.roomsNewMessages = roomsNewMessages;
//   }
// }
//
// class ChatRoomMessageDirection {
//   static const directionNew = 'new';
//   static const directionOld = 'old';
// }
//
// class ChatRoomPlugin extends LongConnectionPlugin {
//   String currentRoomId;
//   String currentDialogueId;
//
//   Map<String, Message> roomsNewMessages;
//   SharedPreferences prefs;
//
//   ChatRoomPlugin() : super('chatroom');
//
//   List<Message> _parseMessagesPayload(List<dynamic> payload) {
//     final items = List<Map>.from(payload);
//     return items
//         .map((item) {
//           try {
//             return Message.fromJSON(item);
//           } catch (e) {
//             return null;
//           }
//         })
//         .where((message) => message != null)
//         .toList();
//   }
//
//   _flushRoomNewMessage() async {
//     Map<String, Map> payload = new Map();
//
//     for (String roomId in this.roomsNewMessages.keys) {
//       final Message message = this.roomsNewMessages[roomId];
//       payload[roomId] = message.toJSON();
//     }
//
//     final jsonString = jsonEncode(payload);
//     await this.prefs.setString('roomsNewMessages', jsonString);
//   }
//
//   _updateRoomNewMessage(Map<String, Message> roomsNewMessages) {
//     if (roomsNewMessages == null || roomsNewMessages.keys.length == 0) {
//       return;
//     }
//
//     for (String roomId in roomsNewMessages.keys) {
//       this.roomsNewMessages[roomId] = roomsNewMessages[roomId];
//     }
//
//     this._flushRoomNewMessage();
//
//     this.fire(ChatRoomEvent.outRoomNewMessageEvent(this.roomsNewMessages));
//   }
//
//   _restoreRoomNewMessage() async {
//     this.prefs = await SharedPreferences.getInstance();
//
//     this.roomsNewMessages = new Map();
//
//     final jsonString = this.prefs.getString('roomsNewMessages');
//     if (jsonString != null && jsonString.length > 0) {
//       Map<String, dynamic> payload = jsonDecode(jsonString);
//       for (String roomId in payload.keys) {
//         this.roomsNewMessages[roomId] = Message.fromJSON(payload[roomId]);
//       }
//     }
//
//     this.fire(ChatRoomEvent.outRoomNewMessageEvent(this.roomsNewMessages));
//   }
//
//   setup(longConnection) async {
//     super.setup(longConnection);
//
//     this._restoreRoomNewMessage();
//
//     final onNewMessages = (List<Message> messages) {
//
//
//       print("---message111---${messages}");
//
//
//       messages.forEach((element) {
//
//         print("---message222---${element.toJSON()}");
//
//       });
//
//       List<Message> currentRoomMessages = [];
//
//       Map<String, Message> outRoomsMessages = new Map();
//       for (Message message in messages) {
//         if (this.currentRoomId == message.roomId ||
//             this.currentDialogueId == message.dialogueId) {
//           currentRoomMessages.add(message);
//         } else {
//           outRoomsMessages[message.roomId] = message;
//         }
//       }
//
//       if ((this.currentRoomId != null || this.currentDialogueId != null) &&
//           currentRoomMessages.length > 0) {
//         this.fire(ChatRoomEvent.inRoomNewMessageEvent(
//             currentRoomMessages, ChatRoomMessageDirection.directionNew));
//       }
//
//       if (outRoomsMessages.keys.length > 0) {
//         this._updateRoomNewMessage(outRoomsMessages);
//       }
//     };
//
//     this.onStatusEvent(LongConnectionState.ConnectionOpened, (_) async {
//       // 断线重连后, 获取新消息
//       final messages = await this.getUserUnreadMessages();
//       onNewMessages(messages);
//     });
//
//     this.onStatusEvent(LongConnectionState.ConnectionClosed, (_) {});
//
//     this.onBusinessEvent('on_messages', (payload) {
//       final messages = this._parseMessagesPayload(payload);
//       onNewMessages(messages);
//     });
//   }
//
//   sendMessage(Message message, {String event = 'send_message'}) async {
//     final result = await this.sendWithAck(event, message.toJSON());
//
//     return result;
//   }
//
//   Future<List<Message>> getRoomMessages(String roomId, String direction,
//       {String fromMessageId}) async {
//     final res = await this.sendWithAck('get_room_messages', {
//       "roomId": roomId,
//       "direction": direction,
//       "fromMessageId": fromMessageId
//     });
//
//     return this._parseMessagesPayload(res);
//   }
//
//   Future<List<Message>> getInquiryMessages(String dialogueId, String direction,
//       {String fromMessageId}) async {
//     final res = await this.sendWithAck('get_inquiry_record_comments', {
//       "dialogueId": dialogueId,
//       "direction": direction,
//       "fromMessageId": fromMessageId
//     });
//
//     return this._parseMessagesPayload(res);
//   }
//
//   Future<List<Message>> getDialogueMessages(String dialogueId, String direction,
//       {String fromMessageId}) async {
//     final res = await this.sendWithAck('get_dialogue_messages', {
//       "dialogueId": dialogueId,
//       "direction": direction,
//       "fromMessageId": fromMessageId
//     });
//
//     return this._parseMessagesPayload(res);
//   }
//
//   Future<List<Message>> getUserUnreadMessages() async {
//     final res = await this.sendWithAck('get_user_unread_messages', {});
//     return this._parseMessagesPayload(res);
//   }
//
//   // 根据业务需求，在一个聊天室中
//   enterRoom(String roomId) async {
//     if (this.currentRoomId != null) {
//       this.leaveRoom();
//     }
//
//     this.currentRoomId = roomId;
//
//     this.clearRoomUnreadMessage(this.currentRoomId);
//
//     // 进入聊天室获取一页新聊天室消息
//     final messages = await this
//         .getRoomMessages(roomId, ChatRoomMessageDirection.directionOld);
//     if (messages.length > 0) {
//       this.fire(ChatRoomEvent.inRoomNewMessageEvent(
//           messages, ChatRoomMessageDirection.directionOld));
//     }
//   }
//
//   leaveRoom() {
//     if (this.currentRoomId == null) {
//       return;
//     }
//
//     this.clearRoomUnreadMessage(this.currentRoomId);
//     this.currentRoomId = null;
//   }
//
//   clearRoomUnreadMessage(String roomId) {
//     if (!this.roomsNewMessages.containsKey(roomId)) {
//       return;
//     }
//
//     this.roomsNewMessages.remove(roomId);
//     this._flushRoomNewMessage();
//     this.fire(ChatRoomEvent.outRoomNewMessageEvent(this.roomsNewMessages));
//   }
//
//   enterDialogue(String dialogueId) async {
//     if (this.currentDialogueId != null) {
//       this.leaveRoom();
//     }
//
//     this.currentDialogueId = dialogueId;
//
//     this.clearRoomUnreadMessage(dialogueId);
//
//     // 进入聊天室获取一页新聊天室消息
//     final messages = await this
//         .getDialogueMessages(dialogueId, ChatRoomMessageDirection.directionOld);
//     if (messages.length > 0) {
//       this.fire(ChatRoomEvent.inRoomNewMessageEvent(
//           messages, ChatRoomMessageDirection.directionOld));
//     }
//   }
//
//   leaveDialogue() {
//     if (this.currentDialogueId == null) {
//       return;
//     }
//
//     this.clearRoomUnreadMessage(this.currentDialogueId);
//     this.currentDialogueId = null;
//   }
// }
