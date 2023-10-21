// import 'dart:convert';
// import 'dart:io';

// import 'package:advices/App/models/event.dart';
// import 'package:advices/App/models/service.dart';
// import 'package:advices/App/models/user.dart';
// import 'package:advices/App/services/auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/rendering.dart';

// import '../models/call.dart';

// class DatabaseService {
//   DatabaseService(String s,
//       {required EventModel Function(dynamic id, dynamic data) fromDS,
//       required Function(dynamic event) toMap});

//   // // collection reference
//   // final CollectionReference brewCollection =
//   //     Firestore.instance.collection('brews');

//   // static readUsers() => FirebaseFirestore.instance
//   //     .collection("users")
//   //     .snapshots()
//   //     .map((snapshot) =>
//   //         snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())))
//   //     .toList();

//   static Future<FlutterUser?> updateUserData(FlutterUser user) async {
//     CollectionReference lawyers =
//         FirebaseFirestore.instance.collection('lawyers');
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     bool isLawyer = user.isLawyer;
//     if (isLawyer) {
//       await lawyers.doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': "${user.name}  ${user.surname}",
//         'name': user.name,
//         'surname': user.surname,
//         'phoneNumber': user.phoneNumber,
//         'description': user.description,
//         'experience': user.experience,
//         'yearsOfExperience': user.yearsOfExperience,
//         'education': user.education,
//         'lawField': user.lawField,
//       });
//     }
//     await users.doc(user.uid).set({
//       'uid': user.uid,
//       'email': user.email,
//       'displayName': user.displayName.isNotEmpty
//           ? user.displayName
//           : "${user.name}  ${user.surname}",
//       'name': user.name,
//       'surname': user.surname,
//       'phoneNumber': user.phoneNumber,
//       'isLawyer': user.isLawyer,
//       'photoURL': user.photoURL,
//     });

//     print(user);
//     return user;
//   }

//   static Future<FlutterUser?> getUser(String userId) async {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     final snapshot = await users.doc(userId).get();
//     // if (snapshot.exists) {
//     var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
//     return flutterUser;
//     // }
//     // return null;
//   }

//   static Future<FlutterUser?> getLawyer(String lawyerId) async {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('lawyers');
//     final snapshot = await users.doc(lawyerId).get();
//     // if (snapshot.exists) {
//     var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
//     return flutterUser;
//     // }
//     // return null;
//   }

//   static Stream<Iterable<FlutterUser>> getAllUsers() {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     final snapshots = users.snapshots();
//     var flutterUsers = snapshots.map((snapshot) =>
//         snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
//     return flutterUsers;
//   }

// ////// SERVICES
//   ///
//   static Future<Service> getService(String seviceId) async {
//     CollectionReference services =
//         FirebaseFirestore.instance.collection('services');
//     final snapshot = await services.doc(seviceId).get();
//     var service = Service.fromJson(snapshot.data()!);
//     return service;
//   }

//   static Stream<Iterable<Service>> getAllServices() {
//     CollectionReference services =
//         FirebaseFirestore.instance.collection('services');
//     var filteredServices = services.where("area", isNotEqualTo: 2).snapshots();

//     // final snapshots = filteredservices.orderBy('name').snapshots();
//     var flutterLaw = filteredServices.map(
//         (snapshot) => snapshot.docs.map((doc) => Service.fromJson(doc.data())));
//     return flutterLaw;
//   }

//   static Stream<Iterable<Service>> getAllServicesByArea(int area) {
//     CollectionReference services =
//         FirebaseFirestore.instance.collection('services');
//     var filteredServices = services.where("area", isEqualTo: area).snapshots();

//     // final snapshots = filteredservices.orderBy('name').snapshots();
//     var flutterLaw = filteredServices.map(
//         (snapshot) => snapshot.docs.map((doc) => Service.fromJson(doc.data())));
//     return flutterLaw;
//   }

//   static Future<void> saveServicesForLawyer(
//       String uid, List<Service?> newServices) async {
//     CollectionReference services = FirebaseFirestore.instance
//         .collection('lawyers')
//         .doc(uid)
//         .collection("services");

