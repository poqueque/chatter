import 'package:chatter/providers/message_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../styles/app_styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatter")),
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.chat, size: 48, color: AppStyles.orange),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? "---",
              style: AppStyles.mediumText,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email ?? "---",
              style: AppStyles.mediumText,
            ),
            Expanded(
              child: Consumer<MessageProvider>(
                  builder: (context, messageProvider, child) {
                return Container(
                  color: AppStyles.orange.withOpacity(0.1),
                  child: ListView(
                    children: [
                      for (var message in messageProvider.messages)
                        ListTile(
                          title: Text(message.author),
                          subtitle: Text(message.text),
                        )
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                onSubmitted: (value) {
                  Provider.of<MessageProvider>(context, listen: false)
                      .addMessage(Message(
                    author: FirebaseAuth.instance.currentUser!.email ?? "---",
                    text: value,
                    dateTime: DateTime.now(),
                  ));
                  textEditingController.text = "";
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
