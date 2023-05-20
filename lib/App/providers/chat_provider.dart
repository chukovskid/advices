import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:advices/App/contexts/usersContext.dart';
import 'package:advices/App/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/userChat.dart';
import 'auth_provider.dart';

class ChatProvider with ChangeNotifier {
  final AuthProvider _auth = AuthProvider();
  final UsersContext _usersContext = UsersContext();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String userId, String message, String? chatId) async {
    try {
      final fUser = await UsersContext.getUser(userId);
      final refMessages =
          _firestore.collection('conversation/messages/$chatId');
      final now = DateTime.now();
      final newMessage = Message(
        chatId: chatId!,
        message: message,
        senderId: userId,
        createdAt: now,
        open: false,
        photoURL: "",
        displayName: fUser.displayName,
      );
      await refMessages
          .doc(now.microsecondsSinceEpoch.toString())
          .set(newMessage.toMap());
      print(chatId);
      final refChat = _firestore.collection('conversation/groups/chats');
      await refChat.doc(chatId).update({
        "senderId": userId,
        "lastMessage": message,
        "lastMessageTime": DateTime.now(),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> createNewChat(List<String> userIds) async {
    final user = await _auth.getCurrentUser();
    if (userIds.contains(user!.uid)) {
      return "GroupChat";
    }
    userIds.add(user.uid);
    var chatId = userIds.join("-");
    final refChat = _firestore.collection('conversation/groups/chats');
    final chats = refChat.where("members", isEqualTo: userIds).get();
    bool chatExists = false;
    await chats.then(
      (res) => {
        if (res.size > 0) {chatExists = true, chatId = res.docs.last.id}
      },
      onError: (e) => print("Error completing: $e"),
    );
    if (chatExists == true) {
      return chatId;
    }
    final membersDisplayNames = <String>[];
    final membersPhotoURLs = <String>[];
    for (var userId in userIds) {
      final user = await UsersContext.getUser(userId);
      membersDisplayNames.add(user.displayName);
      membersPhotoURLs.add(user.photoURL);
      final refUserChats =
          _firestore.collection('conversation/userChats/$userId');
      refUserChats.doc(chatId).set({
        "id": chatId,
        "contacts": userIds,
        // "lastMessage": "Почнете муабет",
        // "lastMessageTime": DateTime.now(),
        "members": userIds,
        "photoURLs": membersPhotoURLs,
        "displayNames": membersDisplayNames
      });
    }
    final newChat = Chat(
        id: chatId,
        lastMessage: "Почнете муабет!",
        lastMessageTime: DateTime.now(),
        members: userIds,
        displayNames: membersDisplayNames,
        photoURLs: membersPhotoURLs);
    await refChat.doc(chatId).set(newChat.toMap());
    return chatId;
  }

  static Stream<Iterable<Message>> getMessagesStreamForChat(String chatId) {
    print("get messages for Chat");
    CollectionReference services =
        FirebaseFirestore.instance.collection('conversation/messages/$chatId');
    var filteredServices =
        services.orderBy("createdAt", descending: true).limit(30).snapshots();
    print("filteredServices $filteredServices");
    var message = filteredServices.map(
        (snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())));
    return message;
  }

  static Future<List<String>> getUserChats(String userId) async {
    CollectionReference userChats =
        FirebaseFirestore.instance.collection('conversation/userChats/$userId');
    QuerySnapshot querySnapshot = await userChats.get();
    List<UserChat> allData =
        querySnapshot.docs.map((doc) => UserChat.fromJson(doc.data())).toList();
    List<String> chatIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return chatIds;
  }

  static Stream<Iterable<Chat>> getChats(String userId) {
    CollectionReference userChats =
        FirebaseFirestore.instance.collection('conversation/groups/chats');
    var snapshotUserChats =
        userChats.where('members', arrayContains: userId).snapshots();
    var filteredUserChats = snapshotUserChats.map(
        (snapshot) => snapshot.docs.map((doc) => Chat.fromJson(doc.data())));
    return filteredUserChats;
  }

  static Stream<Chat> getChat(String chatId) {
    CollectionReference chats =
        FirebaseFirestore.instance.collection('conversation/groups/chats');
    return chats
        .doc(chatId)
        .snapshots()
        .map((snapshot) => Chat.fromJson(snapshot.data()!));
  }

  String getOtherUserId(String chatId, String currentUserId) {
    List<String> ids = chatId.split("-");
    if (ids.length != 2) {
      throw Exception('Invalid chat ID format');
    }
    if (ids[0] == currentUserId) {
      return ids[1];
    } else if (ids[1] == currentUserId) {
      return ids[0];
    } else {
      throw Exception('Current user ID not found in chat ID');
    }
  }

}
