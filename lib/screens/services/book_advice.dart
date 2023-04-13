import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import '../../App/contexts/callEventsContext.dart';
import '../../App/models/service.dart';
import '../../App/providers/auth_provider.dart';
import '../../assets/utilities/constants.dart';
import '../authentication/sign_in.dart';
import '../call/calls.dart';
import 'package:intl/intl.dart';

import '../shared_widgets/base_app_bar.dart';

const List<String> list = <String>[
  'Уставно и управно право',
  'Прекршочно право',
  'Подароци',
  'Распределба на имот',
  "Општо право",
  "Закон за облигациони односи",
  "Меѓународно право",
  "Купо-продажба",
  "Кривично право",
  "Имотно право",
  "Закон за деца и млади",
  "Семејно право",
  "Еднаквост и доверба",
  "Закон за приватизација",
  "Друго",
];

class BookAdvice extends StatefulWidget {
  const BookAdvice({Key? key}) : super(key: key);

  @override
  State<BookAdvice> createState() => _BookAdviceState();
}

class _BookAdviceState extends State<BookAdvice> {
  String dropdownValue = list.first;
  late Service service;
  bool mkLanguage = true;
  bool openEventForm = true;

  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title = TextEditingController(text: list.first);
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late bool processing;

  // final now = DateTime.now();
  // final formatter = DateFormat('HH:mm');
  // final dateTimeNowStringHHMM = formatter.format(now);

