import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridBadge extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final String imageUrl;

  const GridBadge({
    required this.radius,
    required this.borderWidth,
    required this.imageUrl,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(height: 2.1 * radius),
        Positioned(
          top: 0,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.indigo,
            child: CircleAvatar(
              radius: radius - borderWidth,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: radius - 2 * borderWidth,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 2 * borderWidth,
              vertical: borderWidth,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderWidth),
              color: Colors.indigo,
            ),
            child: Text(
              '12 Mart',
              style: TextStyle(color: Colors.white, fontSize: 3 * borderWidth),
            ),
          ),
        ),
      ],
    );
  }
}