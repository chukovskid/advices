// import 'dart:collection';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../models/event.dart';
// import '../services/database.dart';
// import '../utilities/constants.dart';
// import 'authentication/authentication.dart';

// class SelectDateTime extends StatefulWidget {
//   @override
//   _SelectDateTimeState createState() => _SelectDateTimeState();
// }

// class _SelectDateTimeState extends State<SelectDateTime> {
//   late final PageController _pageController;
//   late final ValueNotifier<List<Event>> _selectedEvents;
//   final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
//   final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
//     equals: isSameDay,
//     hashCode: getHashCode,
//   );
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   late Map<DateTime, List<dynamic>> _events;

//   @override
//   void initState() {
//     super.initState();

//     _getEvents();
//         _events = {};

//     _selectedDays.add(_focusedDay.value);
//     _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
//   }

//   @override
//   void dispose() {
//     _focusedDay.dispose();
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   bool get canClearSelection =>
//       _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

//   List<Event> _getEventsForDay(DateTime day) {
//     return kEvents[day] ?? [];
//   }

//   List<Event> _getEventsForDays(Iterable<DateTime> days) {
//     return [
//       for (final d in days) ..._getEventsForDay(d),
//     ];
//   }

//   List<Event> _getEventsForRange(DateTime start, DateTime end) {
//     final days = daysInRange(start, end);
//     return _getEventsForDays(days);
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       if (_selectedDays.contains(selectedDay)) {
//         _selectedDays.remove(selectedDay);
//       } else {
//         _selectedDays.add(selectedDay);
//       }

//       _focusedDay.value = focusedDay;
//       _rangeStart = null;
//       _rangeEnd = null;
//       _rangeSelectionMode = RangeSelectionMode.toggledOff;
//     });

//     _selectedEvents.value = _getEventsForDays(_selectedDays);
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _focusedDay.value = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _selectedDays.clear();
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });

//     if (start != null && end != null) {
//       _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _getEventsForDay(end);
//     }
//   }

//   _navigateToAuth() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Authenticate()),
//     );
//   }

//   Map<DateTime, List<dynamic>> _getEvents() {
//     List<EventModel> eventData = DatabaseService.getAllLEvents();
//     Map<DateTime, List<dynamic>> data = {};
//     eventData.forEach((event) {
//       DateTime date = DateTime(
//           event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
//       if (data[date] == null) data[date] = [];
//       data[date]?.add(event);
//     });
//     return data;
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Colors.transparent,
//         backgroundColor: Color.fromRGBO(23, 34, 59, 1),
//         elevation: 5.0,
//         actions: <Widget>[
//           FlatButton.icon(
//             textColor: Colors.white,
//             icon: Icon(Icons.person_outline_sharp),
//             label: Text(''),
//             onPressed: _navigateToAuth,
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             flex: 10,
//             child: Stack(
//               children: [
//                 // _next()
//               ],
//             ),
//           )
//         ],
//       ),
//       body: Container(
//         height: double.maxFinite,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromRGBO(107, 119, 141, 1),
//               Color.fromRGBO(38, 56, 89, 1),
//             ],
//             stops: [-1, 2],
//           ),
//         ),
//         child: _table(),
//       ),
//     );
//   }

// ///////
//   Widget _table() {
//     return Card(
//       margin: const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         children: [
//           ValueListenableBuilder<DateTime>(
//             valueListenable: _focusedDay,
//             builder: (context, value, _) {
//               return _CalendarHeader(
//                 focusedDay: value,
//                 clearButtonVisible: canClearSelection,
//                 onTodayButtonTap: () {
//                   setState(() => _focusedDay.value = DateTime.now());
//                 },
//                 onClearButtonTap: () {
//                   setState(() {
//                     _rangeStart = null;
//                     _rangeEnd = null;
//                     _selectedDays.clear();
//                     _selectedEvents.value = [];
//                   });
//                 },
//                 onLeftArrowTap: () {
//                   _pageController.previousPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                   );
//                 },
//                 onRightArrowTap: () {
//                   _pageController.nextPage(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                   );
//                 },
//               );
//             },
//           ),

//           /////////////////////////////////////////////
//           StreamBuilder(
//               stream: DatabaseService.getAllEventsStream(),
//               builder: ((context, snapshot) {
//                 if (snapshot.hasData) {
//                   _events = _getEvents();
//                   return 
               

//           //////
//           TableCalendar(
//             firstDay: kFirstDay,
//             lastDay: kLastDay,
//             focusedDay: _focusedDay.value,
//             headerVisible: false,
//             selectedDayPredicate: (day) => _selectedDays.contains(day),
//             rangeStartDay: _rangeStart,
//             rangeEndDay: _rangeEnd,
//             calendarFormat: _calendarFormat,
//             rangeSelectionMode: _rangeSelectionMode,
//             // eventLoader: _events,
//             // eventLoader: DatabaseService.getAllLEvents().first,
//             eventLoader: _getEventsForDay,
//             holidayPredicate: (day) {
//               // Every 20th day of the month will be treated as a holiday
//               return day.day == 20;
//             },
//             onDaySelected: _onDaySelected,
//             // onRangeSelected: _onRangeSelected,
//             onCalendarCreated: (controller) => _pageController = controller,
//             onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() => _calendarFormat = format);
//               }
//             },
//           );
        
        
        
//         }  else {
//                   return Text("NO dataaaa");
//                 }




//               })),
        
        
        
        
        
