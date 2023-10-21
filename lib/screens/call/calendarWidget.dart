import 'package:advices/screens/call/call.dart';
import 'package:advices/screens/call/customCallCard.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:advices/App/models/event.dart';
import '../../App/contexts/callEventsContext.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'callMethods.dart';

class CalendarWidget extends StatefulWidget {
  final User? user;

  CalendarWidget({Key? key, this.user}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<EventModel> events = [];
  List<EventModel> selectedEvents = [];
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  void loadEvents() {
    CallEventsContext.fetchUserEvents(widget.user!.uid)
        .then((List<EventModel> userEvents) {
      setState(() {
        events = userEvents;
      });
    });
  }

  Future<void> openCall(EventModel call) async {
    Map<String, dynamic>? result =
        await CallMethods.makeCloudCall(call.channelName);
    if (result!['token'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Call(call)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<EventModel>(
          // Default to today's date
          // selectedDay: _selectedDay,
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2031, 12, 31),
          focusedDay: _focusedDay,
          eventLoader: (day) => events
              .where((event) =>
                  event.startDate.year == day.year &&
                  event.startDate.month == day.month &&
                  event.startDate.day == day.day)
              .toList(),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            // Print selected day
            print("Selected day: $selectedDay");

            setState(() {
              _focusedDay = focusedDay;
              selectedEvents = events
                  .where((event) =>
                      event.startDate.year == selectedDay.year &&
                      event.startDate.month == selectedDay.month &&
                      event.startDate.day == selectedDay.day)
                  .toList();
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedEvents.length,
            itemBuilder: (context, index) {
              final event = selectedEvents[index];
              return CustomCardWidget(
                call: event,
                onTapOpenCall: () {
                  openCall(event);
                },
              );
              // ListTile(
              //   title: Text(event.title),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Опис: ${event.description}'),
              //       Text('Има некој: ${event.open}'),
              //       Text('Закажано за: ${event.startDate}'),
              //     ],
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }
}
