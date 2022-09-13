import 'package:advices/services/database.dart';
import 'package:flutter/material.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final String uid;

  const AddEventPage(this.uid, {Key? key}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  late DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late bool processing;
  String? selectedTime;

  late String _selectedDate;

  List<TimeOfDay> _unavailableTimePeriods = [];

  @override
  void initState() {
    super.initState();
    _eventDate = DateTime.now();
    processing = false;
  }

  Future<void> _getFreeTimePeriodsForDate() async {
    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse("$_selectedDate");
    List<DateTime> events = await DatabaseService.getAllLEventsDateTIme(
        "69kDEqpjX7aeulnh6QsCt1uH8l23", selectedDate); // TODO add lawyerId
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

  showTimePicherWidget() async {
    return await showCustomTimePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        },
        onFailValidation: (context) => print('Unavailable selection'),
        initialTime: TimeOfDay(hour: 13, minute: 0),
        selectableTimePredicate: (time) =>
            time!.minute % 10 == 0 &&
            !_unavailableTimePeriods.contains(time)).then((time) => {
          print(time?.format(context)),
          // print(time?.hour),
          // _selectedEventHour = time!.hour < 10
          //     ? '0' + time!.hour.toString()
          //     : time!.hour.toString(),
          // _selectedEventMinutes = time!.minute < 10
          //     ? '0' + time!.minute.toString()
          //     : time!.minute.toString(),
          // _eventTime = DateTime.parse("2022-9-21" +
          //     ' ' +
          //     _selectedEventHour +
          //     ':' +
          //     _selectedEventMinutes +
          //     ':00.000'),
          // print(_eventTime.hour),
          setState(() => {
                selectedTime = time?.format(context),
              }),
        });
  }

  Future<void> _saveEvent() async {
    print('//////////');
    print(_title.text);
    print(_description.text);
    print(_selectedDate);
    print(selectedTime);
    DateTime selectedDateTime =
        DateFormat("yyyy-MM-dd hh:mm a").parse("$_selectedDate $selectedTime");
    // print(DateFormat.yMMMd().format("$_selectedDate 01:00 PM"));
    print(selectedDateTime);

    DatabaseService.saveEvent(
        widget.uid, _title.text, _description.text, selectedDateTime);

    print('//////////');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Scaffold(
        key: _key,
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 500,
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _title,
                      validator: (value) =>
                          (value!.isEmpty) ? "Please Enter title" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "Title",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _description,
                      minLines: 3,
                      maxLines: 5,
                      validator: (value) =>
                          (value!.isEmpty) ? "Please Enter description" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                 
                  SizedBox(height: 10.0),

                  Row(
                    children: [
                      Flexible(
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy  ',
                          autocorrect: true,
                          dateHintText: "12 12 12",
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Time",
                          selectableDayPredicate: (date) {
                            // Disable weekend days to select from the calendar
                            // if (date.weekday == 6 || date.weekday == 7) {
                            //   return false;
                            // }
                            return true;
                          },
                          onChanged: (val) async => {
                            print("onChanged $val"),
                            setState(() {
                              _selectedDate = val;
                            }),
                            await _getFreeTimePeriodsForDate(),
                            // TODO get val.date and
                            showTimePicherWidget()
                          },
                          validator: (val) {
                            print("validator $val");
                            // showTimePicherWidget();
                            return null;
                          },
                          onSaved: (val) async =>
                              {print("onSaved $val"), showTimePicherWidget()},
                        ),
                      ),
                      Flexible(
                          child: SizedBox(
                        width: 50,
                      )),
                      Flexible(
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Color.fromRGBO(225, 103, 104, 1),
                              ),
                              fillColor: Colors.orange,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(225, 103, 104, 1)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              labelText:
                                  "${selectedTime != null ? selectedTime : 'select date'}",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(209, 0, 0, 0),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  processing
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme.of(context).primaryColor,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    processing = true;
                                  });
                                  final data = {
                                    "title": _title.text,
                                    "description": _description.text,
                                  };

                                  _saveEvent();
                                  Navigator.pop(context);
                                  setState(() {
                                    processing = false;
                                  });
                                }
                              },
                              child: Text(
                                "Save",
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectTime() {
    return ListTile(
      title: Text("Date (YYYY-MM-DD)"),
      subtitle: Text(
          "${selectedTime != null ? selectedTime : '${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}'}"),
      onTap: () async {
        DateTimePicker(
          initialValue: '',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          dateLabelText: 'Date',
          onChanged: (val) => print(val),
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => print(val),
        );

        List<int> _availableHours = [1, 4, 6, 8, 12];
        List<int> _availableMinutes = [0, 10, 30, 45, 50];
        await showCustomTimePicker(
            context: context,
            // It is a must if you provide selectableTimePredicate
            onFailValidation: (context) => print('Unavailable selection'),
            initialTime: TimeOfDay(hour: 2, minute: 0),
            selectableTimePredicate: (time) =>
                time!.hour > 1 && time.hour < 14 && time.minute % 5 == 0).then(
            (time) => setState(() => selectedTime = time?.format(context)));

        print(selectedTime);
      },
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
