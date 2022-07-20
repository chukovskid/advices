import 'package:advices/screens/call/calls.dart';
import 'package:advices/screens/laws.dart';
import 'package:advices/screens/authentication/authentication.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import 'floating_footer_btns.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}'); // TODO firebase dunctions should get receaver id

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      print('A new onMessageOpenedApp event was published!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Authenticate()),
      );
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
    });
  }

  final AuthService _auth = AuthService();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    await DatabaseService.saveDeviceToken();
  }

  Future<void> _checkIfLogedIn() async {
    String? token = await _auth.getToken();
    print("token: $token");
    if (token != null) {
      setState(() {});
    }
  }

  Future<void> getFruit() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('testFunction');
    final results = await callable();
    var fruit =
        results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person_outline_sharp),
            label: Text(''),
            onPressed: _navigateToAuth,
          ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _next(),
      body: Container(
        // image
        height: double.infinity,
        width: double.infinity,
        child: Image.network(
            "https://images.unsplash.com/photo-1505664063603-28e48ca204eb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
            height: 45,
            width: 45,
            fit: BoxFit.fitHeight),
      ),
    );
  }

  Widget _next() {
    return Column(
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
                heroTag: "settingsBtn",
                onPressed: () => {
                  // DatabaseService.saveLawAreasForLawyerAsArray();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calls()),
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
                label: Text('      Call function on firebase...    '),
                heroTag: "settingsBtn",
                onPressed: () => {
                  // DatabaseService.saveLawAreasForLawyerAsArray();
                  // getFruit()
                  _saveDeviceToken()
                },
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
