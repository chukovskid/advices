import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../../App/contexts/callEventsContext.dart';

class UnavailablePeriodsWidget extends StatefulWidget {
  final String lawyerId;

  UnavailablePeriodsWidget({required this.lawyerId});

  @override
  _UnavailablePeriodsWidgetState createState() =>
      _UnavailablePeriodsWidgetState();
}

class _UnavailablePeriodsWidgetState extends State<UnavailablePeriodsWidget> {
  String _selectedDate = "";
  String selectedTime = "";
  List<TimeOfDay> _unavailableTimePeriods = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    _getFreeTimePeriodsForDate();
  }

  Future<void> _getFreeTimePeriodsForDate() async {
    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse("$_selectedDate");
    List<DateTime> events =
        await CallEventsContext.getAllEventsDateTIme(widget.lawyerId, selectedDate);
    _unavailableTimePeriods = [];
    events.forEach((element) {
      DateTime substraction = element;
      for (int i = 0; i <= 5; i++) {
        element = element.add(new Duration(minutes: 10));
        _unavailableTimePeriods.add(TimeOfDay.fromDateTime(element));
      }
      for (int i = 0; i <= 5; i++) {
        substraction = substraction.subtract(new Duration(minutes: 10));
        _unavailableTimePeriods.add(TimeOfDay.fromDateTime(substraction));
      }
    });
    print(_unavailableTimePeriods);
  }


  Future<void> showTimePickerWidget(StateSetter setStateDialog) async {
    return await showCustomTimePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        },
        onFailValidation: (context) => print('Unavailable selection'),
        initialTime: TimeOfDay(hour: 6, minute: 10),
        selectableTimePredicate: (time) =>
            time!.minute % 10 == 0 &&
            !_unavailableTimePeriods.contains(time)).then((time) => {
          print(time?.format(context)),
          setState(() => {
                selectedTime = time!.format(context),
              }),
          setStateDialog(() => {
                selectedTime = time!.format(context),
              }),
        });
  }

  Future<void> _saveUnavailablePeriod() async {
    DateTime date = DateFormat("yyyy-MM-dd").parse(_selectedDate);
    TimeOfDay startTime =
        TimeOfDay.fromDateTime(DateFormat("h:mm a").parse(selectedTime));
    TimeOfDay endTime = startTime.replacing(hour: startTime.hour + 1);

    await CallEventsContext.saveUnavailablePeriod(
        widget.lawyerId, date, startTime, endTime);

    // Update the unavailable time periods
    setState(() {
      _unavailableTimePeriods.add(startTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Set Unavailable Periods'),
      ),
      body: Column(
        children: [
          // Date picker
          ListTile(
            title: Text('Select date:'),
            subtitle: Text(_selectedDate),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
                });

                _getFreeTimePeriodsForDate();
              }
            },
          ),
          // Time picker
          ListTile(
            title: Text('Select start time:'),
            subtitle: Text(selectedTime),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setStateDialog) {
                    return AlertDialog(
                      title: Text('Select start time:'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Start Time: $selectedTime'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Select time'),
                          onPressed: () {
                            showTimePickerWidget(setStateDialog);
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () async {
                            if (selectedTime.isNotEmpty) {
                              await _saveUnavailablePeriod();
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select a time first.'),
                                ),
                              );
                            }
                          },
                        ),
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
                },
              );
            },
          ),
          // Display the unavailable time periods
          Expanded(
            child: ListView.builder(
              itemCount: _unavailableTimePeriods.length,
              itemBuilder: (context, index) {
                final unavailableTime = _unavailableTimePeriods[index];
                return ListTile(
                  title: Text('Unavailable Time Period:'),
                  subtitle: Text('${unavailableTime.format(context)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