//     if (newServices.isNotEmpty) {
//       List<String> selectedServicesIds = [];
//       for (int i = 0; i < newServices.length; i++) {
//         Service selectedService =
//             Service.fromJson(jsonDecode(newServices[i].toString()));
//         print(selectedService);
//         selectedServicesIds.add(selectedService.id);

//         // TODO delete the collection before adding the this
//         await services.doc(selectedService.id).set({
//           "id": selectedService.id,
//           "area": selectedService.area,
//           "name": selectedService.name,
//         });
//       }
//       print(selectedServicesIds);
//       await saveServicesForLawyerAsArray(selectedServicesIds, uid);
//     }
//   }

//   static Future<void> saveServicesForLawyerAsArray(
//       List<String> servicesIds, String uid) async {
//     DocumentReference lawyerRef =
//         FirebaseFirestore.instance.collection('lawyers').doc(uid);
//     await lawyerRef.update({"services": servicesIds});
//   }

// //// EVENTS
//   /// Events
//   ///

//   static Future<void> saveEvent(
//       lawyerId, title, description, DateTime dateTime) async {
//     // save call for cleint
//     final AuthService _auth = AuthService();
//     User? client = await _auth.getCurrentUser();
//     String channelName = lawyerId + "-" + client?.uid;

//     CollectionReference pendingCallsClient = FirebaseFirestore.instance
//         .collection("users")
//         .doc(client?.uid)
//         .collection("pendingCalls");
//     pendingCallsClient.doc(channelName).set({
//       "clientId": client?.uid,
//       "lawyerId": lawyerId,
//       "channelName": channelName,
//       "title": title,
//       "description": description,
//       "dateCreated": DateTime.now().millisecondsSinceEpoch,
//       "startDate": dateTime,
//       "open": false
//     });

//     // save call for lawyer
//     CollectionReference lawyerPendingCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(lawyerId)
//         .collection("pendingCalls");
//     lawyerPendingCalls.doc(channelName).set({
//       "clientId": client?.uid,
//       "lawyerId": lawyerId,
//       "channelName": channelName,
//       "title": title,
//       "description": description,
//       "dateCreated": DateTime.now().millisecondsSinceEpoch,
//       "startDate": dateTime,
//       "open": false
//     });
//   }

//   static Future<List<DateTime>> getAllEventsDateTIme(
//       lawyerId, DateTime date) async {
//     List<EventModel> data = [];
//     List<DateTime> dataDateTime = [];
//     DateTime endDate = date.add(Duration(days: 1));
//     CollectionReference pendingCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(lawyerId)
//         .collection("pendingCalls");
//     var calls = pendingCalls
//         .where("startDate", isGreaterThan: date)
//         .where("startDate", isLessThan: endDate);
//     await calls.get().then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         data.add(EventModel.fromJson(doc.data()));
//       });
//     });
//     data.toList().forEach((element) {
//       dataDateTime.add(element.startDate);
//     });
//     return dataDateTime;
//   }

//   static Stream<List<EventModel>> getAllEventsStream() {
//     CollectionReference events =
//         FirebaseFirestore.instance.collection('events');
//     final snapshots = events.orderBy('title').snapshots();
//     var flutterEvents = snapshots.map((snapshot) =>
//         snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList());
//     return flutterEvents;
//   }

//   static Stream<Iterable<EventModel>> getAllEvents(uid) {
//     CollectionReference calls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(uid)
//         .collection('pendingCalls');

//     // var filteredCalls = calls.doc(uid).collection("open");
//     final orderedCalls = calls.orderBy("open"); // TODO Use to order calls
//     final snapshots = calls.snapshots();
//     var userCalls = snapshots.map((snapshot) =>
//         snapshot.docs.map((doc) => EventModel.fromJson(doc.data())));
//     return userCalls;
//   }

// ///// Lawyers
//   /// Lawyers
//   ///

//   static Stream<Iterable<FlutterUser>> getFilteredLawyers(String lawId) {
//     CollectionReference lawyers =
//         FirebaseFirestore.instance.collection("lawyers");
//     var filteredLawyers = lawyers.where("services", arrayContains: lawId);
//     final snapshots = filteredLawyers.snapshots();
//     var flutterUsers = snapshots.map((snapshot) =>
//         snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
//     return flutterUsers;
//   }

