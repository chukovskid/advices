import 'dart:html';

import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/shared_widgets/BottomBar.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../App/contexts/authContext.dart';
import '../../App/contexts/usersContext.dart';
import '../authentication/register.dart';
import 'laws.dart';

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

  final AuthContext _auth = AuthContext();
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
      // await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Calls()),
      );
      return;
    } else if (window.location.href.contains("/register")) {
      // await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
    } else if (window.location.href.contains("/test")) {
      // await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
    } else if (window.location.href.contains("/lawyers")) {
      // await Future.delayed(Duration(seconds: 1));
      String url = window.location.href;
      var parts = url.split("/lawyers/");
      String lawyerId = parts[1];

      print(lawyerId);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LawyerProfile(lawyerId, "")),
      );
    }

// sreda 11 Davor, Natasa technical (.net)
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      print('///// Dynamic Link' + dynamicLinkData.link.toString());
      print('///// fragment' + dynamicLinkData.link.fragment);
      if (dynamicLinkData.link.fragment == "/register") {
        await Future.delayed(Duration(seconds: 1));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      } else if (dynamicLinkData.link.fragment == "/calls") {
        await Future.delayed(Duration(seconds: 1));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Calls()),
        );
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
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
      //       appBar: BaseAppBar(
      //   appBar: AppBar(),
      // ),
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: CircularNotchedRectangle(),
      ),
      // floatingActionButton: userExist
      //     ? FloatingActionButton(
      //         onPressed: openCalls,
      //         tooltip: 'Create',
      //         backgroundColor: lightGreenColor,
      //         // child: const Text("lawyer",),
      //         child: const Icon(
      //           Icons.call,
      //           color: Colors.white,
      //         ),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      // floatingActionButton: _next(),
      body: Container(
          // image
          height: double.infinity,
          width: double.infinity,
          child: Laws()

          // Image.network(
          //     "https://images.unsplash.com/photo-1505664063603-28e48ca204eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
          //     height: 45,
          //     width: 45,
          //     fit: BoxFit.fitHeight),
          ),
    );
  }

  Widget _next() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            height: 80,
            child: FittedBox(
              child: FloatingActionButton.extended(
                label: Text('      Lets talk...    '),
                heroTag: "settingsBtn",
                onPressed: () => {
                  // DatabaseService.saveLawAreasForLawyerAsArray();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Laws()),
                  )
                },
                backgroundColor: Color.fromRGBO(107, 119, 141, 1),
                elevation: 0,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            height: 80,
            child: FittedBox(
              child: FloatingActionButton.extended(
                label: Text('      Open calls...    '),
                heroTag: "openCalls",
                onPressed: openCalls,
                backgroundColor: Color.fromRGBO(107, 119, 141, 1),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
