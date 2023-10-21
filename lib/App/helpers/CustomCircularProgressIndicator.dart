import 'package:flutter/material.dart';

import '../../assets/utilities/constants.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;

  CustomCircularProgressIndicator({this.color = darkGreenColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
