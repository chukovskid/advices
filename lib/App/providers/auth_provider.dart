import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../contexts/lawyersContext.dart';
import '../contexts/usersContext.dart';
import '../models/service.dart';
import '../models/user.dart';
import '../services/googleAuth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  final userStream = FirebaseAuth.instance.authStateChanges();

  Stream<FlutterUser?> get user {
    return _auth
        .authStateChanges()
        .asyncMap((firebaseUser) => _userFromFirebaseUser(firebaseUser!));
  }

  Future<bool> isUserLawyer(User user) async {
    FlutterUser? fUser = await UsersContext.getUser(user.uid);
    return fUser.isLawyer;
  }

  Future signOut() async {
    try {
      GoogleAuthService.googleSignOut();
      _auth.currentUser;
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    User? user = _auth.currentUser;
    return user;
  }

  Future<FlutterUser?> getMyProfileInfo() async {
    User? user = _auth.currentUser;
    if (user == null) return null;
    FlutterUser? fUser = await UsersContext.getUser(user.uid);
    return fUser;
  }

  FlutterUser _userFromFirebaseUser(User user) {
    return FlutterUser(uid: user.uid, email: '');
  }

  Future signInAnon() async {
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(FlutterUser flutUser) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: flutUser.email, password: flutUser.password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      FlutterUser newFUser, List<Service?> services) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: newFUser.email, password: newFUser.password);
      User? user = credential.user;
      if (user != null) {
        await user.reload();
      }
      if (user == null) return null;
      await signInWithEmailAndPassword(newFUser);
      print(user.uid);
      newFUser.uid = user.uid;
      await UsersContext.updateUserData(newFUser);
      await LawyersContext.saveServicesForLawyer(user.uid, services);

      return newFUser;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  /// Firebase store data
  ///
  ///
  Future<void> storeTokenData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> removeToken() async {
    return await storage.delete(key: "token");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
