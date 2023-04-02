import 'package:flutter/material.dart';
import '../../App/models/event.dart';

class EventWidget extends StatelessWidget {
  final EventModel event;

  EventWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Container(
        padding: EdgeInsetsGeometry.lerp(
          EdgeInsets.all(8.0),
          EdgeInsets.all(8.0),
          1.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              event.description,
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
