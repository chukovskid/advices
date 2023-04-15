import 'package:flutter/material.dart';

import '../../screens/chat/colors.dart';

class ResizableWidget extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final double handleSize;

  ResizableWidget({
    Key? key,
    required this.child,
    required this.minHeight,
    required this.maxHeight,
    this.handleSize = 16.0,
  }) : super(key: key);

  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {
  double? height;

  @override
  void initState() {
    super.initState();
    height = widget.minHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.resizeUpDown,
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                height = height! - details.delta.dy;
                height = height!.clamp(widget.minHeight, widget.maxHeight);
              });
            },
            child: Container(
              height: widget.handleSize,
              color: mobileChatBoxColor,
              child: Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: height,
          child: widget.child,
        ),
      ],
    );
  }
}
