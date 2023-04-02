import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../shared_widgets/base_app_bar.dart';

class IframeWidget extends StatefulWidget {
  final String src;

  IframeWidget({required this.src});

  @override
  _IframeWidgetState createState() => _IframeWidgetState();
}

class _IframeWidgetState extends State<IframeWidget> {
  late HtmlWidget _widget;

  @override
  void initState() {
    super.initState();

    // Create the HTML widget using the src argument
    _widget = HtmlWidget(
      '<iframe src="${widget.src}"></iframe>',
      // webView: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: _widget,
        ),
      ),
    );
  }
}
