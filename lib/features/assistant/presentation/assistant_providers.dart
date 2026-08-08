import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? actionRoute;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actionRoute,
  });
}

final aiAssistantChatHistoryProvider = StateNotifierProvider<AIAssistantNotifier, List<ChatMessageModel>>((ref) {
  return AIAssistantNotifier();
});

class AIAssistantNotifier extends StateNotifier<List<ChatMessageModel>> {
  AIAssistantNotifier()
      : super([
          ChatMessageModel(
            id: 'msg_0',
            text: 'Hello Alex! I am SmartPark AI Assistant. How can I assist your parking today?',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ]);

  void addMessage(String text, bool isUser, {String? actionRoute}) {
    state = [
      ...state,
      ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
        actionRoute: actionRoute,
      ),
    ];
  }

  void clearHistory() {
    state = [
      ChatMessageModel(
        id: 'msg_0',
        text: 'Conversation reset. How can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }
}
