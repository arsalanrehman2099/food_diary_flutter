import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? type;
  Timestamp? timestamp;

  Chat({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.type,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'message': message,
      'timestamp': timestamp,
    };
  }

  Chat fromMap(Map chat) {
    return Chat(
      id: chat['id'],
      senderId: chat['senderId'],
      receiverId: chat['receiverId'],
      type: chat['type'],
      message: chat['message'],
      timestamp: chat['timestamp'],
    );
  }
}
