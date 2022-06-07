import 'dart:convert';

import 'package:advices/models/law.dart';
import 'package:advices/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<void> saveLawAreasForLawyer(String uid, List<Law?> newLawAreas) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference lawAreas = FirebaseFirestore.instance
        .collection('lawyers')
        .doc(uid)
        // .doc("69kDEqpjX7aeulnh6QsCt1uH8l23")
        .collection("lawAreas");

    if (newLawAreas.isNotEmpty) {
      for (int i = 0; i < newLawAreas.length; i++) {
        Law selectedLaw = Law.fromJson(jsonDecode(newLawAreas[i].toString()));
        print(selectedLaw);
        await lawAreas.doc(selectedLaw.id).set({
          "id": selectedLaw.id,
          "index": selectedLaw.index,
          "name": selectedLaw.name,
        });
      }
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
    if (snapshot.exists) {
      var flutterUser = await FlutterUser.fromJson(snapshot.data()!);
      return flutterUser;
    }
    return null;
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
    //.collection('lasw').doc(lawId).
    CollectionReference lawyers =
        FirebaseFirestore.instance.collection("lawyers");
    var filteredLawyers = lawyers.where("experience", isEqualTo: "exp");
    final snapshots = filteredLawyers.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
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

}
