import 'package:advices/screens/authentication/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late BuildContext _context;

  setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<T?> navigateTo<T extends Object>(Widget page) {
    return Navigator.push<T>(
      _context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void navigateAndReplaceWith(Widget page) {
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: (_) => page));
  }

  void navigateAndRemoveUntil(Widget page) {
    Navigator.pushAndRemoveUntil(
        _context,
        MaterialPageRoute(builder: (_) => page),
        (Route<dynamic> route) => false);
  }

  Future<void> privateNav(Widget page) async {
    User? user = await _auth.currentUser;
    if (user == null) {
      Navigator.push(
          _context, MaterialPageRoute(builder: (_) => SignIn()));
    } else {
      Navigator.push(
          _context, MaterialPageRoute(builder: (_) => page));
    }
  }
}
