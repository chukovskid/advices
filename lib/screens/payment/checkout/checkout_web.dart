@JS()
library stripe;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:js/js.dart';

import '../../../assets/utilities/constants.dart';

void redirectToCheckout(BuildContext _) async {
  final stripe = Stripe(dotenv.env['STRIPE_PK'].toString());
  stripe.redirectToCheckout(CheckoutOptions(
    lineItems: [
      LineItem(price: nikesPriceId, quantity: 1),
    ],
    mode: 'payment',
    successUrl: 'https://advices.page.link/calls',
    cancelUrl: 'https://advices.page.link/',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
