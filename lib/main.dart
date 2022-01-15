import 'dart:core';
import 'package:flutter/material.dart';

import 'src/video_call/call_sample.dart';

void main() async {

  runApp(new MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  TextEditingController roomIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter-WebRTC example'),
          ),
          body: Form(
            child: Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    validator: (value) {
                      if (value == null) return "User name cannot be null!!";
                    },
                  ),
                  TextFormField(
                    controller: roomIdController,
                    validator: (value) {
                      if (value == null) return "Room id cannot be null!!";
                    },
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CallSample(userNameController.text)),
                        );
                      },
                      child: Text('Create a room')),
                  TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallSample(
                                  userNameController.text,
                                  roomId: roomIdController.text)),
                        );
                      },
                      child: Text('Join a room')),
                ],
              ),
            ),
          )),
    );
  }
}
