import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/App/providers/chat_provider.dart';
import 'package:advices/App/providers/dar_provider.dart';
import 'package:advices/App/providers/form_builder_provider.dart';
import 'package:advices/App/providers/navigation_provider.dart';
import 'package:advices/App/providers/services_provider.dart';
import 'package:flutter/material.dart';
import 'App/contexts/authContext.dart';
import 'App/helpers/router.dart' as router;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'App/providers/count_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => DogovorZaDarProvider()),
        ChangeNotifierProvider(create: (_) => FormBuilderProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationProvider _navigationProvider = NavigationProvider();
    _navigationProvider.setContext(context);

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // precacheImage(AssetImage("lib/assets/images/background.jpg"), context);
    return StreamProvider.value(
      value: AuthProvider().user,
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
