import 'package:advices/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/law.dart';
import 'database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  final userStream = FirebaseAuth.instance.authStateChanges();
  // final user = FirebaseAuth.instance.currentUser;
//////  https://firebase.flutter.dev/docs/auth/usage/     Razgledaj ova!!
  ///FirebaseAuth.instance
  // .userChanges() // <----
  // .listen((User? user) {
  //   if (user == null) {
  //     print('User is currently signed out!');
  //   } else {
  //     print('User is signed in!');
  //   }
  // });

  // auth change user stream
  Stream<FlutterUser> get user {
    return _auth
        .authStateChanges()
        .map((firebaseUser) => _userFromFirebaseUser(firebaseUser!));
  }

  // sign out
  Future signOut() async {
    try {
      googleSignOut();
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
    print(user);

    FlutterUser? fUser = await DatabaseService.getUser(user.uid);
    // print(user);
    return fUser;
  }

  // create user obj based on firebase user
  FlutterUser _userFromFirebaseUser(User user) {
    return FlutterUser(uid: user.uid, email: '');
  }

  // sign in Anon
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

  // sign in with email and password
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

  // register with email and password
  Future registerWithEmailAndPassword(
      FlutterUser newFUser, List<Law?> lawAreas) async {
    print(lawAreas);
    try {
      // const email = newFUser.email;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: newFUser.email, password: newFUser.password);
      print(credential.user?.uid);
      User? user = credential.user;
      if (user != null) {
        await user.reload();
      }
      if (user == null) return null;

      print(user.uid);
      DatabaseService.saveLawAreasForLawyer(user.uid, lawAreas);
      newFUser.uid = user.uid;
      FlutterUser? newFlutterUsere =
          await DatabaseService.updateUserData(newFUser);
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

  /// Google Sign in
  ///
  ///

  GoogleSignIn _googleSignIn = GoogleSignIn(
      // scopes: <String>[
      //   'email',
      //   'https://www.googleapis.com/auth/fitness.activity.read',
      // ],
      );

  Future<dynamic> silentSignIn() async {
    await _googleSignIn.signInSilently().then((result) async {
      await result!.authentication.then((googleKey) async {
        print(googleKey.accessToken.toString().substring(0, 8) + "...");
      });
    }).catchError((err) {
      googleSignIn();
      return false;
    });
  }

  Future<void> googleSignIn() async {
    try {
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser);
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredentials);

      FlutterUser newUser = FlutterUser(
        displayName: googleUser.displayName ?? "No Name",
        email: googleUser.email,
        photoURL: googleUser.photoUrl ?? "No photoUrl",
        uid: userCredentials.user?.uid ?? googleUser.id,
      );
      FlutterUser? fUser = await DatabaseService.updateUserData(newUser);
    } on FirebaseAuthException catch (e) {
      // handle error
      print(e);
    }
  }

  Future<void> googleSignOut() async {
    bool isSignedInGoogle = await googleIsSignIn();
    if (isSignedInGoogle) {
      await _googleSignIn.disconnect();
    }
  }

  Future<bool> googleIsSignIn() => _googleSignIn.isSignedIn();

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }


   Future<void> signOutWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }


  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
