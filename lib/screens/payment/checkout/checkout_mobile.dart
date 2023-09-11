import 'dart:io';
import 'package:advices/screens/payment/checkout/server_stub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';



void redirectToCheckout(BuildContext context) async {
  final sessionId = await Server().createCheckout();
  if (Platform.isIOS || Platform.isAndroid) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CheckoutPage(sessionId: sessionId),
    ));
  } else {
    print("unsupported platform");
  }
}
class CheckoutPage extends StatefulWidget {
  final String sessionId;

  const CheckoutPage({Key? key, required this.sessionId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
   late WebViewController _webViewController ;


 @override
   void initState() {
     super.initState();
    //  Enable virtual display.
     if (Platform.isAndroid) WebView.platform = AndroidWebView();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {
          if (url == initialUrl) {
            _redirectToStripe(widget.sessionId);
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('http://localhost:8080/#/success')) {
            Navigator.of(context).pushReplacementNamed('/success');
          } else if (request.url.startsWith('http://localhost:8080/#/cancel')) {
            Navigator.of(context).pushReplacementNamed('/cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String get initialUrl => 'https://marcinusx.github.io/test1/index.html';

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'${dotenv.env['STRIPE_PK']}\');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    try {
      // ignore: deprecated_member_use
      await _webViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}

