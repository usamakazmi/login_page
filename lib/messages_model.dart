// To parse this JSON data, do
//
//     final messagesModel = messagesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<MessagesModel> messagesModelFromJson(String str) => List<MessagesModel>.from(json.decode(str).map((x) => MessagesModel.fromJson(x)));

String messagesModelToJson(List<MessagesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessagesModel {
  MessagesModel({
    required this.text,
    required this.sendtime,
    required this.senderName,
    required this.who,
    required this.senderId,
    required this.receiverId,
  });

  String text;
  int sendtime;
  String senderName;
  String who;
  String senderId;
  String receiverId;

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
    text: json["text"],
    sendtime: json["sendtime"],
    senderName: json["sender_name"],
    who: json["who"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "sendtime": sendtime,
    "sender_name": senderName,
    "who": who,
    "sender_id": senderId,
    "receiver_id": receiverId,
  };
}
