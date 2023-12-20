import 'package:cloud_firestore/cloud_firestore.dart';

class Message implements Comparable<Message> {
  String authorId;
  String authorName;
  String text;
  DateTime dateTime;

  Message(
      {required this.authorId,
      required this.authorName,
      required this.text,
      required this.dateTime});

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Message(
      authorId: data?['authorId'] ?? "",
      authorName: data?['authorName'] ?? data?['author'],
      text: data?['text'],
      dateTime: data?['dateTime'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "authorId": authorId,
      "authorName": authorName,
      "text": text,
      "dateTime": Timestamp.fromDate(dateTime),
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is Message) {
      return text == other.text &&
          authorId == other.authorId &&
          dateTime == other.dateTime;
    }
    return false;
  }

  @override
  int get hashCode => text.hashCode ^ authorId.hashCode ^ dateTime.hashCode;

  @override
  int compareTo(Message other) {
    return dateTime.compareTo(other.dateTime);
  }
}