//   ///// Calls
//   /// Calls
//   ///

//   static Future<Map<String, dynamic>?> callUser(String channelName, String receiverId) async {
//     try {
//       HttpsCallable callable =
//           FirebaseFunctions.instance.httpsCallable('callUser');
//       // dynamic resp = await callable.call();

//       dynamic resp = await callable.call(<String, dynamic>{
//         "receiverId": receiverId,
//         "channelName": channelName,
//       });

//       Map<String, dynamic> res = {
//         "receiverId": receiverId,
//         "channelName": channelName,
//       };
//       return res;
//     } catch (e) {
//       // print(e);
//       return null;
//     }
//   }
  
  
  
//   // HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('callUser');
//   // dynamic resp = await callable.call(<String, dynamic>{
//   //   "receiverId": receiverId,
//   //   "channelName": channelName,
//   // });
//   // print("result: ${resp.data}");
//   // }

//   static Future<String> updateAsOpenCallForUsers(lawyerId, clientId) async {
//     // final AuthService _auth = AuthService();
//     // User? user = await _auth.getCurrentUser();
//     String channelName = lawyerId + "-" + clientId;

//     CollectionReference clientCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(clientId)
//         .collection("pendingCalls");

//     CollectionReference lawyerCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(lawyerId)
//         .collection("pendingCalls");

//     // save call for client
//     clientCalls.doc(channelName).update({
//       "dateOpened": DateTime.now().millisecondsSinceEpoch,
//       "open": true
//       // TODO ADD collection of users that are inside this call
//     });

//     // save call for lawyer
//     lawyerCalls.doc(channelName).update(
//         {"dateOpened": DateTime.now().millisecondsSinceEpoch, "open": true});

//     return channelName;
//   }

//   static Future<String> updateAsClosedCallForUsers(lawyerId, clientId) async {
//     String channelName = lawyerId + "-" + clientId;

//     CollectionReference clientCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(clientId)
//         .collection("pendingCalls");

//     CollectionReference lawyerCalls = FirebaseFirestore.instance
//         .collection("users")
//         .doc(lawyerId)
//         .collection("pendingCalls");

//     // save call for client
//     clientCalls.doc(channelName).update(
//         {"dateOpened": DateTime.now().millisecondsSinceEpoch, "open": false});

//     // save call for lawyer
//     lawyerCalls.doc(channelName).update(
//         {"dateOpened": DateTime.now().millisecondsSinceEpoch, "open": false});

//     return channelName;
//   }

//   static Stream<Iterable<Call>> getOpenCallForUsers(uid) {
//     CollectionReference calls = FirebaseFirestore.instance.collection("calls");

//     var filteredCalls = calls.doc(uid).collection("open");

//     final snapshots = filteredCalls.snapshots();
//     var userCalls = snapshots.map(
//         (snapshot) => snapshot.docs.map((doc) => Call.fromJson(doc.data())));
//     return userCalls;
//   }

//   static Future<void> closeCall(channellName) async {
//     List<String> lawyerIdandclientId = channellName.split("-");
//     String lawyerId = lawyerIdandclientId[0];
//     String clientId = lawyerIdandclientId[1];

//     print(lawyerId);
//     print(clientId);
//     // CollectionReference calls = FirebaseFirestore.instance.collection("calls");

//     // await calls.doc(lawyerId).collection("open").doc(clientId).delete();
//     // await calls.doc(clientId).collection("open").doc(lawyerId).delete();

//     await updateAsClosedCallForUsers(lawyerId, clientId);

//     return null;
//   }

//   //// TOKEN
//   /// Tokens
//   ///

//   static Future<void> saveDeviceToken(String uid) async {
//     final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//     CollectionReference users = FirebaseFirestore.instance.collection("users");

//     String? fcmToken = await _fcm.getToken();

//     // Save it to Firestore
//     if (fcmToken != null) {
//       var tokens = users.doc(uid).collection('tokens');

//       await tokens.doc(fcmToken).set({
//         'token': fcmToken,
//         'createdAt': DateTime.now().millisecondsSinceEpoch, // optional
//         'platform': Platform.operatingSystem // optional
//       });
//     }
//   }
// }
