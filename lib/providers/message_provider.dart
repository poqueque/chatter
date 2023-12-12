import 'package:cloud_firestore/cloud_firestore.dart';
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
      notifyListeners();
    });
  }

  void addMessage(Message message) {
    messages.add(message);
    db.collection("messages").add(message.toFirestore()).then(
        (documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
    notifyListeners();
  }
}
