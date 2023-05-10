import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../App/providers/auth_provider.dart';
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
    _initializeWidgetWithToken();
  }

Future<String?> _getAuthToken() async {
  final AuthProvider _auth = AuthProvider();
  User? user = await  _auth.getCurrentUser();

  if (user == null) {
    return null;
  }

  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getCustomToken');
    HttpsCallableResult result = await callable.call();
    String? token = result.data['token'];
    return token;
  } catch (error) {
    print('Error fetching custom token: $error');
    return null;
  }
}

  void _initializeWidgetWithToken() async {
    String? token = await _getAuthToken();
    String urlWithToken =
        token != null ? '${widget.src}?token=$token' : widget.src;

    setState(() {
      _widget = HtmlWidget(
        '<iframe src="$urlWithToken"></iframe>',
      );
    });
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
