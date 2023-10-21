import 'dart:async';

import 'package:flutter/cupertino.dart';

class CallsTimerPopupWidget extends StatefulWidget {
  @override
  _CallsTimerPopupWidgetState createState() => _CallsTimerPopupWidgetState();
}

class _CallsTimerPopupWidgetState extends State<CallsTimerPopupWidget> {
  int _count = 4;

  @override
  void initState() {
    super.initState();
    // Decrease the count every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _count--;
      });
      // Close the AlertDialog when the count reaches 0
      if (_count == 0) {
        Navigator.of(context).pop();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Успешно закажан термин"),
        SizedBox(height: 16),
        Text(
          " $_count ",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
