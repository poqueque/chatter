import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> messages = [];

  var db = FirebaseFirestore.instance;

  MessageProvider() {
    var docReference = db.collection("messages");
    docReference.snapshots().listen((event) {
      for (var doc in event.docs) {
        Message message = Message.fromFirestore(doc);
        if (!messages.contains(message)) {
          messages.add(message);
        }
      }
      messages.sort();
      notifyListeners();
    });
  }

  void addMessage(String text) {
    var authorName = FirebaseAuth.instance.currentUser!.displayName ?? "Anònim";
    if (authorName.isEmpty) authorName = "Anònim";

    Message message = Message(
        authorId: FirebaseAuth.instance.currentUser!.uid,
        authorName: authorName,
        text: text,
        dateTime: DateTime.now());
    messages.add(message);
    db.collection("messages").add(message.toFirestore()).then(
        (documentSnapshot) =>
            debugPrint("Added Data with ID: ${documentSnapshot.id}"));
    notifyListeners();
  }
}
