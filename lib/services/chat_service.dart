import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  late final WebSocketChannel _channel;

  ChatService(String token) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8000/ws?token=$token'),
    );
  }

  Stream<dynamic> get messages => _channel.stream;

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void dispose() {
    _channel.sink.close();
  }
}
