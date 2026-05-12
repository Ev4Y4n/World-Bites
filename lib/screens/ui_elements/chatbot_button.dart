import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';

class ChatbotButton extends StatelessWidget {
  const ChatbotButton({super.key});

  void _openChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CommingSoon()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(136, 97, 87, 87),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => _openChat(context),
          icon: const Icon(
            Icons.mark_chat_unread_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}