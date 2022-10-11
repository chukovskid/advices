import 'package:advices/screens/laws.dart';
import 'package:advices/screens/authentication/register.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/home.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/screens/lawyers.dart';
import 'package:flutter/material.dart';

import '../examples/basic/join_channel_video/join_channel_video.dart';
import '../payment/stripe_payment.dart';
import '../screens/authentication/authentication.dart';
import '../screens/calendar/add_event.dart';
import '../screens/calendar/calendar.dart';
import '../screens/call/call.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
    case 'areas':
      return MaterialPageRoute(builder: (context) => Laws());
    case 'lawyers':
      return MaterialPageRoute(
          builder: (context) =>
              Lawyers(service: "buyAndSaleId")); // TODO this is not right
    case 'lawyers_profile':
      return MaterialPageRoute(
          builder: (context) => LawyerProfile('cNbw66J36wMvUZdjES7H25HXAGo2'));
    case 'selectDate':
      return MaterialPageRoute(builder: (context) => CalendarPage());
    case 'sign_in':
      return MaterialPageRoute(builder: (context) => SignIn());
    case 'register':
      return MaterialPageRoute(builder: (context) => Register());
    case 'auth':
      return MaterialPageRoute(builder: (context) => Authenticate());
    case 'payment':
      return MaterialPageRoute(builder: (context) => StripePayment());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
