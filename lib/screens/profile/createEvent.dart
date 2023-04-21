import 'package:advices/App/contexts/callEventsContext.dart';
import 'package:advices/App/contexts/servicesContext.dart';
import 'package:advices/App/models/service.dart';
import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:advices/screens/authentication/sign_in.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:intl/intl.dart';

import '../../App/providers/chat_provider.dart';
import '../chat/screens/mobile_chat_screen.dart';
import '../chat/screens/web_layout_screen.dart';
import '../chat/utils/responsive_layout.dart';
import '../payment/checkout/checkout.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    return (hour == other.hour) ? (minute < other.minute) : (hour < other.hour);
  }

  TimeOfDay add({int hours = 0, int minutes = 0}) {
    int totalMinutes = this.hour * 60 + this.minute + hours * 60 + minutes;
    int newHour = (totalMinutes ~/ 60) % 24;
    int newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }
}

class CreateEvent extends StatefulWidget {
  final String uid;
  final String serviceId;
  final String minPriceEuro;

  const CreateEvent(this.uid, this.serviceId, this.minPriceEuro, {Key? key})
      : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final ChatProvider _chatProvider = ChatProvider();

  late Service service;
  bool mkLanguage = true;
  bool openEventForm =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width >
          850.0;

  var imageUrl =
      "https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898.png"; //you can use a image
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title = TextEditingController(text: "Внеси наслов");
  final TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  late bool processing;
  String selectedTime = "16:00";
  String _selectedDate =
      DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

  String serviceName = "Click here to select service";
  List<TimeOfDay> _unavailableTimePeriods = [];
  List<TimeOfDay> _availableTimeSlots = [];
  List<Map<String, dynamic>> _workingHours = [];
  List<int?> _workingDays = [];

  @override
  void initState() {
    super.initState();
    _getService();
    processing = false;
    _fetchWorkingHours();
  }

  Future<List<Map<String, dynamic>>> _fetchWorkingHours() async {
    try {
      _workingHours = await CallEventsContext.getWorkingHours(widget.uid);
      populateWorkingDays();
      if (_workingHours.isNotEmpty) {
        _getInitialDate();
      }
      return _workingHours;
    } catch (e) {
      print(e);
      return [];
    }
  }

  int dayToWeekday(String day) {
    switch (day.toLowerCase()) {
      case "monday":
        return DateTime.monday;
      case "tuesday":
        return DateTime.tuesday;
      case "wednesday":
        return DateTime.wednesday;
      case "thursday":
        return DateTime.thursday;
      case "friday":
        return DateTime.friday;
      case "saturday":
        return DateTime.saturday;
      case "sunday":
        return DateTime.sunday;
      default:
        throw ArgumentError('Invalid day: $day');
    }
  }

  DateTime _getInitialDate() {
    print("Getting initial date...");
    if (_workingHours.isNotEmpty) {
      DateTime today = DateTime.now();
      List<int> weekdays =
          _workingHours.map((e) => dayToWeekday(e["day"])).toList();
      List<DateTime> availableDates = weekdays.map((weekday) {
        int daysToAdd = (DateTime.daysPerWeek + weekday - today.weekday) %
            DateTime.daysPerWeek;
        return today.add(Duration(days: daysToAdd));
      }).toList();
      availableDates.sort((a, b) => a.compareTo(b));
      DateTime nextAvailableDay = availableDates.first;
      return nextAvailableDay;
    }
    print("No available dates.");
    return DateTime.now();
  }

  void populateWorkingDays() {
    _workingDays = _workingHours.map((workingHour) {
      return dayToWeekday(workingHour["day"]);
    }).toList();
  }

