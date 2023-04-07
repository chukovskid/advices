import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

import 'package:advices/App/contexts/callEventsContext.dart';
import 'package:flutter/foundation.dart';
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
import '../../App/models/event.dart';
import '../authentication/register.dart';
import '../payment/web/calls_timer_popup.dart';
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
    EventModel event = await CallEventsContext.getEvent(channelName);
    // get event with this channel name.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Call(event)),
    );
  }

  void initDynamicLinks(BuildContext context) async {
    var currentUri = Uri.base;
    String uri = '';

    if (kIsWeb) {
      uri = Uri.base.toString();
      if (uri.contains("/calls")) {
        Future.delayed(Duration(seconds: 2), () {
          showPopup(context);
        });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Calls()),
        // );
        return;
      } else if (uri.contains("/register")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      } else if (uri.contains("/advice_booking")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookAdvice()),
        );
      } else if (uri.contains("/test")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      } else if (uri.contains("/lawyers")) {
        String url = uri;
        var parts = url.split("/lawyers/");
        String lawyerId = parts[1];
        print(lawyerId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LawyerProfile(lawyerId, "")),
        );
      }
    }
  }

  void showPopup(BuildContext context) {
    print("Show Popup");
    showDialog(
      context: context,
      builder: (context) {
        // Create the AlertDialog
        return AlertDialog(
            content: SingleChildScrollView(
          child: Container(
            // width: double.maxFinite,
            child: CallsTimerPopupWidget(),
          ),
        ));
      },
    );
    Future.delayed(Duration(seconds: 4), () {
      redirectToWebsite("https://advices.page.link/home");
    });
  }

  void redirectToWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.inAppWebView, webOnlyWindowName: "_self");
    } else {
      throw 'Could not launch $url';
    }
  }

  openCalls() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Calls()));
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