//         ////////////////////////////////////////////
        
        
        
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: ValueListenableBuilder<List<Event>>(
//               valueListenable: _selectedEvents,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: ListTile(
//                         onTap: () => print('${value[index]}'),
//                         title: Text('${value[index]}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// ////

// }

// class _CalendarHeader extends StatelessWidget {
//   final DateTime focusedDay;
//   final VoidCallback onLeftArrowTap;
//   final VoidCallback onRightArrowTap;
//   final VoidCallback onTodayButtonTap;
//   final VoidCallback onClearButtonTap;
//   final bool clearButtonVisible;

//   const _CalendarHeader({
//     Key? key,
//     required this.focusedDay,
//     required this.onLeftArrowTap,
//     required this.onRightArrowTap,
//     required this.onTodayButtonTap,
//     required this.onClearButtonTap,
//     required this.clearButtonVisible,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final headerText = "date time";

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           const SizedBox(width: 16.0),
//           SizedBox(
//             width: 120.0,
//             child: Text(
//               headerText,
//               style: TextStyle(fontSize: 26.0),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.calendar_today, size: 20.0),
//             visualDensity: VisualDensity.compact,
//             onPressed: onTodayButtonTap,
//           ),
//           if (clearButtonVisible)
//             IconButton(
//               icon: Icon(Icons.clear, size: 20.0),
//               visualDensity: VisualDensity.compact,
//               onPressed: onClearButtonTap,
//             ),
//           const Spacer(),
//           IconButton(
//             icon: Icon(Icons.chevron_left),
//             onPressed: onLeftArrowTap,
//           ),
//           IconButton(
//             icon: Icon(Icons.chevron_right),
//             onPressed: onRightArrowTap,
//           ),
//         ],
//       ),
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'package:table_calendar/table_calendar.dart';

// // import '../models/event.dart';
// // import 'calendar/event_firestore_service.dart';

// // class SelectDateTime extends StatefulWidget {
// //   @override
// //   _SelectDateTimeState createState() => _SelectDateTimeState();
// // }

// // class _SelectDateTimeState extends State<SelectDateTime> {
// //      CalendarFormat _controller = CalendarFormat.month;
// //   late Map<DateTime, List<dynamic>> _events;
// //   late List<dynamic> _selectedEvents;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = CalendarController();
// //     _events = {};
// //     _selectedEvents = [];
// //   }

// //   Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> allEvents) {
// //     Map<DateTime, List<dynamic>> data = {};
// //     allEvents.forEach((event) {
// //       DateTime date = DateTime(
// //           event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
// //       if (data[date] == null) data[date] = [];
// //       data[date].add(event);
// //     });
// //     return data;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Flutter Calendar'),
// //       ),
// //       body: StreamBuilder<List<EventModel>>(
// //           stream: eventDBS.streamList(),
// //           builder: (context, snapshot) {
// //             if (snapshot.hasData) {
// //               List<EventModel>? allEvents = snapshot.data;
// //               if (allEvents!.isNotEmpty) {
// //                 _events = _groupEvents(allEvents);
// //               } else {
// //                 _events = {};
// //                 _selectedEvents = [];
// //               }
// //             }
// //             return SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: <Widget>[
// //                   TableCalendar(
// //                     events: _events,
// //                     initialCalendarFormat: CalendarFormat.week,
// //                     calendarStyle: CalendarStyle(
// //                         canEventMarkersOverflow: true,
// //                         todayColor: Colors.orange,
// //                         selectedColor: Theme.of(context).primaryColor,
// //                         todayStyle: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 18.0,
// //                             color: Colors.white)),
// //                     headerStyle: HeaderStyle(
// //                       centerHeaderTitle: true,
// //                       formatButtonDecoration: BoxDecoration(
// //                         color: Colors.orange,
// //                         borderRadius: BorderRadius.circular(20.0),
// //                       ),
// //                       formatButtonTextStyle: TextStyle(color: Colors.white),
// //                       formatButtonShowsNext: false,
// //                     ),
// //                     startingDayOfWeek: StartingDayOfWeek.monday,
// //                     onDaySelected: (date, events) {
// //                       setState(() {
// //                         _selectedEvents = events;
// //                       });
// //                     },
// //                     builders: CalendarBuilders(
// //                       selectedDayBuilder: (context, date, events) => Container(
// //                           margin: const EdgeInsets.all(4.0),
// //                           alignment: Alignment.center,
// //                           decoration: BoxDecoration(
// //                               color: Theme.of(context).primaryColor,
// //                               borderRadius: BorderRadius.circular(10.0)),
// //                           child: Text(
// //                             date.day.toString(),
// //                             style: TextStyle(color: Colors.white),
// //                           )),
// //                       todayDayBuilder: (context, date, events) => Container(
// //                           margin: const EdgeInsets.all(4.0),
// //                           alignment: Alignment.center,
// //                           decoration: BoxDecoration(
// //                               color: Colors.orange,
// //                               borderRadius: BorderRadius.circular(10.0)),
// //                           child: Text(
// //                             date.day.toString(),
// //                             style: TextStyle(color: Colors.white),
// //                           )),
// //                     ),
// //                     calendarController: _controller,
// //                   ),
// //                   ..._selectedEvents.map((event) => ListTile(
// //                         title: Text(event.title),
// //                         onTap: () {
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                   builder: (_) => EventDetailsPage(
// //                                         event: event,
// //                                       )));
// //                         },
// //                       )),
// //                 ],
// //               ),
// //             );
// //           }),
// //       floatingActionButton: FloatingActionButton(
// //         child: Icon(Icons.add),
// //         onPressed: () => Navigator.pushNamed(context, 'add_event'),
// //       ),
// //     );
// //   }
// // }