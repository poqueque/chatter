import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String author;
  String text;
  DateTime dateTime;

  Message({required this.author, required this.text, required this.dateTime});

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Message(
      author: data?['author'],
      text: data?['text'],
      dateTime: data?['dateTime'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "author": author,
      "text": text,
      "dateTime": Timestamp.fromDate(dateTime),
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is Message) {
      return text == other.text &&
          author == other.author &&
          dateTime == other.dateTime;
    }
    return false;
  }
}
