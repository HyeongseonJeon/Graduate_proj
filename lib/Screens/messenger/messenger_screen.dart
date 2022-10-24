import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect("ws://echo.websocket.org");

class MessengerScreen extends StatefulWidget {
  final WebSocketChannel? channel;
  MessengerScreen({@required this.channel});

  @override
  State<StatefulWidget> createState() {
    return MessengerScreenState();
  }
}

class MessengerScreenState extends State<MessengerScreen> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web Socket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            StreamBuilder(
              stream: widget.channel?.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel?.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel?.sink.close();
    super.dispose();
  }
}
