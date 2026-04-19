import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/app_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.wsUrl),
      );
      _isConnected = true;
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            _messageController.add(data);
          } catch (e) {
            _messageController.add({'raw': message});
          }
        },
        onDone: () {
          _isConnected = false;
          _reconnect();
        },
        onError: (error) {
          _isConnected = false;
          _reconnect();
        },
      );
    } catch (e) {
      _isConnected = false;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      connect();
    });
  }

  void disconnect() {
    _isConnected = false;
    _channel?.sink.close();
    _messageController.close();
  }
}