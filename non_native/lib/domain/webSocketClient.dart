// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
// import 'package:non_native/repository/database.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
//
// import '../models/note.dart';
// import 'logger.dart';
// import 'message.dart';
// import 'message_type.dart';
//
// // https://blog.devgenius.io/web-socket-in-flutter-615d21ddf1c5
// class WebSocketClient {
//   static WebSocketClient? _instance;
//
//   late Function refreshNotes;
//   late Function addNoteLocally;
//
//   late IOWebSocketChannel _client;
//   bool _isConnected = false;
//   final _heartbeatInterval = 10;
//   final _reconnectInterval = 5;
//   int _reconnectCount = 120;
//   final _sendBuffer = Queue();
//   Timer? heartBeatTimer, _reconnectTimer;
//
//   static WebSocketClient getInstance() {
//     if (_instance == null) {
//       _instance = WebSocketClient();
//     }
//     return _instance!;
//   }
//
//   bool get isConnected {
//     return _isConnected;
//   }
//
//   connectToSocket() async {
//     if (!_isConnected) {
//       logger.v("[SERVER] Trying to connect to ws");
//       WebSocket.connect(
//         Uri(scheme: "ws", host: "192.168.43.62", port: 3000, path: "/socket")
//             .toString(),
//       ).then((ws) {
//         _client = IOWebSocketChannel(ws);
//         if (_client != null) {
//           _reconnectCount = 120;
//           _reconnectTimer?.cancel();
//           _client.sink.add(json.encode(Message<String>(
//               type: MessageType.GREETING, data: "Socket connected")));
//           _listenToMessage();
//           _isConnected = true;
//           _startHeartBeatTimer();
//           logger.v("[SERVER] Resuming from buffer");
//           while (_sendBuffer.isNotEmpty) {
//             String text = _sendBuffer.first;
//             _sendBuffer.remove(text);
//             _push(text);
//           }
//           logger.v("[SERVER] Finished buffered messages");
//           LocalDatabase.instance.syncDatabaseWithServer();
//           logger.v("[SERVER] Connected successfully to ws");
//         } else {
//           logger.e("[SERVER][ERROR] Could not get a channel for the ws");
//         }
//       }).onError((error, stackTrace) {
//         logger.e("[SERVER][ERROR] There has been an error trying to connect to ws");
//         disconnect();
//         _reconnect();
//       });
//       if (!_isConnected) {
//         _reconnect();
//       }
//     }
//   }
//
//   _reconnect() async {
//     logger.v("[SERVER] Reconnecting to ws");
//     if ((_reconnectTimer == null || !_reconnectTimer!.isActive) &&
//         _reconnectCount > 0) {
//       _reconnectTimer = Timer.periodic(Duration(seconds: _reconnectInterval),
//           (Timer timer) async {
//         if (_reconnectCount == 0) {
//           _reconnectTimer?.cancel();
//           return;
//         }
//         await connectToSocket();
//         _reconnectCount--;
//         logger.v('[SERVER][RECONNECTING] Attempts left: $_reconnectCount');
//       });
//     }
//   }
//
//   _listenToMessage() {
//     _client.stream.listen(
//       (message) async {
//         var msg = jsonDecode(message);
//
//         switch (msg['type']) {
//           case MessageType.GREETING:
//             logger.v("[SERVER][MSG] ${msg['data']}");
//             break;
//           case MessageType.GET_ALL:
//             logger.v("[SERVER][MSG] Puting server items in local database");
//             for (var json in msg['data']) {
//               var price = json['price'];
//               if (price is int) {
//                 json['price'] = price.toDouble();
//               }
//               Note note = Note.fromJson(json);
//               try {
//                 await LocalDatabase.instance.create(note);
//               } catch (e) {
//                 logger.w("[SERVER][WARN] Element already in db");
//               }
//             }
//             refreshNotes();
//             break;
//           case MessageType.CREATE:
//             logger.v("[SERVER][MSG] Note ${msg['data']} got created on the server");
//             try {
//               var price = msg['data']['price'];
//               if (price is int) {
//                 msg['data']['price'] = price.toDouble();
//               }
//               await addNoteLocally(Note.fromJson(msg['data']));
//             } catch (e) {
//               logger.e("[SERVER][ERROR] $e");
//             }
//             break;
//           case MessageType.DELETE:
//             logger.v("[SERVER][MSG] Note ${msg['data']} got deleted on the server");
//             break;
//           case MessageType.UPDATE:
//             logger.v("[SERVER][MSG] Note ${msg['data']} got updated on the server");
//             break;
//           case MessageType.ERROR:
//             logger.e("[SERVER][ERROR] ${msg['data']}");
//             break;
//         }
//       },
//       onDone: () {
//         disconnect();
//         _reconnect();
//       },
//     );
//   }
//
//   subscribe(String text, {bool unsubscribeAllSubscribed = false}) {
//     //send messages
//     _push(text);
//   }
//
//   _startHeartBeatTimer() {
//     heartBeatTimer =
//         Timer.periodic(Duration(seconds: _heartbeatInterval), (Timer timer) {
//       logger.v("[SERVER][Sending] HEARTBEAT");
//       _client.sink?.add(json.encode(
//           Message<String>(type: MessageType.GREETING, data: "HeartBeat")));
//     });
//   }
//
//   _push(String text) {
//     if (_isConnected) {
//       logger.v("[SERVER][Sending] $text");
//       _client.sink.add(text);
//       logger.v("[SERVER][Sent] $text");
//     } else {
//       logger.v("[SERVER][Pushing] $text");
//       _sendBuffer.add(text);
//     }
//   }
//
//   disconnect() {
//     _client?.sink?.close(status.goingAway);
//     heartBeatTimer?.cancel();
//     _reconnectTimer?.cancel();
//     _isConnected = false;
//   }
// }
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../models/note.dart';
import '../repository/database.dart';
import 'logger.dart';
import 'message.dart';
import 'message_type.dart';



