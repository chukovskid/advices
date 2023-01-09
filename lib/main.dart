import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'App/contexts/authContext.dart';
import 'App/helpers/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  if (kIsWeb) {
    // await Firebase.initializeApp(
    //   options: FirebaseOptions(
    //     apiKey: dotenv.env['GOOGLE_API_KEY'].toString(),
    //     authDomain: "advices-dev.firebaseapp.com",
    //     appId: "1:793184649946:web:9551788cf7f51068cd9be3",
    //     messagingSenderId: "793184649946",
    //     projectId: "advices-dev",
    //   ),
    // );
  } else {
    // await Firebase.initializeApp();
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
      value: AuthContext().user,
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
