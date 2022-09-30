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
