import 'dart:collection';

import 'package:advices/App/models/event.dart';
import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/App/services/database.dart';
// import 'package:firebase_helpers/firebase_helpers.dart';
// import 'package:firebasestarter/core/presentation/providers/providers.dart';
// import 'package:firebasestarter/features/events/data/models/app_event.dart';
// import 'package:firebasestarter/features/events/data/services/event_firestore_service.dart';
import 'package:flutter/material.dart';
// import 'package:firebasestarter/core/presentation/res/routes.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../App/contexts/callEventsContext.dart';
import '../../App/helpers/CustomCircularProgressIndicator.dart';

// import '../../../../core/presentation/res/colors.dart';
// import '../../../../core/presentation/res/sizes.dart';

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late LinkedHashMap<DateTime, List<EventModel>> _groupedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  @override
  void didChangeDependencies() {
    // context.read(pnProvider).init();
    super.didChangeDependencies();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<EventModel> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(
          event.startDate.year, event.startDate.month, event.startDate.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    });
  }

  List<dynamic> _getEventsForDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase starter'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: () => {}
              //Navigator.pushNamed(context, AppRoutes.profile),
              )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: CallEventsContext.getAllEventsStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<EventModel> events = snapshot.data;
              _groupEvents(events);
              DateTime selectedDate = _selectedDay;
              final _selectedEvents = _groupedEvents[selectedDate] ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDay),
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      eventLoader: _getEventsForDay,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      weekendDays: [6],
                      headerStyle: HeaderStyle(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        headerMargin: const EdgeInsets.only(bottom: 8.0),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          // borderRadius:
                          //     BorderRadius.circular(Size.zero),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                      calendarStyle: CalendarStyle(),
                      calendarBuilders: CalendarBuilders(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text(
                      DateFormat('EEEE, dd MMMM, yyyy').format(selectedDate),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = _selectedEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                            .format(event.startDate)),
                        onTap: () => {},
                        // // Navigator.pushNamed(
                        //     context, AppRoutes.viewEvent,
                        //     arguments: event),
                        trailing: IconButton(
                            icon: Icon(Icons.edit), onPressed: () => {}
                            // Navigator.pushNamed(
                            //   context,
                            //   AppRoutes.editEvent,
                            //   arguments: event,
                            // ),
                            ),
                      );
                    },
                  ),
                ],
              );
            }
            return CustomCircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddEventPage()),
          // );
          //   Navigator.pushNamed(context, Router.addEvent,
          //       arguments: _selectedDay);
        },
      ),
    );
  }
}
