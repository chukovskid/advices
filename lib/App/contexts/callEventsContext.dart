import 'dart:async';

import 'package:advices/App/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class CallEventsContext {
  CallEventsContext(String s,
      {required EventModel Function(dynamic id, dynamic data) fromDS,
      required Function(dynamic event) toMap});

  static Future<void> saveEvent(lawyerId, title, description, DateTime dateTime,
      {urgent = false}) async {
    // save call for client
    final AuthProvider _auth = AuthProvider();
    User? client = await _auth.getCurrentUser();
    String channelName = lawyerId + "-" + client?.uid;

    CollectionReference pendingCallsClient = FirebaseFirestore.instance
        .collection("users")
        .doc(client?.uid)
        .collection("pendingCalls");
    pendingCallsClient.doc(channelName).set({
      "clientId": client?.uid,
      "lawyerId": lawyerId,
      "channelName": channelName,
      "dateCreated": DateTime.now(),
      "startDate": dateTime,
    });

    pendingCallsClient
        .doc(channelName)
        .collection('details')
        .doc(channelName)
        .set({
      "title": title,
      "description": description,
      "open": false,
      "urgent": urgent,
    });

    // save call for lawyer
    CollectionReference lawyerPendingCalls = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("pendingCalls");
    lawyerPendingCalls.doc(channelName).set({
      "clientId": client?.uid,
      "lawyerId": lawyerId,
      "channelName": channelName,
      "dateCreated": DateTime.now(),
      "startDate": dateTime,
    });

    lawyerPendingCalls
        .doc(channelName)
        .collection('details')
        .doc(channelName)
        .set({
      "title": title,
      "description": description,
      "open": false,
      "urgent": urgent,
    });
    // Create room for lawyer and client
    final ChatProvider _chatProvider = ChatProvider();
    String chatId = await _chatProvider.createNewChat([lawyerId]);
    // Send message to client from the lawyer
    String message = "$title \n $description \n $dateTime";
    _chatProvider.sendMessage(
        client!.uid, message, chatId); // TODO: Change message
    // _chatProvider.sendMessage(
    //     lawyerId, description, chatId); // TODO: Change message
    // _chatProvider.sendMessage(
    //     lawyerId, dateTime.toString(), chatId); // TODO: Change message
  }

  static Future<List<DateTime>> getAllEventsDateTIme(
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
    await calls.get().then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        var detailsDoc =
            await doc.reference.collection('details').doc('details').get();
        data.add(EventModel.fromJson(doc.data(), detailsDoc.data()));
      }
    });
    data.forEach((element) {
      dataDateTime.add(element.startDate);
    });
    return dataDateTime;
  }

  static Stream<List<EventModel>> getAllEventsStream() {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    final snapshots = events.orderBy('title').snapshots();

    return snapshots.map((snapshot) async {
      var events = <EventModel>[];
      for (var doc in snapshot.docs) {
        var detailsDoc =
            await doc.reference.collection('details').doc(doc.id).get();
        events.add(EventModel.fromJson(doc.data(), detailsDoc.data()));
      }
      return events;
    }).asyncMap((event) => event);
  }

  static Stream<Iterable<EventModel>> getAllEvents(uid) {
    CollectionReference calls = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('pendingCalls');

    final snapshots = calls.snapshots();

    return snapshots.transform<Iterable<EventModel>>(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
          Iterable<EventModel>>.fromHandlers(
        handleData: (QuerySnapshot<Map<String, dynamic>> data,
            EventSink<Iterable<EventModel>> sink) async {
          List<EventModel> eventModels = [];

          for (var doc in data.docs) {
            var detailsDoc =
                await doc.reference.collection('details').doc(doc.id).get();

            if (detailsDoc.exists) {
              eventModels
                  .add(EventModel.fromJson(doc.data(), detailsDoc.data()));
            } else {
              print("No details document for document ID: ${doc.id}");
            }
          }

          sink.add(eventModels);
        },
      ),
    );
  }

  static Future<List<EventModel>> fetchUserEvents(String userId) async {
    List<EventModel> events = [];
    final firestoreInstance = FirebaseFirestore.instance;

    // Fetch all pending calls for this user
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection("users")
        .doc(userId)
        .collection("pendingCalls")
        .get();

    for (var doc in querySnapshot.docs) {
      print('Pending call data: ${doc.data()}');
      Map<String, dynamic> mainData = doc.data() as Map<String, dynamic>;

      // Fetch the details of each pending call
      QuerySnapshot detailsQuerySnapshot =
          await doc.reference.collection("details").get();

      for (var detailDoc in detailsQuerySnapshot.docs) {
        print('Details data: ${detailDoc.data()}');
        Map<String, dynamic> detailsData =
            detailDoc.data() as Map<String, dynamic>;

        // Merge the mainData and detailsData to form the EventModel
        EventModel event = EventModel.fromJson(mainData, detailsData);

        // Add to events list
        events.add(event);
      }
    }

    return events;
  }

  // ...

  static Stream<Iterable<EventModel>> getAllUrgentEvents(uid) {
    CollectionReference calls = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('pendingCalls');
    final snapshots = calls.where("urgent", isEqualTo: true).snapshots();
    return snapshots.transform(
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
          Iterable<EventModel>>.fromHandlers(
        handleData: (QuerySnapshot<Map<String, dynamic>> data,
            EventSink<Iterable<EventModel>> sink) async {
          List<EventModel> eventModels = [];
          for (var doc in data.docs) {
            var docId = doc.id;
            var combinedId = "$docId-$uid";
            var detailsDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .collection('pendingCalls')
                .doc(docId)
                .collection('details')
                .doc(combinedId)
                .get();
            eventModels.add(EventModel.fromJson(doc.data(), detailsDoc.data()));
          }
          sink.add(eventModels);
        },
      ),
    );
  }

  static Future<EventModel> getEvent(String channelName) async {
    // get logged user uid
    final AuthProvider _auth = AuthProvider();
    User? user = await _auth.getCurrentUser();
    String uid = user?.uid ?? "";
    CollectionReference calls = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection('pendingCalls');
    // write a where clause to filter for a specific channelName
    Query filteredCalls = calls.where("channelName", isEqualTo: channelName);
    // write an orderBy clause to sort by a field
    // Query orderedCalls = filteredCalls.orderBy("startTime");
    QuerySnapshot snapshot = await filteredCalls.limit(1).get();
    // return the first event that matches the given channelName
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot detailsSnapshot = await calls
          .doc(snapshot.docs.first.id) // changed to use doc id
          .collection('details')
          .doc(snapshot.docs.first.id) // changed to use doc id
          .get();
      if (detailsSnapshot.exists) {
        EventModel event = EventModel.fromJson(
          snapshot.docs.first.data(),
          detailsSnapshot.data(),
        );
        return event;
      } else {
        return EventModel(
            title: "Не постои овој евент",
            description: "Пробајте повторно",
            startDate: DateTime.now(),
            dateCreated: DateTime.now(),
            channelName: '',
            open: false,
            urgent: false);
      }
    } else {
      return EventModel(
          title: "Не постои овој евент",
          description: "Пробајте повторно",
          startDate: DateTime.now(),
          dateCreated: DateTime.now(),
          channelName: '',
          open: false,
          urgent: false);
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
    List<String> lawyerIdandclientId = channellName.split("-");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];
    await updateAsClosedCallForUsers(lawyerId, clientId);
    return null;
  }

  static Future<String> updateAsClosedCallForUsers(lawyerId, clientId) async {
    String channelName = lawyerId + "-" + clientId;
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

// Lawyer availability feature
//
//
  static Future<void> saveUnavailablePeriod(String lawyerId, DateTime date,
      TimeOfDay startTime, TimeOfDay endTime) async {
    final DateTime startDateTime = DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    final DateTime endDateTime =
        DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);

    CollectionReference unavailablePeriods = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("unavailablePeriods");

    await unavailablePeriods.add({
      "startDate": startDateTime,
      "endDate": endDateTime,
    });
  }

  static Future<List<Map<String, dynamic>>> getWorkingHours(
      String lawyerId) async {
    CollectionReference workingHoursRef = FirebaseFirestore.instance
        .collection("users")
        .doc(lawyerId)
        .collection("workingHours");
    QuerySnapshot snapshot = await workingHoursRef.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
