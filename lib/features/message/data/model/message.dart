// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final int? id;
  final int senderId;
  final int receiverId;
  final String messageText;
  final int isRead; // 0 for unread, 1 for read
  final String sentAt; // Timestamp when the message was sent

  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    this.isRead = 0,
    String? sentAt,
  }) : sentAt = sentAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'isRead': isRead,
      'sentAt': sentAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as int : null,
      senderId: map['senderId'] as int,
      receiverId: map['receiverId'] as int,
      messageText: map['messageText'] as String,
      isRead: map['isRead'] as int,
      sentAt: map['sentAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
