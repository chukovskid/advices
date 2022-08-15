import 'package:advices/services/auth.dart';
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
        title: "Named Routing",
        onGenerateRoute: router.generateRoute,
        initialRoute: 'selectDate', 
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












// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'package:table_calendar/table_calendar.dart';

// import 'screens/calendar/add_event.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Calendar',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//       routes: {
//         "add_event": (_) => AddEventPage(),
//       },
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   CalendarController _controller;
//   late Map<DateTime, List<dynamic>> _events;
//   late List<dynamic> _selectedEvents;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CalendarController();
//     _events = {};
//     _selectedEvents = [];
//   }

//   Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
//     Map<DateTime, List<dynamic>> data = {};
//     allEvents.forEach((event) {
//       DateTime date = DateTime(
//           event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
//       if (data[date] == null) data[date] = [];
//       data[date].add(event);
//     });
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Calendar'),
//       ),
//       body: StreamBuilder<List<EventModel>>(
//           stream: eventDBS.streamList(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<EventModel> allEvents = snapshot.data;
//               if (allEvents.isNotEmpty) {
//                 _events = _groupEvents(allEvents);
//               } else {
//                 _events = {};
//                 _selectedEvents = [];
//               }
//             }
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   TableCalendar(
//                     events: _events,
//                     initialCalendarFormat: CalendarFormat.week,
//                     calendarStyle: CalendarStyle(
//                         canEventMarkersOverflow: true,
//                         todayColor: Colors.orange,
//                         selectedColor: Theme.of(context).primaryColor,
//                         todayStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18.0,
//                             color: Colors.white)),
//                     headerStyle: HeaderStyle(
//                       centerHeaderTitle: true,
//                       formatButtonDecoration: BoxDecoration(
//                         color: Colors.orange,
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                       formatButtonTextStyle: TextStyle(color: Colors.white),
//                       formatButtonShowsNext: false,
//                     ),
//                     startingDayOfWeek: StartingDayOfWeek.monday,
//                     onDaySelected: (date, events) {
//                       setState(() {
//                         _selectedEvents = events;
//                       });
//                     },
//                     builders: CalendarBuilders(
//                       selectedDayBuilder: (context, date, events) => Container(
//                           margin: const EdgeInsets.all(4.0),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               color: Theme.of(context).primaryColor,
//                               borderRadius: BorderRadius.circular(10.0)),
//                           child: Text(
//                             date.day.toString(),
//                             style: TextStyle(color: Colors.white),
//                           )),
//                       todayDayBuilder: (context, date, events) => Container(
//                           margin: const EdgeInsets.all(4.0),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               color: Colors.orange,
//                               borderRadius: BorderRadius.circular(10.0)),
//                           child: Text(
//                             date.day.toString(),
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ),
//                     calendarController: _controller,
//                   ),
//                   ..._selectedEvents.map((event) => ListTile(
//                         title: Text(event.title),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => EventDetailsPage(
//                                         event: event,
//                                       )));
//                         },
//                       )),
//                 ],
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => Navigator.pushNamed(context, 'add_event'),
//       ),
//     );
//   }
// }
