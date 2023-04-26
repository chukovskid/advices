import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../chat/screens/mobile_layout_screen.dart';
import '../chat/screens/web_layout_screen.dart';
import '../chat/utils/responsive_layout.dart';
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

  void _navigateToChat(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 600) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
                mobileScreenLayout: MobileLayoutScreen(null),
                webScreenLayout: WebLayoutScreen(null))),
      );
    } else {
      setState(() {
        _isChatVisible = !_isChatVisible;
      });
    }
  }

  bool _isChatVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        openChat: true,
        onChatPressed: () {
          _navigateToChat(context);
        },
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      flex: _isChatVisible ? 2 : 3,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: _widget,
                      ),
                    ),
                    if (_isChatVisible && constraints.maxWidth > 600)
                      Expanded(
                        flex: 1,
                        child: MobileLayoutScreen(
                          null,
                          isDrawer: true,
                        ),
                      ),
                  ],
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}
