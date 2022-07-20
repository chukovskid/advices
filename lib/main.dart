import 'package:advices/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/user.dart';

//  adb tcpip 5555
// adb connect 192.168.0.118   // huawei
// adb connect 100.97.197.10   // samsung
//
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      // // Replace with actual values
      options: FirebaseOptions(
        apiKey: "AIzaSyAMiXYCdnUTqZItvme_QYds_TTNCLXGmac",
        appId: "1:793184649946:web:9551788cf7f51068cd9be3",
        messagingSenderId: "793184649946",
        projectId: "advices-dev",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // precacheImage(AssetImage("lib/assets/images/background.jpg"), context);

    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Named Routing",
        onGenerateRoute: router.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       // // Replace with actual values
//       // options: FirebaseOptions(
//       //   apiKey: "AIzaSyAMiXYCdnUTqZItvme_QYds_TTNCLXGmac",
//       //   appId: "1:793184649946:web:9551788cf7f51068cd9be3",
//       //   messagingSenderId: "793184649946",
//       //   projectId: "advices-dev",
//       // ),
//       );

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FlutterBase',
//       home: Scaffold(
//         body: MessageHandler(),
//       ),
//     );
//   }
// }

// class MessageHandler extends StatefulWidget {
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }

// class _MessageHandlerState extends State<MessageHandler> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isIOS) {
//       // iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//       //   print(data);
//       //   _saveDeviceToken();
//       // });

//     } else {
//       _saveDeviceToken();
//     }

 
//     Future.delayed(Duration(milliseconds: 100), () async {
//       await AppNotifications.init();
//     });
  
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _handleMessages(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepOrange,
//         title: Text('FCM Push Notifications'),
//       ),
//     );
//   }

//   /// Get the token, save it to the database for current user
//   _saveDeviceToken() async {
//     // Get the current user
//     String uid = 'jeffd23';
//     // FirebaseUser user = await _auth.currentUser();

//     // Get the token for this device
//     String? fcmToken = await _fcm.getToken();

//     // Save it to Firestore
//     if (fcmToken != null) {
//       var tokens =
//           _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

//       await tokens.set({
//         'token': fcmToken,
//         'createdAt': FieldValue.serverTimestamp(), // optional
//         'platform': Platform.operatingSystem // optional
//       });
//     }
//   }

//   /// Subscribe the user to a topic
//   _subscribeToTopic() async {
//     // Subscribe the user to a topic
//     _fcm.subscribeToTopic('puppies');
//   }
// }
