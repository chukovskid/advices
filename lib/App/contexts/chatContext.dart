import 'dart:convert';
import 'package:advices/App/contexts/authContext.dart';
import 'package:advices/App/contexts/usersContext.dart';
import 'package:advices/App/models/chat.dart';
import 'package:advices/App/models/service.dart';
import 'package:advices/App/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';
import '../models/userChat.dart';

class ChatContext {
  static Future<void> sendMessage(
      String userId, String message, String? chatId) async {
    FlutterUser? fUser = await UsersContext.getUser(
        userId); //TODO change to auth instead of users context
    CollectionReference refMessages =
        FirebaseFirestore.instance.collection('conversation/messages/$chatId');
    print("SendMessage $chatId");
    DateTime now = DateTime.now();
    final Message newMesage = Message(
      chatId: chatId!,
      message: message,
      senderId: userId,
      createdAt: now,
      open: false,
      photoURL: "",
      displayName: fUser!.displayName,
    );
    await refMessages
        .doc(now.microsecondsSinceEpoch.toString())
        .set(newMesage.toMap());
  }

  static Future<String> createNewChat(List<String> userIds) async {
    try {
      bool chatExists = false;
      AuthContext _auth = AuthContext();
      User? user = await _auth.getCurrentUser();
      // if (userIds.contains(user!.uid)) {
      //   return "GroupChat";
      // }
      userIds.add(user!.uid);
      print(userIds);
      String chatId = new DateTime.now().millisecondsSinceEpoch.toString();
      CollectionReference refChat =
          FirebaseFirestore.instance.collection('conversation/groups/chats');
      final chats = refChat.where("members", isEqualTo: userIds).get();
      await chats.then(
        (res) => {
          if (res.size > 0) {chatExists = true, chatId = res.docs.last.id}
        },
        onError: (e) => print("Error completing: $e"),
      );
      if (chatExists == true) {
        return chatId;
      }

      // CollectionReference refChatMembers = FirebaseFirestore.instance
      //     .collection('conversation/groups/chats/$chatId/members');
      List<String> membersDisplayNames = [];
      List<String> membersPhotoURLs = [];
      for (var userId in userIds) {
        FlutterUser user = await UsersContext.getUser(userId);
        membersDisplayNames.add(user.displayName);
        membersPhotoURLs.add(user.photoURL);
        // refChatMembers.doc(userId).set({
        //   "displayName": user.displayName,
        //   "photoURL": user.photoURL,
        //   "email": user.email
        // });
        CollectionReference refUserChats = FirebaseFirestore.instance
            .collection('conversation/userChats/${userId}');
        refUserChats.doc(chatId).set({
          "id": chatId,
          // "createdAt": chatId,
          "contacts": userIds,
        });
      }

      final Chat newChat = Chat(
          id: chatId,
          lastMessage: "All mesages read",
          lastMessageTime: DateTime.now(), 
          members: userIds,
          photoURLs: membersPhotoURLs,
          displayNames: membersDisplayNames);
      refChat.doc(chatId).set(newChat.toMap());

      return chatId;
    } catch (e) {
      return e.toString();
    }
  }

  static Stream<Iterable<Message>> getMessagesStreamForChat(String chatId) {
    print("get messages for Chat");
    CollectionReference services =
        FirebaseFirestore.instance.collection('conversation/messages/$chatId');
    // var filteredServices = services.where("chatId", isEqualTo: chatId).snapshots();
    var filteredServices = services.snapshots();
    print("filteredServices $filteredServices");
    // final snapshots = filteredservices.orderBy('name').snapshots();
    var message = filteredServices.map(
        (snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())));
    return message;
  }

  static Future<List<String>> getUserChats(String userId) async {
    CollectionReference userChats =
        FirebaseFirestore.instance.collection('conversation/userChats/$userId');
    QuerySnapshot querySnapshot = await userChats.get();
    // List<UserChat> allData =
    //     querySnapshot.docs.map((doc) => UserChat.fromJson(doc.data())).toList();

    List<String> chatIds = querySnapshot.docs.map((doc) => doc.id).toList();

    return chatIds;
  }

  static Stream<Iterable<Chat>> getChats(List<String> chatIds) {
    // AuthContext _auth = AuthContext();
    // User? user = await _auth.getCurrentUser();
    CollectionReference userChats =
        FirebaseFirestore.instance.collection('conversation/groups/chats');
    var snapshotUserChats = userChats.snapshots();
    var filteredUserChats = snapshotUserChats.map(
        (snapshot) => snapshot.docs.map((doc) => Chat.fromJson(doc.data())));

// for (var chat in filteredUserChats) {

// }
    return filteredUserChats;
  }
}
