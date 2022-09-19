import 'package:advices/screens/profile.dart';
import 'package:advices/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'src/shim/dart_ui.dart' as ui;
// import 'dart:html' as html;

import 'models/user.dart';

/// The html.Element that will be rendered underneath the flutter UI.
// html.Element htmlElement = html.DivElement()
//   ..style.width = '100%'
//   ..style.height = '100%'
//   ..style.backgroundColor = '#fabada'
//   ..style.cursor = 'auto'
//   ..id = 'background-html-view';

// const String _htmlElementViewType = '_htmlElementViewType';

//  adb tcpip 5555
// adb connect 192.168.0.118   // huawei
// adb connect 100.97.197.10   // samsung
//
//  Future<FirebaseApp> initializeFirebase({ SOURCE :    https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
//   required BuildContext context,
// }) async {
//   FirebaseApp firebaseApp = await Firebase.initializeApp();

//   User? user = FirebaseAuth.instance.currentUser;

//   if (user != null) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => Profile(),
//       ),
//     );
//   }

//   return firebaseApp;
// }



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
//  ui.platformViewRegistry.registerViewFactory(
//     _htmlElementViewType,
//     (int viewId) => htmlElement,
//   );

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
        title: "Advices",
        onGenerateRoute: router.generateRoute,
        initialRoute: 'lawyers_profile',
      ),
    );
  }
}
