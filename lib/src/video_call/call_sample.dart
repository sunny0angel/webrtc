import 'package:chat_app/src/utils/stream_socket.dart';
import 'package:chat_app/src/video_call/signaling.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallSample extends StatefulWidget {
  final String? roomId;
  final String userName;

  const CallSample(this.userName, {Key? key, this.roomId}) : super(key: key);

  @override
  _CallSampleState createState() => _CallSampleState();
}

class _CallSampleState extends State<CallSample> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  Signaling _signaling = Signaling();
  StreamSocket _streamSocket = StreamSocket();
  late String roomId;

  // ignore: unused_element
  _CallSampleState() {
    _streamSocket.listen();
    init();
  }

  init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
    });
    await _signaling.openUserMedia(_localRenderer, _remoteRenderer);
    if (widget.roomId == null) {
      roomId = await _signaling.createRoom(_remoteRenderer);
    } else {
      roomId = widget.roomId ?? '';
      await _signaling.joinRoom(widget.roomId!, _remoteRenderer);
    }
  }

  @override
  deactivate() {
    super.deactivate();
    _streamSocket.dispose();
    _signaling.hangUp(_localRenderer);
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  _aaaa() {
    _streamSocket.getResponse.listen((event) {
      if (event.keys.contains('user-connected')) {
        event['user-connected'];
      } else if (event.keys.contains('user-disconnected')) {
        event['user-disconnected'];
      } else if (event.keys.contains('createMessage')) {
        event['createMessage'];
      } else if (event.keys.contains('AddName')) {
        event['AddName'];
      } else {
        event['user-connected'];
      }
    });
  }

  _hangUp() {
    _signaling.hangUp(_localRenderer);
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _muteMic() {
    _signaling.muteMic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P2P Call Sample'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 200.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "SwichCamera",
                  child: const Icon(Icons.switch_camera),
                  onPressed: _switchCamera,
                ),
                FloatingActionButton(
                  heroTag: "Hangup",
                  onPressed: _hangUp,
                  tooltip: 'Hangup',
                  child: Icon(Icons.call_end),
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  heroTag: "Mute",
                  child: const Icon(Icons.mic_off),
                  onPressed: _muteMic,
                )
              ])),
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: RTCVideoView(_remoteRenderer),
                  decoration: BoxDecoration(color: Colors.black54),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                child: RTCVideoView(_localRenderer, mirror: true),
                decoration: BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
