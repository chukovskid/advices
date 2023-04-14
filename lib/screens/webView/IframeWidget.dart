import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../shared_widgets/base_app_bar.dart';

class IframeWidget extends StatefulWidget {
  final String src;

  IframeWidget({required this.src});

  @override
  _IframeWidgetState createState() => _IframeWidgetState();
}

class _IframeWidgetState extends State<IframeWidget> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: "https://www.chatpdf.com/",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageFinished: (String url) {
            _removeHtmlElements();
          },
        ),
      ),
    );
  }

  void _removeHtmlElements() async {
  final controller = await _controller.future;
  // Replace 'elementSelector' with the appropriate CSS selector
  // for the HTML elements you want to remove.
  String elementSelector = '.header-buttons'; // Example: removes elements with class 'example-class'
  controller.runJavascript('''
    (() => {
      const elements = document.querySelectorAll('$elementSelector');
      for (const element of elements) {
        element.parentNode.removeChild(element);
      }
    })();  
  ''');
}

}
