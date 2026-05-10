import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/api_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final chatServiceProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://fake-api.cyberday.pro/ws'),
  );

  channel.stream.listen((message) {
    ref.read(chatProvider.notifier).addMessage(message, isMe: false);
  });

  return ChatService(channel, apiService);
});

class ChatService {
  final WebSocketChannel _channel;
  final ApiService _apiService;

  ChatService(this._channel, this._apiService);

  void sendMessage(String message) {
    _apiService.sendMessage(message);
    _channel.sink.add(message);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  ChatNotifier() : super(const AsyncValue.loading());

  void addMessage(String message, {required bool isMe}) {
    state = AsyncValue.data([
      ...?state.value,
      {'message': message, 'isMe': isMe},
    ]);
  }
}
