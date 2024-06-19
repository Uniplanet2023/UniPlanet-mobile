import 'package:flutter/material.dart';
import 'package:uniplanet/common/widgets/selectable_text.dart';
import 'package:uniplanet/models/message.dart';

class MessageDetailScreen extends StatelessWidget {
  final Message message;

  const MessageDetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
              width: double.infinity,
              child: SelectableLinkText(
                text: message.message,
              )),
        ),
      ),
    );
  }
}
