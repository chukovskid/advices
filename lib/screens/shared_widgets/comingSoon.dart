import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';

class ComingSoonWidget extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final String description;

  ComingSoonWidget(
      {Key? key, required this.onBackButtonPressed, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Доаѓа наскоро!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              description,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
            ),
            onPressed: onBackButtonPressed,
            child: Text('Кликнете тука да се вратите назад'),
          ),
        ],
      ),
    );
  }
}