class WebSocketClient {
  static WebSocketClient? _instance;

  late Function refreshNotes;
  late Function addNoteLocally;

  late IOWebSocketChannel _client;
  bool _isConnected = false;
  final _heartbeatInterval = 10;
  final _reconnectInterval = 5;
  int _reconnectCount = 120;
  final _sendBuffer = Queue();
  Timer? heartBeatTimer, _reconnectTimer;

  static WebSocketClient getInstance() {
    if (_instance == null) {
      _instance = WebSocketClient();
    }
    return _instance!;
  }

  bool get isConnected {
    return _isConnected;
  }

  connectToSocket() async {
    if (!_isConnected) {
      logger.v("[SERVER] Trying to connect to ws");
      WebSocket.connect(
        Uri(scheme: "ws", host: "192.168.43.62", port: 3001, path: "/socket").toString(),
        // Uri(scheme: "ws", host: "192.168.43.20", port: 3001, path: "/socket").toString(),
      ).then((ws) {
        _client = IOWebSocketChannel(ws);
        if (_client != null) {
          _reconnectCount = 120;
          _reconnectTimer?.cancel();
          _client.sink.add(json.encode(Message<String>(type: MessageType.GREETING, data: "Socket connected")));
          _listenToMessage();
          _isConnected = true;
          _startHeartBeatTimer();
          logger.v("[SERVER] Resuming from buffer");
          while (_sendBuffer.isNotEmpty) {
            String text = _sendBuffer.first;
            _sendBuffer.remove(text);
            _push(text);
          }
          logger.v("[SERVER] Finished buffered messages");
          LocalDatabase.instance.syncDatabaseWithServer();
          logger.v("[SERVER] Connected successfully to ws");
        }
        else {
          logger.e("[SERVER][ERROR] Could not get a channel for the ws");
        }
      }).onError((error, stackTrace) {
        logger.e("[SERVER][ERROR] There has been an error trying to connect to ws");
        disconnect();
        _reconnect();
      });
      if (!_isConnected) {
        _reconnect();
      }
    }
  }

  _reconnect() async {
    logger.v("[SERVER] Reconnecting to ws");
    if ((_reconnectTimer == null || !_reconnectTimer!.isActive) &&
        _reconnectCount > 0) {
      _reconnectTimer = Timer.periodic(Duration(seconds: _reconnectInterval),
              (Timer timer) async {
            if (_reconnectCount == 0) {
              _reconnectTimer?.cancel();
              return;
            }
            await connectToSocket();
            _reconnectCount--;
            logger.v('[SERVER][RECONNECTING] Attempts left: $_reconnectCount');
          });
    }
  }

  _listenToMessage() {
    _client.stream.listen((message) async {
      var msg = jsonDecode(message);

      switch (msg['type']) {
        case MessageType.GREETING:
          logger.v("[SERVER][MSG] ${msg['data']}");
          break;
        case MessageType.GET_ALL:
          logger.v("[SERVER][MSG] Puting server items in local database");
          for (var json in msg['data']) {
            var price = json['price'];
            if (price is int) {
              json['price'] = price.toDouble();
            }
            Note game = Note.fromJson(json);
            try {
              await LocalDatabase.instance.create(game);
            } catch (e) {
              logger.w("[SERVER][WARN] Element already in db");
            }
          }
          refreshNotes();
          break;
        case MessageType.CREATE:
          logger.v("[SERVER][MSG] Note ${msg['data']} got created on the server");
          try {
            var price = msg['data']['price'];
            if (price is int) {
              msg['data']['price'] = price.toDouble();
            }
            await addNoteLocally(Note.fromJson(msg['data']));
          } catch (e) {
            logger.e("[SERVER][ERROR] $e");
          }
          break;
        case MessageType.DELETE:
          logger.v("[SERVER][MSG] Note ${msg['data']} got deleted on the server");
          break;
        case MessageType.UPDATE:
          logger.v("[SERVER][MSG] Note ${msg['data']} got updated on the server");
          break;
        case MessageType.ERROR:
          logger.e("[SERVER][ERROR] ${msg['data']}");
          break;
      }
    },
      onDone: () {
        disconnect();
        _reconnect();
      },
    );
  }

  subscribe(String text, {bool unsubscribeAllSubscribed = false}) {
    _push(text);
  }

  _startHeartBeatTimer() {
    heartBeatTimer =
        Timer.periodic(Duration(seconds: _heartbeatInterval), (Timer timer) {
          logger.v("[SERVER][Sending] HEARTBEAT");
          _client.sink?.add(json.encode(Message<String>(type: MessageType.HEARTBEAT, data: "HeartBeat")));
        });
  }

  _push(String text) {
    if (_isConnected) {
      logger.v("[SERVER][Sending] $text");
      _client.sink.add(text);
      logger.v("[SERVER][Sent] $text");
    } else {
      logger.v("[SERVER][Pushing] $text");
      _sendBuffer.add(text);
    }
  }

  disconnect() {
    _client?.sink?.close(status.goingAway);
    heartBeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _isConnected = false;
  }
}