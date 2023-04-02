import 'package:advices/App/contexts/usersContext.dart';
import 'package:advices/App/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleAuthService {
  final storage = new FlutterSecureStorage();
  final userStream = FirebaseAuth.instance.authStateChanges();

  static GoogleSignIn _googleSignIn =
      GoogleSignIn(clientId: dotenv.env['GOOGLE_API_KEY'].toString()
          // scopes: <String>[
          //   'email',
          //   'https://www.googleapis.com/auth/fitness.activity.read',
          // ],
          // Use Scopes to get diferent informations for the user from google

          );

  static Future<void> googleSignOut() async {
    bool isSignedInGoogle = await googleIsSignIn();
    if (isSignedInGoogle) {
      await _googleSignIn.disconnect();
    }
  }

  static Future<bool> googleIsSignIn() => _googleSignIn.isSignedIn();

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    UserCredential userCredential;
    GoogleSignInAccount? googleUser;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        userCredential = await auth.signInWithPopup(authProvider);
        user = userCredential.user;
        print(userCredential);

        FlutterUser newUser = FlutterUser(
          displayName: userCredential.user?.displayName ?? "No Name",
          email: userCredential.user?.email ?? "No email",
          photoURL: userCredential.user?.photoURL ?? "No photoUrl",
          uid: userCredential.user?.uid ?? "googleUser.id",
        );
        FlutterUser? fUser = await UsersContext.updateUserData(newUser);
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          userCredential = await auth.signInWithCredential(credential);
          user = userCredential.user;

          print(userCredential);

          FlutterUser newUser = FlutterUser(
            displayName: googleUser.displayName ?? "No Name",
            email: googleUser.email,
            photoURL: googleUser.photoUrl ?? "No photoUrl",
            uid: userCredential.user?.uid ?? googleUser.id,
          );
          FlutterUser? fUser = await UsersContext.updateUserData(newUser);
          return user;
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
          return null;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
          return null;
        }
      }
    }

    return user;
  }

  static Future<void> signOutWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
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
