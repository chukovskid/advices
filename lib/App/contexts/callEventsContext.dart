import 'package:advices/App/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class CallEventsContext {
  CallEventsContext(String s,
      {required EventModel Function(dynamic id, dynamic data) fromDS,
      required Function(dynamic event) toMap});

  static Future<void> saveEvent(
      lawyerId, title, description, DateTime dateTime) async {
    // save call for cleint
    final AuthProvider _auth = AuthProvider();
    User? client = await _auth.getCurrentUser();
    String channelName = lawyerId + "+" + client?.uid;

    CollectionReference pendingCallsClient = FirebaseFirestore.instance
        .collection("users")
        .doc(client?.uid)
        .collection("pendingCalls");
    pendingCallsClient.doc(channelName).set({
      "cleintId": client?.uid,
      "lawyerId": lawyerId,
      "channelName": channelName,
      "title": title,
      "description": description,
      "dateCreated": DateTime.now(),
      "startDate": dateTime,
      "open": false
    });

    // save call for lawyer
    CollectionReference lawyerPendingCalls = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("pendingCalls");
    lawyerPendingCalls.doc(channelName).set({
      "cleintId": client?.uid,
      "lawyerId": lawyerId,
      "channelName": channelName,
      "title": title,
      "description": description,
      "dateCreated": DateTime.now(),
      "startDate": dateTime,
      "open": false
    });

    // Create room for lawyer and client
    final ChatProvider _chatProvider = ChatProvider();
    String chatId = await _chatProvider.createNewChat([lawyerId]);
    // Send message to client from the lawyer
    _chatProvider.sendMessage(lawyerId, title, chatId); // TODO: Change message
    _chatProvider.sendMessage(
        lawyerId, description, chatId); // TODO: Change message
    _chatProvider.sendMessage(
        lawyerId, dateTime.toString(), chatId); // TODO: Change message
  }

  static Future<List<DateTime>> getAllLEventsDateTIme(
      lawyerId, DateTime date) async {
    List<EventModel> data = [];
    List<DateTime> dataDateTime = [];
    DateTime endDate = date.add(Duration(days: 1));
    CollectionReference pendingCalls = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("pendingCalls");
    var calls = pendingCalls
        .where("startDate", isGreaterThan: date)
        .where("startDate", isLessThan: endDate);
    await calls.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        data.add(EventModel.fromJson(doc.data()));
      });
    });
    data.toList().forEach((element) {
      dataDateTime.add(element.startDate);
    });
    return dataDateTime;
  }

  static Stream<List<EventModel>> getAllEventsStream() {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    final snapshots = events.orderBy('title').snapshots();
    var flutterEvents = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList());
    return flutterEvents;
  }

  static Stream<Iterable<EventModel>> getAllLEvents(uid) {
    CollectionReference calls = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('pendingCalls');

    // var filteredCalls = calls.doc(uid).collection("open");
    final orderedCalls = calls.orderBy("open"); // TODO Use to order calls
    final snapshots = calls.snapshots();
    var userCalls = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => EventModel.fromJson(doc.data())));
    return userCalls;
  }

  static Future<EventModel> getEvent(String channelName) async {
    // get logged user uid
    final AuthProvider _auth = AuthProvider();
    User? user = await _auth.getCurrentUser();
    String uid = user?.uid ?? "";

    CollectionReference events = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('pendingCalls');

    // write a where clause to filter for a specific channelName
    Query filteredCalls = events.where("channelName", isEqualTo: channelName);

    // write an orderBy clause to sort by a field
    // Query orderedCalls = filteredCalls.orderBy("startTime");

    QuerySnapshot snapshot = await filteredCalls.limit(1).get();

    // return the first event that matches the given channelName
    if (snapshot.docs.isNotEmpty) {
      EventModel event = EventModel.fromJson(snapshot.docs.first);
      return event;
    } else {
      return EventModel(
          title: "Не постои овој евент",
          description: "Пробајте повторно",
          startDate: DateTime.now(),
          channelName: '',
          open: false);
    }
  }

  static Future<Map<String, dynamic>?> callUser(
      String channelName, String receiverId) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('callUser');
      // dynamic resp = await callable.call();

      dynamic resp = await callable.call(<String, dynamic>{
        "receiverId": receiverId,
        "channelName": channelName,
      });

      Map<String, dynamic> res = {
        "receiverId": receiverId,
        "channelName": channelName,
      };
      return res;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  static Future<void> closeCall(channellName) async {
    List<String> lawyerIdandclientId = channellName.split("+");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];
    await updateAsClosedCallForUsers(lawyerId, clientId);
    return null;
  }

  static Future<String> updateAsClosedCallForUsers(lawyerId, clientId) async {
    String channelName = lawyerId + "+" + clientId;

    CollectionReference clientCalls = FirebaseFirestore.instance
        .collection("users")
        .doc(clientId)
        .collection("pendingCalls");

    CollectionReference lawyerCalls = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("pendingCalls");

    // save call for client
    clientCalls.doc(channelName).update(
        {"dateOpened": DateTime.now().millisecondsSinceEpoch, "open": false});

    // save call for lawyer
    lawyerCalls.doc(channelName).update(
        {"dateOpened": DateTime.now().millisecondsSinceEpoch, "open": false});

    return channelName;
  }
}
