import 'dart:io';
import 'package:advices/App/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersContext {
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
    return user;
  }

  static Future<FlutterUser> getUser(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final snapshot = await users.doc(userId).get();
    // if (snapshot.exists) {
    var flutterUser = FlutterUser.fromJson(snapshot.data()!);
    return flutterUser;
    // }
    // return null;
  }

  static Stream<Iterable<FlutterUser>> getAllUsers() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final snapshots = users.snapshots();
    var flutterUsers = snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FlutterUser.fromJson(doc.data())));
    return flutterUsers;
  }

  static Future<void> saveDeviceToken(String uid) async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    CollectionReference users = FirebaseFirestore.instance.collection("users");

    String? fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = users.doc(uid).collection('tokens');

      await tokens.doc(fcmToken).set({
        'token': fcmToken,
        'createdAt': DateTime.now().millisecondsSinceEpoch, // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  static Future<String?> getImageUrl(String imagePath) async {
    try {
      final storageReference = FirebaseStorage.instance.ref(imagePath);
      final String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error in getImageUrl: $e");
      return null;
    }
  }
}
