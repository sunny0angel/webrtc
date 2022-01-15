// ignore: avoid_web_libraries_in_flutter

// STEP1:  Stream setup
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket{
  Socket socket = io('http://localhost:3030',
      OptionBuilder()
          .setTransports(['websocket']).build());

  final _socketResponse = StreamController<Map<String, String>>();
  void Function(Map<String, String>) get addResponse => _socketResponse.sink.add;
  Stream<Map<String, String>> get getResponse => _socketResponse.stream;

  static final StreamSocket _instance = StreamSocket._internal();

  factory StreamSocket() {
    return _instance;
  }

  StreamSocket._internal();

  void dispose(){
    _socketResponse.close();
  }

  void listen() {
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    // id, username
    socket.on("user-connected", (data) {
      addResponse({"user-connected": data});
    });
    // peersId
    socket.on("user-disconnected", (data) {
      addResponse({"user-disconnected": data});
    });
    // message
    socket.on("createMessage", (data) {
      addResponse({"createMessage": data});
    });
    // myname
    socket.on("AddName", (data) {
      addResponse({"AddName": data});
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  void sendMessage() {
    socket.emit("messagesend", "");
  }

  void userConnected() {
    socket.emit("tellName", 'name');
  }

  void joinRoom(roomId, id, myname) {
    socket.emit("join-room", [roomId, id, myname]);
  }
}