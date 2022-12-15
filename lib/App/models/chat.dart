import 'package:intl/intl.dart';

class Chat {
  final String id;
  final List<String> members;
  final List<String>? photoURLs;
  final List<String>? displayNames;
  final String lastMessage;
  final DateTime lastMessageTime;

  Chat(
      {required this.id,
      required this.members,
      this.displayNames,
      this.photoURLs,
      required this.lastMessage,
      required this.lastMessageTime});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime,
      "members": members,
      "photoURLs": photoURLs,
      "displayNames": displayNames,
    };
  }

  static Chat fromJson(json) => Chat(
      id: json['id'] as String? ?? "",
      lastMessage: json['lastMessage'] as String? ?? "",
      lastMessageTime: json['lastMessageTime'].toDate() ?? DateTime.now(),
      members: (json['members'] as List).map((item) => item as String).toList(),
      displayNames:
          (json['displayNames'] as List).map((item) => item as String).toList(),
      photoURLs:
          (json['photoURLs'] as List).map((item) => item as String).toList());

  static Chat fromSnapshot(json) => Chat(
      id: json.id as String? ?? "",
      lastMessage: json.lastMessage as String? ?? "",
      members: (json.members as List).map((item) => item as String).toList(),
      displayNames:
          (json.displayNames as List).map((item) => item as String).toList(),
      photoURLs:
          (json.photoURLs as List).map((item) => item as String).toList(),
          
      lastMessageTime: json.lastMessageTime ?? DateTime.now(),
          
          
          );
}