  Future<void> _getFreeTimePeriodsForDate() async {
    DateTime selectedDate = DateFormat("yyyy-MM-dd").parse("$_selectedDate");
    List<DateTime> events =
        await CallEventsContext.getAllEventsDateTIme(widget.uid, selectedDate);
    List<Map<String, dynamic>> workingHours =
        await CallEventsContext.getWorkingHours(widget.uid);
    List<Map<String, dynamic>> workingHoursForSelectedDate =
        workingHours.where((workingHour) {
      return DateFormat('EEEE').format(selectedDate) == workingHour['day'];
    }).toList();
    _unavailableTimePeriods = [];
    List<TimeOfDay> availableTimeSlots = [];
    workingHoursForSelectedDate.forEach((workingHour) {
      TimeOfDay startTime = TimeOfDay.fromDateTime(
          DateFormat("HH:mm").parse(workingHour['startTime']));
      TimeOfDay endTime = TimeOfDay.fromDateTime(
          DateFormat("HH:mm").parse(workingHour['endTime']));
      TimeOfDay currentTime = startTime;

      while (currentTime.isBefore(endTime)) {
        availableTimeSlots.add(currentTime);
        currentTime = currentTime.add(minutes: 10);
      }
    });
    events.forEach((element) {
      DateTime subtraction = element;
      for (int i = 0; i <= 5; i++) {
        element = element.add(new Duration(minutes: 10));
        _unavailableTimePeriods.add(TimeOfDay.fromDateTime(element));
      }
      for (int i = 0; i <= 5; i++) {
        subtraction = subtraction.subtract(new Duration(minutes: 10));
        _unavailableTimePeriods.add(TimeOfDay.fromDateTime(subtraction));
      }
    });
    _availableTimeSlots = availableTimeSlots.where((timeSlot) {
      return !_unavailableTimePeriods.contains(timeSlot);
    }).toList();
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
        initialTime: _availableTimeSlots.first,
        selectableTimePredicate: (time) =>
            time!.minute % 10 == 0 && _availableTimeSlots.contains(time)).then(
        (time) => {
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
    await CallEventsContext.saveEvent(
        widget.uid, _title.text, _description.text, selectedDateTime);

    // Uncoment this for enabeling Stripe payment
    // redirectToCheckout(context);

    await _startChatConversation(widget.uid);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Calls()),
    // );
  }

