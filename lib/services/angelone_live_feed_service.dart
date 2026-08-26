import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Client-side relay interface for live Angel One ticks.
/// The Laravel backend should authenticate the user and relay broker-safe ticks.
class AngelOneLiveFeedService {
  final String wsUrl;
  WebSocketChannel? _channel;
  final _ticks = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get ticks => _ticks.stream;

  AngelOneLiveFeedService({required this.wsUrl});

  void connect({String? authToken}) {
    final uri = Uri.parse(wsUrl);
    _channel = WebSocketChannel.connect(uri, protocols: authToken == null ? null : ['bearer.$authToken']);
    _channel!.stream.listen((message) {
      try {
        final data = jsonDecode(message.toString());
        if (data is Map<String, dynamic>) _ticks.add(data);
      } catch (_) {
        // Ignore malformed relay messages; the connection remains alive.
      }
    }, onError: (Object error, StackTrace stack) => _ticks.add({'type': 'error', 'message': error.toString()}), onDone: () => _ticks.add({'type': 'disconnected'}));
  }

  void subscribe(List<Map<String, String>> instruments) {
    _channel?.sink.add(jsonEncode({'action': 'subscribe', 'instruments': instruments}));
  }

  void unsubscribe(List<Map<String, String>> instruments) {
    _channel?.sink.add(jsonEncode({'action': 'unsubscribe', 'instruments': instruments}));
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _ticks.close();
  }
}
