import 'package:flutter/material.dart';
// import '../../models/event.dart';
// import 'event_firestore_service.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class AddEventPage extends StatefulWidget {
  // final EventModel note;

  // const AddEventPage({required Key key, required this.note}) : super(key: key);
  const AddEventPage({Key? key}) : super(key: key);

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
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _title = TextEditingController(
    //     text: widget.note != null ? widget.note.title : "");
    // _description = TextEditingController(
    //     text: widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.note != null ? "Edit Event" : "Add event"),
        title: Text("Edit Event"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              // ListTile(
              //   title: Text("Date (YYYY-MM-DD)"),
              //   subtitle: Text(
              //       "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
              //   onTap: () async {
              //     DateTimePicker(
              //       initialValue: '',
              //       firstDate: DateTime(2000),
              //       lastDate: DateTime(2100),
              //       dateLabelText: 'Date',
              //       onChanged: (val) => print(val),
              //       validator: (val) {
              //         print(val);
              //         return null;
              //       },
              //       onSaved: (val) => print(val),
              //     );
              //     DateTime? picked = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime(_eventDate.year - 5),
              //       lastDate: DateTime(_eventDate.year + 5),
              //       initialDatePickerMode: DatePickerMode.day,
              //     );
              //     if (picked != null) {
              //       DateTime selectdate = picked;
              //       // final selIOS = DateTime('dd-MMM-yyyy - HH:mm').format(selectdate);
              //       print(selectdate);
              //       setState(() {
              //         _eventDate = picked;
              //       });
              //     }
              //   },
              // ),

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
                        if (date.weekday == 6 || date.weekday == 7) {
                          return false;
                        }
                        return true;
                      },
                      onChanged: (val) async => {
                        print("onChanged $val"),
                        await showCustomTimePicker(
                            context: context,
                            // It is a must if you provide selectableTimePredicate
                            onFailValidation: (context) =>
                                print('Unavailable selection'),
                            initialTime: TimeOfDay(hour: 2, minute: 0),
                            selectableTimePredicate: (time) =>
                                time!.hour > 1 &&
                                time.hour < 14 &&
                                time.minute % 5 == 0).then((time) => {
                              setState(() => {
                                    selectedTime = time?.format(context),
                                  }),
                              // if (selectedTime != null)
                              //   {
                              //     {
                              //       // _timeController.text =
                              //       //     selectedTime.toString()
                              //     }
                              //   }
                            })
                      },
                      validator: (val) {
                        print("validator $val");
                        return null;
                      },
                      onSaved: (val) async => {
                        print("onSaved $val"),
                      },
                    ),
                  ),
                  Flexible(
                      child: SizedBox(
                    width: 50,
                  )),
                  Flexible(
                    child: TextFormField(
                      // initialValue:
                      //     "${selectedTime != null ? selectedTime : 'select date'}",
                      // controller: _timeController,
                      enabled: false,
                      decoration:  InputDecoration(
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
                          labelText: "${selectedTime != null ? selectedTime : 'select date'}",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(209, 0, 0, 0),
                          )),
                      // title: Text("Time: "),
                      // subtitle: Text("${selectedTime != null ? selectedTime : '${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}'}"),
                    ),
                  ),
                ],
              ),
              //////////////////////////////////////
              ///
              ///
              ///
              // ListTile(
              //   title: Text("Time: "),
              //   subtitle: Text(
              //       "${selectedTime != null ? selectedTime : '${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}'}"),
              // ),
              // SizedBox(height: 10.0),
/////////////////////////
              ///
              ///
              ///
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
                                // "event_date": widget.note.eventDate
                              };
                              // if (widget.note != null) {
                              //   // await eventDBS.updateData(widget.note.id, data);
                              //   print("UPDATA DATA +++");
                              // } else {
                              //   // await eventDBS.create(data);
                              //   print("CREATE DATA +++");

                              // }
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
