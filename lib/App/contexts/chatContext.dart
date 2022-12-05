import 'dart:convert';
import 'package:advices/App/contexts/authContext.dart';
import 'package:advices/App/contexts/usersContext.dart';
import 'package:advices/App/models/chat.dart';
import 'package:advices/App/models/service.dart';
import 'package:advices/App/models/user.dart';
import 'package:advices/screens/video/config/agora.config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';

class ChatContext {
  static Future<void> sendMessage(
      String userId, String message, String? chatId) async {
    FlutterUser? fUser = await UsersContext.getUser(userId);

    CollectionReference refMessages =
        FirebaseFirestore.instance.collection('conversation/messages/$chatId');

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

  static Future<bool> createNewChat(List<String> userIds) async {
    try {
      String chatId = new DateTime.now().millisecondsSinceEpoch.toString();
      CollectionReference refChat =
          FirebaseFirestore.instance.collection('conversation/groups/chats');

      bool chatExists = false;
      final chats = refChat
          .where("members", arrayContainsAny: ['useerID1', "userID2"]).get();
      // const getCategoryProducts = getDocs(chats);
      await chats.then(
        (res) => {
          print("Successfully completed"),
          if (res.size > 0) {print("is Exist1"), print(res), chatExists = true}
        },
        onError: (e) => print("Error completing: $e"),
      );

      if (chatExists == true) {
        print("is Exist 2");
        // print(chatExists.snapshots());
        return chatExists;
      }

      final Chat newChat = Chat(
          id: chatId,
          members: ['useerID1', "userID2"],
          lastMessage: "All mesages read");
      refChat.doc(chatId).set(newChat.toMap());

      AuthContext _auth = AuthContext();
      User? user = await _auth.getCurrentUser();
      print(user!.uid);
      CollectionReference refUserChats = FirebaseFirestore.instance
          .collection('conversation/groups/userChats/${user.uid}/$chatId');

      // final Chat newUserChat = Chat(
      //     id: chatId,
      //     members: ['useerID1', "userID2"],
      //     lastMessage: "All mesages read");
      refUserChats.doc(chatId).set({
        "id": user!.uid,
        "chats": [user!.uid, "123TestUser"]
      });

      return true;
    } catch (e) {
      return false;
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

  static Stream<Iterable<Message>> getChats(String userId) {
    // AuthContext _auth = AuthContext();
    // User? user = await _auth.getCurrentUser();
    CollectionReference services =
        FirebaseFirestore.instance.collection('conversation/groups/userChats/$userId');
    // var filteredServices = services.where("chatId", isEqualTo: chatId).snapshots();
    var filteredServices = services.snapshots();

    // final snapshots = filteredservices.orderBy('name').snapshots();
    var message = filteredServices.map(
        (snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())));
    return message;
  }

  static Future<FlutterUser?> getLawyer(String lawyerId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lawyers');
    final snapshot = await users.doc(lawyerId).get();
    // if (snapshot.exists) {
    var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
    return flutterUser;
    // }
    // return null;
  }

  static Future<void> saveServicesForLawyer(
      String uid, List<Service?> newServices) async {
    CollectionReference services = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        .collection("services");

    if (newServices.isNotEmpty) {
      List<String> selectedServicesIds = [];
      for (int i = 0; i < newServices.length; i++) {
        Service selectedService =
            Service.fromJson(jsonDecode(newServices[i].toString()));
        print(selectedService);
        selectedServicesIds.add(selectedService.id);

        // TODO delete the collection before adding the this
        await services.doc(selectedService.id).set({
          "id": selectedService.id,
          "area": selectedService.area,
          "name": selectedService.name,
        });
      }
      print(selectedServicesIds);
      await saveServicesForLawyerAsArray(selectedServicesIds, uid);
    }
  }

  static Future<void> saveServicesForLawyerAsArray(
      List<String> servicesIds, String uid) async {
    DocumentReference lawyerRef =
        FirebaseFirestore.instance.collection('lawyers').doc(uid);
    await lawyerRef.update({"services": servicesIds});
  }

  static Stream<Iterable<FlutterUser>> getFilteredLawyers(String lawId) {
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection("lawyers");
    var filteredLawyers = lawyers.where("services", arrayContains: lawId);
    final snapshots = filteredLawyers.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }
}
