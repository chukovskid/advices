import 'package:advices/services/auth.dart';
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
  await Firebase.initializeApp(
    // // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyAMiXYCdnUTqZItvme_QYds_TTNCLXGmac",
      appId: "1:793184649946:web:9551788cf7f51068cd9be3",
      messagingSenderId: "793184649946",
      projectId: "advices-dev",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    precacheImage(AssetImage("lib/assets/images/background.jpg"), context);
 
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
