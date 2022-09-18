import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/calendar/add_event.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/services/database.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../utilities/constants.dart';
import 'package:intl/intl.dart';

import '../call/calls.dart';

class CreateEvent extends StatefulWidget {
  final String uid;

  const CreateEvent(this.uid, {Key? key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  FlutterUser? lawyer;
  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late bool processing;
  late String _selectedDate = "select a date";
  String selectedTime = "time";
  List<TimeOfDay> _unavailableTimePeriods = [];

  @override
  void initState() {
    super.initState();

    _getLawyer();
    processing = false;
  }

  Future<void> _getFreeTimePeriodsForDate() async {
    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse("$_selectedDate");
    List<DateTime> events =
        await DatabaseService.getAllLEventsDateTIme(widget.uid, selectedDate);
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

  Future<void> showTimePicherWidget() async {
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
          setState(() => {
                selectedTime = time!.format(context),
              }),
          this.setState(() => {
                selectedTime = time!.format(context),
              }),
          selectedTime = time!.format(context),
          print("selectedTime $selectedTime"),
        });
  }

  Future<void> _saveEvent() async {
    final AuthService _auth = AuthService();
    User? user = await _auth.getCurrentUser();
    bool userExist = user != null ? true : false;
    if (!userExist) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: SignIn()),
                  ],
                ),
              ));
    }
    DateTime selectedDateTime =
        DateFormat("yyyy-MM-dd hh:mm a").parse("$_selectedDate $selectedTime");

    print('//////////SAVING EVENT//////////');

    print(_title.text);
    print(_description.text);
    print(selectedDateTime);

    print('//////////');

    await DatabaseService.saveEvent(
        widget.uid, _title.text, _description.text, selectedDateTime);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calls()),
    );
  }

  Future<void> _getLawyer() async {
    lawyer = await DatabaseService.getLawyer(widget.uid);
    if (lawyer != null) {
      setState(() {
        lawyer = lawyer;
        imageUrl = (lawyer!.photoURL.isEmpty ? imageUrl : lawyer!.photoURL);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 850.0 ? _mobView() : _webView();
  }

  Widget _mobView() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xffc2cee4),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
              flex: 3,
              child: InkWell(
                onTap: (() => {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(child: _dialogFields()),
                                  ],
                                ),
                              ))
                    }),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "€30 ",
                          style: TextStyle(
                              // color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " VISA Applicaton",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "$_selectedDate $selectedTime",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Flexible(
              flex: 1,
              child: SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: (_title.text.isEmpty)
                          ? MaterialStateProperty.all(
                              Color.fromARGB(255, 176, 190, 189))
                          : MaterialStateProperty.all(Color(0xff5bc9bf))),
                  onPressed: () {
                    (_title.text.isEmpty) ? _showToast(context) : _saveEvent();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _webView() {
    return SingleChildScrollView(
        child: Card(
      shadowColor: Color(0xff5bc9bf),
      elevation: 10.0,
      color: Color.fromRGBO(1, 38, 65, 1),
      margin: const EdgeInsets.only(top: 35, left: 30, right: 50, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              // 0: IntrinsicColumnWidth(),
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              // 2: FixedColumnWidth(154),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Service",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  // TableCell(
                  //   verticalAlignment: TableCellVerticalAlignment.top,
                  //   child: Container(
                  //     height: 32,
                  //     width: 32,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: AddEventPage(widget.uid)),
                                    ],
                                  ),
                                ));
                      },
                      child: Text(
                        "VISA",
                        style: TextStyle(
                            color: Color.fromRGBO(1, 38, 65, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Select a date",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                                  builder: (context, setState) =>
                                      AlertDialog(content: _dialogFields()),
                                ));
                      },
                      child: Text(
                        "$_selectedDate $selectedTime",
                        style: TextStyle(
                            color: Color.fromRGBO(1, 38, 65, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "+2 days urgency",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(1, 38, 65, 1),
                ),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Total",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "30 €",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: (_title.text.isEmpty)
                      ? MaterialStateProperty.all(
                          Color.fromARGB(255, 176, 190, 189))
                      : MaterialStateProperty.all(Color(0xff5bc9bf))),
              onPressed: () {
                (_title.text.isEmpty) ? _showToast(context) : _saveEvent();
              },
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }

  Widget _dialogFields() {
    return Center(
      child: Container(
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
                        validator: (value) => (value!.isEmpty)
                            ? "Please Enter description"
                            : null,
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
                              await showTimePicherWidget(),
                            },
                            validator: (val) {
                              print("validator $val");
                              return null;
                            },
                            onSaved: (val) async => {
                              print("onSaved $val"),
                              await showTimePicherWidget()
                            },
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
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                                labelText: "$selectedTime ",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(209, 0, 0, 0),
                                )),
                          ),
                        ),
                        Flexible(child: Text("$selectedTime"))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    processing
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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

                                    // _saveEvent();
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
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Please select title and date'),
        action: SnackBarAction(
            label: 'Fill form',
            onPressed: () => {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(child: _dialogFields()),
                              ],
                            ),
                          ))
                }),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
