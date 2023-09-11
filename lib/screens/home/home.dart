import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
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
import '../authentication/authentication_redirect.dart';
import '../authentication/lawyerBasedRedirect.dart';
import '../authentication/register.dart';
import '../call/callMethods.dart';
import '../call/demoCall.dart';
import '../payment/web/calls_timer_popup.dart';
import 'homeWidget.dart';
import 'lawyerHomeWidget.dart';

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
  _saveDeviceToken() async {
    user = await _auth.getCurrentUser();
    if (user != null) {
      await UsersContext.saveDeviceToken(user!.uid);
    }
  }

  Future<void> openCall(channelName) async {
    if (user == null) {
      return null;
    }
    EventModel event = await CallEventsContext.getEvent(channelName);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Call(event)),
    );
  }

  void initDynamicLinks(BuildContext context) async {
    String uri = '';

    if (kIsWeb) {
      uri = Uri.base.toString();
      if (uri.contains("/success_payment")) {
        // Not used but custom dynamic links are working (publish function)
        String url = uri;
        var parts = url.split("/success_payment/");
        if (parts.length > 1) {
          var ids = parts[1].split("/");
          if (ids.length > 1) {
            String chatId = ids[0];
            String messageId = ids[1];
            print(chatId);
            print(messageId);
            // _chatProvider.payForMessage(chatId, messageId);
          }
        }
      } else if (uri.contains("/call")) {
        String url = uri;
        var parts = url.split("/call/");
        String channelName = parts[1];
        print(channelName);

        openCallNew(channelName);
      } else if (uri.contains("/calls")) {
        Future.delayed(Duration(seconds: 2), () {
          showPopup(context);
        });

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

  Future<void> openCallNew(channelName) async {
    print("Jou will join with this channelName : $channelName");
    Map<String, dynamic>? result = await CallMethods.makeCloudCall(channelName);
    if (result!['token'] != null) {
      // THIS IS WORKING ON WEB AND ANDROID!
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AuthRedirect(
                  authenticatedWidget: DemoCall(channelName),
                  // JoinChannelVideo(
                  //   token: result['token'],
                  //   channelId: result['channelId'],
                  // ),
                )),
      );
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
        height: double.infinity,
        width: double.infinity,
        child: LawyerBasedRedirect(
          lawyerWidget: LawyerHomeWidget(),
          nonLawyerWidget: HomeWidget(),
        ),
      ),
    );
  }
}
