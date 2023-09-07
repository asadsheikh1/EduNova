import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final bool alignRight;
  const MessageCard({super.key, required this.message, required this.alignRight});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(message),
        ),
      ),
    );
  }
}