  String selectedTime = DateFormat("HH:MM").format(DateTime.now()).toString();
  String _selectedDate =
      DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
  String serviceName = list.first;
  List<TimeOfDay> _unavailableTimePeriods = [];

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  Future<void> _getFreeTimePeriodsForDate() async {
    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse("$_selectedDate");
    List<DateTime> events = await CallEventsContext.getAllLEventsDateTIme(
        "Lk37HV68oaPxOA8AHpNqcSoFgEA3", selectedDate);
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

  Future<void> _saveEvent() async {
    final AuthProvider _auth = AuthProvider();
    User? user = await _auth.getCurrentUser();
    bool userExist = user != null ? true : false;
    if (!userExist) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                elevation: 20,
                contentPadding: EdgeInsets.all(2.0),
                content: SizedBox(
                  width: 700,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: SignIn()),
                    ],
                  ),
                ),
              ));
      return;
    }
    DateTime selectedDateTime =
        DateFormat("yyyy-MM-dd hh:mm").parse("$_selectedDate $selectedTime");
    await CallEventsContext.saveEvent("Lk37HV68oaPxOA8AHpNqcSoFgEA3",
        _title.text, _description.text, selectedDateTime);

    // Uncoment this for enabeling Stripe payment
    // redirectToCheckout(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calls()),
    );
  }

  bool _isFormEmpty() {
    return (_title.text.isEmpty ||
        _description.text.isEmpty ||
        selectedTime == "кликни тука");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff1c4746),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .size
                    .width <
                850.0
            ? Container(
                child: openEventForm
                    ? _dialogFields(setState)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _webView(),
                        ],
                      ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: _webView()),
                ],
              ),
      ),
    );

    // _webView();
  }

  Widget _webView() {
    return SingleChildScrollView(
        child: Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Card(
            shadowColor: Color(0xff5bc9bf),
            elevation: 10.0,
            color: whiteColor,
            margin:
                const EdgeInsets.only(top: 35, left: 30, right: 50, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child:
                openEventForm ? _dialogFields(setState) : _finalResultsTable()),
      ),
    ));
  }

  Widget _dialogFields(StateSetter setStateDialog) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // color: Color.fromRGBO(253, 240, 240, 1),
          width: 500,
          height: 500,
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                color: whiteColor,
                alignment: Alignment.center,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Каква правна помош ви е потребна?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: DropdownButton<String>(
                          // create a border on the dropdown button
                          isExpanded: true,
                          hint: Text("Избери услуга"),
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              serviceName = value!;
                              dropdownValue = value;
                              _title = TextEditingController(text: value);
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: TextFormField(
                        controller: _description,
                        minLines: 6,
                        maxLines: 8,
                        validator: (value) => (value!.isEmpty)
                            ? (mkLanguage
                                ? "Ве молиме внесете опис"
                                : "Please Enter description")
                            : null,
                        style: style,
                        decoration: InputDecoration(
                            labelText: mkLanguage
                                ? "Опис на проблемот..."
                                : "Description...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            child: SizedBox(
                          width: 20,
                        )),
                        Flexible(
                          flex: 3,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: DateTimePicker(
                              type: DateTimePickerType.date,
                              dateMask: 'd MMM, yyyy  ',
                              autocorrect: true,
                              dateHintText: "12 12 12",
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event),
                              dateLabelText: mkLanguage ? "Дата" : 'Date',
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
                                await showTimePickerWidget(setStateDialog),
                              },
                              validator: (val) {
                                print("validator $val");
                                return null;
                              },
                              onSaved: (val) async => {
                                print("onSaved $val"),
                                // await showTimePickerWidget()
                              },
                            ),
                          ),
                        ),
                        Flexible(
                            child: SizedBox(
                          width: 20,
                        )),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: InkWell(
                              mouseCursor: SystemMouseCursors.grab,
                              onTap: () => {
                                showTimePickerWidget(setStateDialog),
                              },
                              child: TextFormField(
                                key: Key(selectedTime), // <- Magic!
                                initialValue: selectedTime,
                                enabled: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == "кликни тука") {
                                    return 'Внесете време';
                                  }
                                  return null;
                                },

                                decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      color: Color.fromRGBO(225, 103, 104, 1),
                                    ),
                                    fillColor: Colors.orange,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(225, 103, 104, 1)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    labelText: mkLanguage ? "Време" : "time",
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(209, 0, 0, 0),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff5bc9bf))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                openEventForm = false;
                              });
                            }
                          },
                          child: Text(
                            mkLanguage ? "Продолжи" : "Save",
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

  Widget _finalResultsTable() {
    return Column(
      children: [
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              decoration: BoxDecoration(
                color: Color.fromRGBO(1, 38, 65, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              children: <Widget>[
                Container(
                  height: 100,
                  child: Center(
                    child: Text(
                      mkLanguage ? "Сервис" : "Service",
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
                        backgroundColor: selectedTime == 'time'
                            ? MaterialStateProperty.all(Color(0xff5bc9bf))
                            : MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                                builder: (context,
                                        StateSetter setStateDialog) =>
                                    AlertDialog(
                                        content: _dialogFields(setStateDialog)),
                              ));
                    },
                    child: Text(
                      serviceName,
                      style: TextStyle(
                          color: selectedTime == 'time'
                              ? Colors.white
                              : Color.fromRGBO(1, 38, 65, 1),
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
                      mkLanguage ? "Дата и време" : "Select a date",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: selectedTime == 'time'
                            ? MaterialStateProperty.all(Color(0xff5bc9bf))
                            : MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                                builder: (context,
                                        StateSetter setStateDialog) =>
                                    AlertDialog(
                                        content: _dialogFields(setStateDialog)),
                              ));
                    },
                    child: Text(
                      "$_selectedDate $selectedTime",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: selectedTime == 'time'
                              ? Colors.white
                              : Color.fromRGBO(1, 38, 65, 1),
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
                      mkLanguage ? "Цена" : "Total",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    // "${0} денари",
                    "Цената ќе биде пресметана според избраниот сервис",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: _isFormEmpty()
                    ? MaterialStateProperty.all(
                        Color.fromARGB(255, 176, 190, 189))
                    : MaterialStateProperty.all(Color(0xff5bc9bf))),
            onPressed: () {
              _isFormEmpty()
                  ? showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, StateSetter setStateDialog) =>
                                AlertDialog(
                                    content: _dialogFields(setStateDialog)),
                          ))
                  : _saveEvent();
            },
            child: Text(
              mkLanguage ? "Поднесете" : "Submit",
              style:
                  TextStyle(color: darkGreenColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget payingOptions() {
    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: _isFormEmpty()
                  ? MaterialStateProperty.all(
                      Color.fromARGB(255, 176, 190, 189))
                  : MaterialStateProperty.all(Color(0xff5bc9bf))),
          onPressed: () {
            _isFormEmpty()
                ? showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                          builder: (context, StateSetter setStateDialog) =>
                              AlertDialog(
                                  content: _dialogFields(setStateDialog)),
                        ))
                : _saveEvent();
          },
          child: Text(
            "10-15min \n Short consultation with this lawyer \n (400den)",
            style: textStylePayingOptions,
          ),
        ),
        SizedBox(
          width: 60,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: _isFormEmpty()
                    ? MaterialStateProperty.all(
                        Color.fromARGB(255, 176, 190, 189))
                    : MaterialStateProperty.all(Color(0xff5bc9bf))),
            onPressed: () {
              _isFormEmpty()
                  ? showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, StateSetter setStateDialog) =>
                                AlertDialog(
                                    content: _dialogFields(setStateDialog)),
                          ))
                  : _saveEvent();
            },
            child: Row(
              children: [
                Text(
                  "Get full service from this case with unlimited hours and minutes of consultation \n (3500en)",
                  style: textStylePayingOptions,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
