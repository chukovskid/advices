import 'package:advices/screens/authentication/register.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:flutter/material.dart';
import '../../screens/home/home.dart';
import '../../screens/home/laws.dart';
import '../../screens/home/lawyers.dart';
import '../../screens/payment/stripe_payment.dart';
import '../../screens/authentication/authentication.dart';
import '../../screens/calendar/calendar.dart';
import '../../screens/chat/screens/mobile_layout_screen.dart';
import '../../screens/chat/screens/web_layout_screen.dart';
import '../../screens/chat/utils/responsive_layout.dart';

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
          builder: (context) =>
              LawyerProfile('Lk37HV68oaPxOA8AHpNqcSoFgEA3', ""));
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
    case 'chat':
      return MaterialPageRoute(builder: (context) => ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),);
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
