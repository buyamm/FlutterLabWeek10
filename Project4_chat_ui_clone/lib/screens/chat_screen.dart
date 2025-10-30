import 'dart:async';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo vài tin mẫu
    _messages.addAll([
      Message(
        id: '1',
        text: 'Hey! How are you today?',
        isSender: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        text: 'I’m great 😄 Just working on Flutter stuff.',
        isSender: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isSender: true,
      timestamp: DateTime.now(),
    );
    setState(() => _messages.add(msg));
    _scrollToBottom();

    // Giả lập phản hồi sau 1s
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _generateReply(),
            isSender: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  String _generateReply() {
    const replies = [
      "That's awesome! 💬",
      "Haha I see 😄",
      "Tell me more!",
      "Sounds interesting 👀",
      "I totally agree 👍",
    ];
    replies.shuffle();
    return replies.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=12',
            ),
            backgroundColor: theme.colorScheme.primaryContainer,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Truong Cong Ly',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Online', style: TextStyle(fontSize: 13, color: Colors.green)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder:
                  (context, index) => ChatBubble(message: _messages[index]),
            ),
          ),
          MessageInput(onSend: _handleSend),
        ],
      ),
    );
  }
}
