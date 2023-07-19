import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageScreen extends StatefulWidget {
  final String id;
  const MessageScreen({Key? key, required this.id}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.messageScreen}: ${widget.id}'),
      ),
    );
  }
}
