import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color.fromRGBO(193, 225, 243, 0.7),
  borderRadius: BorderRadius.circular(30.0),
  border: Border.all(color: Colors.white),
);



const helpTextStyle =  TextStyle(color: Colors.black, fontSize: 15.0);

const lightBlueColor = Color.fromRGBO(107, 119, 141, 1);
const mediumBlueColor = Color.fromRGBO(38, 56, 89, 1);
const darkBlueColor = const Color.fromRGBO(23, 34, 59, 1);
const orangeColor = const Color.fromRGBO(225, 103, 104, 1);





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