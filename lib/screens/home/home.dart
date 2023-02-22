import 'dart:html';

import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/services/book_advice.dart';
import 'package:advices/screens/shared_widgets/BottomBar.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../App/contexts/usersContext.dart';
import '../authentication/register.dart';
import 'homeWidget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  bool userExist = false;
  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }
    _saveDeviceToken();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String channelName = message.data["channelName"];
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      openCall(channelName);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String channelName = message.data["channelName"];
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      openCall(channelName);
    });
    initDynamicLinks(context);
  }

  final AuthProvider _auth = AuthProvider();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    user = await _auth.getCurrentUser();
    setState(() {
      userExist = user != null ? true : false;
    });
    if (userExist) {
      await UsersContext.saveDeviceToken(user!.uid);
    }
  }

  Future<void> openCall(channelName) async {
    if (user == null) {
      return null;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Call(channelName)),
    );
  }

  void initDynamicLinks(BuildContext context) async {
    var currentUri = Uri.base;

    if (window.location.href.contains("/calls")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Calls()),
      );
      return;
    } else if (window.location.href.contains("/register")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
    } else if (window.location.href.contains("/advice_booking")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookAdvice()),
      );
    } else if (window.location.href.contains("/test")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
    } else if (window.location.href.contains("/lawyers")) {
      String url = window.location.href;
      var parts = url.split("/lawyers/");
      String lawyerId = parts[1];

      print(lawyerId);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LawyerProfile(lawyerId, "")),
      );
    }
  }

  openCalls() async {
    // Navigator.pushNamed(context, 'payment');

    // if (kIsWeb && MediaQuery.of(context).size.width > 850.0) {
    //   Uri url = Uri.parse("http://localhost:59445/#/calls");
    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url, webOnlyWindowName: '_self');
    //   } else {
    //     throw "Could not launch $url";
    //   }
    // } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Calls()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: CircularNotchedRectangle(),
      ),
      body: Container(
          height: double.infinity, width: double.infinity, child: HomeWidget()),
    );
  }
}
