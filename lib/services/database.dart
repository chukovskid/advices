import 'dart:convert';
import 'dart:io';

import 'package:advices/models/law.dart';
import 'package:advices/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';

import '../models/call.dart';

class DatabaseService {
  // // collection reference
  // final CollectionReference brewCollection =
  //     Firestore.instance.collection('brews');

  static Future<FlutterUser?> updateUserData(FlutterUser user) async {
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection('lawyers');
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    bool isLawyer = user.isLawyer;
    if (isLawyer) {
      await lawyers.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': "${user.name}  ${user.surname}",
        'name': user.name,
        'surname': user.surname,
        'phoneNumber': user.phoneNumber,
        'description': user.description,
        'experience': user.experience,
        'yearsOfExperience': user.yearsOfExperience,
        'education': user.education,
        'lawField': user.lawField,
      });
    }
    await users.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName.isNotEmpty
          ? user.displayName
          : "${user.name}  ${user.surname}",
      'name': user.name,
      'surname': user.surname,
      'phoneNumber': user.phoneNumber,
      'isLawyer': user.isLawyer,
      'photoURL': user.photoURL,
    });

    print(user);
    return user;
  }

  static saveLawAreasForLawyerAsArray(
      List<String> lawAreasIds, String uid) async {
    DocumentReference lawyerRef =
        FirebaseFirestore.instance.collection('lawyers').doc(uid);
    await lawyerRef.update({"lawAreas": lawAreasIds});
  }

  static Future<void> saveLawAreasForLawyer(
      String uid, List<Law?> newLawAreas) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference lawAreas = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        // .doc("69kDEqpjX7aeulnh6QsCt1uH8l23")
        .collection("lawAreas");

    if (newLawAreas.isNotEmpty) {
      List<String> selectedLawsIds = [];
      for (int i = 0; i < newLawAreas.length; i++) {
        Law selectedLaw = Law.fromJson(jsonDecode(newLawAreas[i].toString()));
        print(selectedLaw);
        selectedLawsIds.add(selectedLaw.id);

        // TODO delete the collection before adding the this
        await lawAreas.doc(selectedLaw.id).set({
          "id": selectedLaw.id,
          "index": selectedLaw.index,
          "name": selectedLaw.name,
        });
      }
      print(selectedLawsIds);
      await saveLawAreasForLawyerAsArray(selectedLawsIds, uid);
    }
  }

  static Future<void> clearLawAreaCollection(
      CollectionReference lawAreas) async {
    final batch = FirebaseFirestore.instance.batch();
    var snapshots = await lawAreas.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
  }

  static Future<FlutterUser?> getUser(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final snapshot = await users.doc(userId).get();
    // if (snapshot.exists) {
    var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
    return flutterUser;
    // }
    // return null;
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

  static readUsers() => FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())))
      .toList();

  static Stream<Iterable<FlutterUser>> getAllUsers() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final snapshots = users.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }

  static Stream<Iterable<Law>> getAllLaws() {
    CollectionReference laws = FirebaseFirestore.instance.collection('laws');
    final snapshots = laws.orderBy('name').snapshots();
    var flutterLaw = snapshots.map(
        (snapshot) => snapshot.docs.map((doc) => Law.fromJson(doc.data())));
    return flutterLaw;
  }

  static Stream<Iterable<Law>> getLawAreasForLawyer(String uid) {
    CollectionReference laws = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        .collection("lawAreas");
    final snapshots = laws.orderBy('name').snapshots();
    var flutterLaw = snapshots.map(
        (snapshot) => snapshot.docs.map((doc) => Law.fromJson(doc.data())));
    return flutterLaw;
  }

  static Stream<Iterable<FlutterUser>> getFilteredLawyers(String lawId) {
    print("++++++++++++LAW AREAA: $lawId");
    //.collection('lasw').doc(lawId).
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection("lawyers");
    var filteredLawyers = lawyers.where("lawAreas", arrayContains: lawId);
    // .where("experience", isEqualTo: "exp");
    final snapshots = filteredLawyers.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }

  static Future<String> saveOpenCallForUsers(lawyerId, clientId) async {
    CollectionReference calls = FirebaseFirestore.instance.collection("calls");
    String channelName = lawyerId + "+" + clientId;
    // save call for lawyer
    calls.doc(lawyerId).collection("open").doc(channelName).set({
      "channelName": channelName,
      "clientId": clientId,
      "DateOpened": DateTime.now().millisecondsSinceEpoch
    });

    // save call for client
    calls.doc(clientId).collection("open").doc(channelName).set({
      "channelName": channelName,
      "lawyerId": lawyerId,
      "DateOpened": DateTime.now().millisecondsSinceEpoch
    });

    return channelName;
  }

  static Stream<Iterable<Call>> getOpenCallForUsers(uid) {
    CollectionReference calls = FirebaseFirestore.instance.collection("calls");

    var filteredCalls = calls.doc(uid).collection("open");

    // const q = query(calls, where("open", ">", uid), orderBy("channelName"));

    // .where("experience", isEqualTo: "exp");
    final snapshots = filteredCalls.snapshots();
    var userCalls = snapshots.map(
        (snapshot) => snapshot.docs.map((doc) => Call.fromJson(doc.data())));
    return userCalls;
  }

  static Future<void> closeCall(channellName) async {
    List<String> lawyerIdandclientId = channellName.split("+");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];

    print(lawyerId);
    print(clientId);
    CollectionReference calls = FirebaseFirestore.instance.collection("calls");

    await calls.doc(lawyerId).collection("open").doc(clientId).delete();
    await calls.doc(clientId).collection("open").doc(lawyerId).delete();

    return null;
  }

  // user data from snapshots
  // UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return UserData(
  //       uid: uid,
  //       name: snapshot.data['name'],
  //       sugars: snapshot.data['sugars'],
  //       strength: snapshot.data['strength']);
  // }

  // // get user doc stream
  // Stream<UserData> get userData {
  //   return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  // }

  static Future<void> saveDeviceToken(String uid) async {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;


        CollectionReference users = FirebaseFirestore.instance.collection("users");

    // Get the current user
    // String uid = 'Nn0z19OZbmVhsg6GCpiDe186b4c2';

    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String? fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = users
          .doc(uid)
          .collection('tokens');

      await tokens.doc(fcmToken).set({
        'token': fcmToken,
        'createdAt': DateTime.now().millisecondsSinceEpoch, // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

}
