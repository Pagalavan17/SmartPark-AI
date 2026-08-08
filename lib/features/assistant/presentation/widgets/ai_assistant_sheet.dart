import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../assistant_providers.dart';

/// Interactive AI Assistant Bottom Sheet with Chat, Voice Input, and Quick Actions
class AIAssistantSheet extends ConsumerStatefulWidget {
  const AIAssistantSheet({super.key});

  @override
  ConsumerState<AIAssistantSheet> createState() => _AIAssistantSheetState();
}

class _AIAssistantSheetState extends ConsumerState<AIAssistantSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;
  bool _isTyping = false;

  final List<String> _quickChips = [
    'Find best parking',
    'Why is price higher?',
    'Show live map',
    'Check my reservation',
    'EV charging status',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String query) async {
    if (query.trim().isEmpty) return;
    _textController.clear();

    final notifier = ref.read(aiAssistantChatHistoryProvider.notifier);
    notifier.addMessage(query, true);

    setState(() => _isTyping = true);
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 600));

    String aiResponse = 'I checked your request using AI Decision Engine.';
    String? actionRoute;

    final lower = query.toLowerCase();
    if (lower.contains('best') || lower.contains('recommend') || lower.contains('find')) {
      aiResponse = 'I recommend Metro Cyber Park Garage! It has a 96% AI match score, 24 available slots, and lowest traffic.';
      actionRoute = '/parking-details/spot_metro';
    } else if (lower.contains('price') || lower.contains('higher') || lower.contains('surge')) {
      aiResponse = 'Peak hour surge (+20%) is active due to heavy vehicle inflow in Cyber City. Rates will normalize in ~45 mins.';
    } else if (lower.contains('map') || lower.contains('live')) {
      aiResponse = 'Opening Live Parking Map with color-coded occupancy markers...';
      actionRoute = '/live-map';
    } else if (lower.contains('reservation') || lower.contains('pass')) {
      aiResponse = 'Your active reservation is at Metro Cyber Park Garage (Slot A-14). Entry time is 10:00 AM.';
      actionRoute = '/qr-pass';
    } else {
      aiResponse = 'SmartPark AI parsed "$query". All sensors online. Distance to recommended parking is 0.8 km.';
    }

    notifier.addMessage(aiResponse, false, actionRoute: actionRoute);
    setState(() => _isTyping = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleVoiceListening() {
    setState(() => _isListening = !_isListening);
    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listening... Speak your parking query now.')),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isListening) {
          setState(() => _isListening = false);
          _sendMessage('Find nearby EV charging parking with lowest price');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiAssistantChatHistoryProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.largePadding, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SmartPark AI Assistant', style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
                        Text('Context Aware • Gemini & Edge ML', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      tooltip: 'Clear History',
                      onPressed: () => ref.read(aiAssistantChatHistoryProvider.notifier).clearHistory(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 8),
                  Text('SmartPark AI is analyzing telemetry...', style: AppTextStyles.caption),
                ],
              ),
            ),

          // Quick Suggestion Chips Bar
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: _quickChips.length,
              itemBuilder: (context, index) {
                final chipText = _quickChips[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ActionChip(
                    label: Text(chipText, style: AppTextStyles.caption),
                    backgroundColor: AppColors.background,
                    onPressed: () => _sendMessage(chipText),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Voice Waveform / Text Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleVoiceListening,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isListening ? AppColors.error : AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.white : AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening voice input...' : 'Ask AI anything about parking...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  if (msg.actionRoute != null) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(msg.actionRoute!);
                      },
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: const Text('Execute Action'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
