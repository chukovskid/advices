import 'package:advices/screens/authentication/register.dart';
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

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // precacheImage(AssetImage("lib/assets/images/background.jpg"), context);
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Advices",
        onGenerateRoute: router.generateRoute,
        initialRoute: 'payment',
      ),
    );
  }
}


// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'dart:async';

// import 'package:advices/services/firebase_dynamic_links.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // iOS requires you run in release mode to test dynamic links ("flutter run --release").
//   await Firebase.initializeApp();

//   runApp(
//     MaterialApp(
//       title: 'Dynamic Links Example',
//       routes: <String, WidgetBuilder>{
//         '/': (BuildContext context) => _MainScreen(),
//         '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
//       },
//     ),
//   );
// }

// class _MainScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<_MainScreen> {
//   String? _linkMessage;
//   bool _isCreatingLink = false;

//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   final String _testString =
//       'To test: long press link and then copy and click from a non-browser '
//       "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
//       'is properly setup. Look at firebase_dynamic_links/README.md for more '
//       'details.';

//   final String DynamicLink = 'https://test-app/helloworld';
//   final String Link = 'https://reactnativefirebase.page.link/bFkn';

//   @override
//   void initState() {
//     super.initState();
//     initDynamicLinks();
//   }

//   Future<void> initDynamicLinks() async {
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       Navigator.pushNamed(context, dynamicLinkData.link.path);
//     }).onError((error) {
//       print('onLink error');
//       print(error.message);
//     });
//   }

//   Future<void> _createDynamicLink(bool short) async {
//     setState(() {
//       _isCreatingLink = true;
//     });

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://reactnativefirebase.page.link',
//       longDynamicLink: Uri.parse(
//         'https://reactnativefirebase.page.link/?efr=0&ibi=io.invertase.testing&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Ftest-app%2Fhelloworld&ofl=https://ofl-example.com',
//       ),
//       link: Uri.parse(DynamicLink),
//       androidParameters: const AndroidParameters(
//         packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
//         minimumVersion: 0,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: 'io.invertase.testing',
//         minimumVersion: '0',
//       ),
//     );

//     Uri url;
//     if (short) {
//       final ShortDynamicLink shortLink =
//           await dynamicLinks.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } else {
//       url = await dynamicLinks.buildLink(parameters);
//     }

//     setState(() {
//       _linkMessage = url.toString();
//       _isCreatingLink = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Dynamic Links Example'),
//         ),
//         body: Builder(
//           builder: (BuildContext context) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   ButtonBar(
//                     alignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: () async {
//                           final String? data = await FirebaseDynamicLinkService
//                               .createDynamicLink(true);
//                           // final Uri? deepLink = data?.link;
//                           print("// Data $data");
//                           // if (data != null) {
//                           //   // ignore: unawaited_futures
//                           //   Navigator.pushNamed(context, deepLink.path);
//                           // }
//                         },
//                         child: const Text('getInitialLink'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final PendingDynamicLinkData? data =
//                               await dynamicLinks
//                                   .getDynamicLink(Uri.parse(Link));
//                           final Uri? deepLink = data?.link;

//                           if (deepLink != null) {
//                             // ignore: unawaited_futures
//                             Navigator.pushNamed(context, deepLink.path);
//                           }
//                         },
//                         child: const Text('getDynamicLink'),
//                       ),
//                       ElevatedButton(
//                         onPressed: !_isCreatingLink
//                             ? () => _createDynamicLink(false)
//                             : null,
//                         child: const Text('Get Long Link'),
//                       ),
//                       ElevatedButton(
//                         onPressed: !_isCreatingLink
//                             ? () => _createDynamicLink(true)
//                             : null,
//                         child: const Text('Get Short Link'),
//                       ),
//                     ],
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (_linkMessage != null) {
//                         await launchUrl(Uri.parse(_linkMessage!));
//                       }
//                     },
//                     onLongPress: () {
//                       Clipboard.setData(ClipboardData(text: _linkMessage));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Copied Link!')),
//                       );
//                     },
//                     child: Text(
//                       _linkMessage ?? '',
//                       style: const TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                   Text(_linkMessage == null ? '' : _testString)
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _DynamicLinkScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Hello World DeepLink'),
//         ),
//         body: const Center(
//           child: Text('Hello, World!'),
//         ),
//       ),
//     );
//   }
// }
