import 'package:advices/screens/laws.dart';
import 'package:advices/screens/authentication/register.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/home.dart';
import 'package:advices/screens/lawyerProfile.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:flutter/material.dart';

import '../examples/basic/join_channel_video/join_channel_video.dart';
import '../screens/authentication/authentication.dart';
import '../screens/calendar/add_event.dart';
import '../screens/calendar/calendar.dart';
import '../screens/call/call.dart';
import '../screens/selectDateTime.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
    case 'areas':
      return MaterialPageRoute(builder: (context) => Laws());
    case 'lawyers':
      return MaterialPageRoute(
          builder: (context) =>
              Lawyers(lawArea: "ednakvostId")); // TODO this is not right
    // case 'lawyers_profile':
    //   return MaterialPageRoute(builder: (context) => LawyerProfile());
    case 'selectDate':
      return MaterialPageRoute(builder: (context) => CalendarPage());
    case 'addEvent':
      return MaterialPageRoute(builder: (context) => AddEventPage());
    case 'sign_in':
      return MaterialPageRoute(builder: (context) => SignIn());
    case 'register':
      return MaterialPageRoute(builder: (context) => Register());
    case 'auth':
      return MaterialPageRoute(builder: (context) => Authenticate());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
