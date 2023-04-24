// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// import '../shared_widgets/base_app_bar.dart';

// class IframeWidget extends StatefulWidget {
//   final String src;

//   IframeWidget({required this.src});

//   @override
//   _IframeWidgetState createState() => _IframeWidgetState();
// }

// class _IframeWidgetState extends State<IframeWidget> {
//   late HtmlWidget _widget;

//   @override
//   void initState() {
//     super.initState();

//     // Create the HTML widget using the src argument
//     _widget = HtmlWidget(
//       '<iframe src="${widget.src}"></iframe>',
//       // webView: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BaseAppBar(
//         appBar: AppBar(),
//       ),
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: _widget,
//         ),
//       ),
//     );
//   }
// }

// import 'package:advices/assets/utilities/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// import '../shared_widgets/base_app_bar.dart';

// class IframeWidget extends StatefulWidget {
//   final String src;

//   IframeWidget({required this.src});

//   @override
//   _IframeWidgetState createState() => _IframeWidgetState();
// }

// class _IframeWidgetState extends State<IframeWidget> {
//   late HtmlWidget _widget;

//   @override
//   void initState() {
//     super.initState();

//     // Create the HTML widget using the src argument
//     _widget = HtmlWidget(
//       '<iframe src="${widget.src}"></iframe>',
//       // webView: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BaseAppBar(
//         appBar: AppBar(),
//       ),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Container(
//               // make width 10% height 10% of the screen.
//               // width: MediaQuery.of(context).size.width * 0.1,
//               // height: MediaQuery.of(context).size.height * 0.1,
//               width: double.infinity,
//               height: double.infinity,
//               child: _widget,
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Padding(
//               padding: EdgeInsets.only(left: 16, bottom: 16),
//               child: FloatingActionButton.extended(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 label: Text('Пораки'),
//                 icon: Icon(Icons.chat),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7),
//                 ),
//                 backgroundColor: darkGreenColor,
//                 foregroundColor: Colors.white,
//                 heroTag: null,
//                 elevation: 4.0,
//                 isExtended: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:advices/screens/call/calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../assets/utilities/constants.dart';
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
              if (constraints.maxWidth > 600)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 16),
                    child: SizedBox(
                      width: 240,
                      height: 34,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _navigateToChat(context);
                        },
                        label: Text('Во девелопмент'),
                        // testing icon
                        icon: Icon(Icons.construction),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        backgroundColor: darkBlueColor,
                        foregroundColor: Colors.white,
                        heroTag: null,
                        elevation: 4.0,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
