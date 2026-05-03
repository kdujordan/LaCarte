import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderWebSocketService {
  static final String _wsBaseUrl = dotenv.get('WS_URL');

  WebSocketChannel? _channel;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_wsBaseUrl));
    _channel!.stream.listen(
      (raw) {
        try {
          final data = jsonDecode(raw as String) as Map<String, dynamic>;
          _controller.add(data);
        } catch (_) {
          //
        }
      },

      onError: (e) => _controller.addError(e),
      onDone: () {
        Future.delayed(const Duration(seconds: 3), connect);
      },
    );
  }

  void disconnect() {
    _channel?.sink.close();
    _controller.close();
  }
}
