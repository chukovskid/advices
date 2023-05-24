import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../App/models/event.dart';

class CustomCardWidget extends StatelessWidget {
  final EventModel call;
  final VoidCallback onTapOpenCall;

  const CustomCardWidget({Key? key, required this.call, required this.onTapOpenCall}) : super(key: key);

  String trimString(String str) {
    return str.length > 45 ? '${str.substring(0, 42)}...' : str;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 25,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(call.title.toString()),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                          ),
                          Text(
                            ' ${trimString(call.description)}',
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16),
                          Text(
                              ' ${DateFormat("yyyy-MM-dd hh:mm").format(call.startDate)}'),
                          SizedBox(
                            width: 24,
                          ),
                          call.open == true
                              ? Text(
                                  'Некој ве чека веќе',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text('Сеуште нема никој')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              onTap: onTapOpenCall,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
