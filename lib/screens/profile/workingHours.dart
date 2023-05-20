import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../../App/contexts/callEventsContext.dart';
import '../../assets/utilities/constants.dart';

class WorkingHoursScreen extends StatefulWidget {
  final String lawyerId;

  WorkingHoursScreen({required this.lawyerId});

  @override
  _WorkingHoursScreenState createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  List<Map<String, dynamic>> _workingHours = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkingHours();
  }

  Future<void> _fetchWorkingHours() async {
    _workingHours = await CallEventsContext.getWorkingHours(widget.lawyerId);
    setState(() {});
  }

  Future<void> _removeWorkingHours(String day) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.lawyerId)
        .collection("workingHours")
        .doc(day)
        .delete();

    _fetchWorkingHours();
  }

  Future<void> _updateWorkingHours(
      BuildContext context, Map<String, dynamic> workingHour) async {
    TimeOfDay? startTime = TimeOfDay.fromDateTime(
        DateTime.parse("2000-01-01T${workingHour['startTime']}"));
    TimeOfDay? endTime = TimeOfDay.fromDateTime(
        DateTime.parse("2000-01-01T${workingHour['endTime']}"));

    TimeOfDay? selectedStartTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    TimeOfDay? selectedEndTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (selectedStartTime != null && selectedEndTime != null) {
      String formattedStartTime = selectedStartTime.format(context);
      String formattedEndTime = selectedEndTime.format(context);

      // Update working hours in the Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.lawyerId)
          .collection("workingHours")
          .doc(workingHour['day'])
          .update({
        "startTime": formattedStartTime,
        "endTime": formattedEndTime,
      });

      _fetchWorkingHours();
    }
  }

  Future<void> _addWorkingHours(BuildContext context) async {
    String? selectedDay;
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;

    // Show dialog to choose the day of the week
    selectedDay = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Селектирај ден'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Monday');
              },
              child: const Text('Monday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Tuesday');
              },
              child: const Text('Tuesday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Wednesday');
              },
              child: const Text('Wednesday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Thursday');
              },
              child: const Text('Thursday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Friday');
              },
              child: const Text('Friday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Saturday');
              },
              child: const Text('Saturday'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Sunday');
              },
              child: const Text('Sunday'),
            ),
          ],
        );
      },
    );

    if (selectedDay == null) {
      return;
    }

    // Show time picker for start time
    selectedStartTime = await showCustomTimePicker(
        context: context, initialTime: TimeOfDay(hour: 10, minute: 0));

    if (selectedStartTime == null) {
      return;
    }

    // Show time picker for end time
    selectedEndTime = await showCustomTimePicker(
        context: context, initialTime: TimeOfDay(hour: 18, minute: 0));
        
    if (selectedEndTime == null) {
      return;
    }

    String formattedStartTime = selectedStartTime.format(context);
    String formattedEndTime = selectedEndTime.format(context);

    // Save the new working hours to Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.lawyerId)
        .collection("workingHours")
        .doc(selectedDay)
        .set({
      "day": selectedDay,
      "startTime": formattedStartTime,
      "endTime": formattedEndTime,
    });

    _fetchWorkingHours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Намести недостапни термини'),
        backgroundColor: lightGreenColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addWorkingHours(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _workingHours.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> workingHour = _workingHours[index];
          return ListTile(
            title: Text(workingHour['day']),
            subtitle:
                Text("${workingHour['startTime']} - ${workingHour['endTime']}"),
            onTap: () {
              _updateWorkingHours(context, workingHour);
            },
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _removeWorkingHours(workingHour['day']);
              },
            ),
          );
        },
      ),
    );
  }
}
