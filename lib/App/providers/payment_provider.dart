import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentProvider {
  Future<String> getCheckoutSessionUrl(String path) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createPaymentLink');
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'path': path,
      },
    );
    return result.data;
  }

  Future<void> openStripeCheckout(String url, BuildContext context) async {
    if (kIsWeb) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (_) {
      //   return StripeCheckoutWebView(url: url);
      // }));
    }
  }
}
