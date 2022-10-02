import 'package:advices/services/auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      // // Replace with actual values
      options: FirebaseOptions(
        apiKey: "AIzaSyAMiXYCdnUTqZItvme_QYds_TTNCLXGmac",
        authDomain: "advices-dev.firebaseapp.com",
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
    initDynamicLinks(context);

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
        title: "Advices",
        onGenerateRoute: router.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

void initDynamicLinks(BuildContext context) {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  dynamicLinks.onLink.listen((dynamicLinkData) {
    print('///// Dynamic Link' + dynamicLinkData.link.toString());

    Navigator.pushNamed(context, "areas");
  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
}

// import 'dart:async';

// import 'package:advices/config/agora.config.dart';
// import 'package:advices/services/database.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// const appId = "03f0c2c7973949b3afe5e475f15a350e";
// const token =
//     "00603f0c2c7973949b3afe5e475f15a350eIABYvY5vO7jO4iPVDMdA2CIA1Xs58ZD+2QtgE6awK1VtmWK47TwAAAAAIgDS67t85Ok6YwQAAQB0pjljAgB0pjljAwB0pjljBAB0pjlj";
// const channel = "Lk37HV68oaPxOA8AHpNqcSoFgEA3+BegoHlxHbccfYh0wpMCjtWgrUFE2";

// void main() => runApp(MaterialApp(home: MyApp()));

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   late RtcEngine _engine;

//   @override
//   void initState() {
//     initAgora();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _engine.destroy();
//     closeCall();
//     super.dispose();
//   }

//   Future<void> closeCall() async {
//     await _engine.leaveChannel();
//     await _engine.destroy();
//     await DatabaseService.closeCall(channelId);
//   }

//   Future<void> initAgora() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();

//     //create the engine
//     _engine = await RtcEngine.create(appId);
//     await _engine.leaveChannel();

//     await _engine.enableVideo();
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print("local user $uid joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         userJoined: (int uid, int elapsed) {
//           print("remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print("remote user $uid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );

//     await _engine.joinChannel(token, channel, null, 0);
//   }

//   // Create UI with local view and remote view
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? RtcLocalView.SurfaceView()
//                     : CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid!,
//         channelId: channel,
//       );
//     } else {
//       return Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
