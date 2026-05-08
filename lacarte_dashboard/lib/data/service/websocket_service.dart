import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';

class WebsocketService {
  static final WebsocketService _instance = WebsocketService._internal();
  factory WebsocketService() => _instance;
  
  final Logger _logger = Logger();
  WebSocketChannel? _channel;
  
  final _orderStreamController = StreamController<OrderResponse>.broadcast();
  Stream<OrderResponse> get orderStream => _orderStreamController.stream;

  final String wsUrl = "ws://127.0.0.1:8000/ws/orders/";

  WebsocketService._internal();

  void connect() {
    if (_channel != null) {
      _logger.w('WebSocket is already connected.');
      return;
    }
    
    try {
      _logger.i('Connecting to WebSocket at $wsUrl');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        (message) {
          _logger.i('Received WebSocket message: $message');
          _handleMessage(message);
        },
        onDone: () {
          _logger.w('WebSocket connection closed.');
          _reconnect();
        },
        onError: (error) {
          _logger.e('WebSocket error: $error');
        },
      );
    } catch (e) {
      _logger.e('Failed to connect to WebSocket: $e');
      _reconnect();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded['type'] == 'order_received' && decoded['data'] != null) {
        final orderResponse = OrderResponse.fromJson(decoded['data']);
        _orderStreamController.add(orderResponse);
      }
    } catch (e) {
      _logger.e('Error parsing WebSocket message: $e');
    }
  }

  void _reconnect() {
    _channel?.sink.close();
    _channel = null;
    Future.delayed(const Duration(seconds: 5), () {
      _logger.i('Attempting to reconnect WebSocket...');
      connect();
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _logger.i('WebSocket disconnected gracefully.');
  }

  void dispose() {
    disconnect();
    _orderStreamController.close();
  }
}
