import 'dart:collection';

import 'package:flutter/material.dart';

const apiKey =
    'pk_test_51LqfHUH6waKuk26ulU4pHpQU6fssmDlG1UYk4jrFNO0iu2gBYgz2vOyQ74Dwla8YDOJ3k8A51xK9jmyZqyFlYUa900SVxa5x2B';
const nikesPriceId = 'price_1LrkUPH6waKuk26ucUMu99hm';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'Roboto',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Roboto',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color.fromRGBO(193, 225, 243, 0.7),
  borderRadius: BorderRadius.circular(30.0),
  border: Border.all(color: Colors.white),
);

const profileHeader =
    TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold);
const helpTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
);

const lawyersCardHeader =
    TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold);
const lawyersCardTextStyle = TextStyle(color: Colors.black, fontSize: 12.0);

const lightBlueColor = Color.fromRGBO(107, 119, 141, 1);
const mediumBlueColor = Color.fromRGBO(38, 56, 89, 1);
const darkBlueColor = const Color.fromRGBO(23, 34, 59, 1);
const orangeColor = const Color.fromRGBO(225, 103, 104, 1);
const darkGreenColor = const Color(0xff032229);
const lightGreenColor = const Color(0xff5bc9bf);
const advokatGreenColor = const Color(0xff1c4746);
const backgroundColorLaws = [advokatGreenColor,Color.fromARGB(255, 254, 254, 254)];
const backgroundColorLawsMobile = [Color(0xff1c4746),darkGreenColor];

// const backgroundColor = [orangeColor,lightBlueColor, darkGreenColor];
const backgroundColor = [
  Colors.white60,
  Color.fromARGB(255, 211, 218, 228),
  darkGreenColor
];
const urgentColor = Color.fromARGB(255, 218, 144, 109);
const greyGreenColor = Color.fromARGB(255, 188, 190, 182);
const transperentBlackColor = Color.fromARGB(83, 41, 41, 41);
const whiteColor = Color.fromARGB(255, 241, 245, 255);

// Text Style
const textStylePayingOptions = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.bold,
    fontSize: 10);

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