  Future<void> _startChatConversation(String lawyerId) async {
    print("_startChatConversation");
    String chatId = await _chatProvider.createNewChat([lawyerId]);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileChatScreen(chatId),
                webScreenLayout: WebLayoutScreen(chatId),
              )),
    );
  }

  Future<void> _getService() async {
    service = await ServicesContext.getService(widget.serviceId);
    setState(() {
      serviceName = "${mkLanguage ? service.nameMk : service.name}";
      service = service;
      _title = TextEditingController(text: serviceName);
    });
  }

  bool _isFormEmpty() {
    return (_title.text.isEmpty ||
        _description.text.isEmpty ||
        selectedTime == "кликни тука");
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 850.0
        // || MediaQuery.of(context).size.height < 2500.0 )
        ? _mobView()
        : _webView();
  }

  Widget _mobView() {
    return openEventForm
        ? Flexible(child: _dialogFields(setState))
        : Container(
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
                                builder: (context) => StatefulBuilder(
                                      builder: (context,
                                              StateSetter setStateDialog) =>
                                          AlertDialog(
                                        elevation: 20,
                                        contentPadding: EdgeInsets.all(10),
                                        content: SizedBox(
                                          height: 400,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: _dialogFields(
                                                      setStateDialog)),
                                            ],
                                          ),
                                        ),
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
                                "400ден/час",
                                style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Text(serviceName),
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
                                    color: selectedTime == 'time'
                                        ? Color(0xff5bc9bf)
                                        : Colors.black),
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
                      width: 180,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff5bc9bf))),
                        onPressed: () {
                          print(openEventForm);
                          _isFormEmpty()
                              ? setState(() {
                                  openEventForm = true;
                                })
                              : _saveEvent();
                        },
                        child: Row(
                          children: [
                            Text(
                              _isFormEmpty() ? "Уреди" : "Поднеси",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.chevron_right_sharp)
                          ],
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
            color: whiteColor,
            margin:
                const EdgeInsets.only(top: 35, left: 30, right: 50, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: openEventForm
                ? _dialogFields(setState)
                : _finalResultsTable()));
  }

  Widget _dialogFields(StateSetter setStateDialog, {asPopup = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // color: Color.fromRGBO(253, 240, 240, 1),
          width: 500,
          height: 500,
          child: Scaffold(
            key: _key,
            body: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  color: whiteColor,
                  alignment: Alignment.center,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          // initialValue: _title.text,
                          controller: _title,
                          validator: (value) => (value!.isEmpty)
                              ? (mkLanguage
                                  ? "Ве молиме внесере наслов"
                                  : "Please Enter title")
                              : null,
                          style: style,
                          decoration: InputDecoration(
                              labelText: mkLanguage ? "Наслов" : "Title",
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
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: SizedBox(
                            width: 20,
                          )),
                          FutureBuilder(
                            future: _fetchWorkingHours(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Flexible(
                                  flex: 2,
                                  child: _workingHours.isNotEmpty
                                      ? DateTimePicker(
                                          type: DateTimePickerType.date,
                                          dateMask: 'd MMM, yyyy  ',
                                          autocorrect: true,
                                          dateHintText: "12 12 12",
                                          initialValue:
                                              _getInitialDate().toString(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                          icon: Icon(Icons.event),
                                          dateLabelText:
                                              mkLanguage ? "Дата" : 'Date',
                                          timeLabelText: "Time",
                                          selectableDayPredicate: (date) {
                                            // Check if the date's weekday is in the _workingDays list
                                            if (_workingDays
                                                .contains(date.weekday)) {
                                              return true;
                                            }
                                            // Disable the date if its weekday is not in the _workingDays list
                                            return false;
                                            // Disable weekend days to select from the calendar
                                            // if (date.weekday == 6 || date.weekday == 7) {
                                            //   return false;
                                            // }
                                            // String selectedWeekday =
                                            //     DateFormat('EEEE').format(date);
                                            // bool hasWorkingHours = _workingHours.any(
                                            //     (workingHour) =>
                                            //         workingHour['day'] == selectedWeekday);

                                            // // Enable the date if there are working hours, otherwise disable it
                                            // return hasWorkingHours;
                                          },
                                          onChanged: (val) async => {
                                            print("onChanged $val"),
                                            setState(() {
                                              _selectedDate = val;
                                            }),
                                            await _getFreeTimePeriodsForDate(),
                                            await showTimePickerWidget(
                                                setStateDialog),
                                          },
                                          validator: (val) {
                                            print("validator $val");
                                            return null;
                                          },
                                          onSaved: (val) async => {
                                            print("onSaved $val"),
                                            // await showTimePickerWidget()
                                          },
                                        )
                                      : Text("Нема слободни термини"),
                                );
                              } else {
                                return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                              }
                            },
                          ),
                          Flexible(
                              child: SizedBox(
                            width: 20,
                          )),
                          Flexible(
                            flex: 1,
                            child: Container(
                              child: InkWell(
                                onTap: () => {
                                  showTimePickerWidget(setStateDialog),
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.grabbing,
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
                                          color:
                                              Color.fromRGBO(225, 103, 104, 1),
                                        ),
                                        fillColor: Colors.orange,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  225, 103, 104, 1)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                        labelText:
                                            mkLanguage ? "Време" : "time",
                                        labelStyle: TextStyle(
                                          color: Color.fromARGB(209, 0, 0, 0),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      // payingOptions(),
                      SizedBox(height: 50.0),
                      // processing ? Center(child: CircularProgressIndicator()):
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).primaryColor,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff5bc9bf))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  openEventForm = false;
                                });
                              }
                              if (asPopup) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              mkLanguage ? "Зачувај" : "Save",
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
      ),
    );
  }

  Widget _finalResultsTable() {
    return Column(
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
                                        content: _dialogFields(setStateDialog,
                                            asPopup: true)),
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
                                        content: _dialogFields(setStateDialog,
                                            asPopup: true)),
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
                    "Цената ќе биде пресметана според комплексноста на случајот",
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
                                    content: _dialogFields(setStateDialog,
                                        asPopup: true)),
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
                                  content: _dialogFields(setStateDialog,
                                      asPopup: true)),
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
                                    content: _dialogFields(setStateDialog,
                                        asPopup: true)),
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
                      builder: (context) => StatefulBuilder(
                            builder: (context, StateSetter setStateDialog) =>
                                AlertDialog(
                              elevation: 20,
                              contentPadding: EdgeInsets.all(10),
                              content: SizedBox(
                                height: 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        child: _dialogFields(setStateDialog,
                                            asPopup: true)),
                                  ],
                                ),
                              ),
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
