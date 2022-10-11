import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';

import '../../utilities/constants.dart';

/// Only for demo purposes!
/// Don't you dare do it in real apps!
class Server {
  Future<String> createCheckout() async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('stripePaymentIntentRequest');
      // dynamic resp = await callable.call();

      dynamic response = await callable.call(<String, dynamic>{
        'email': 'email@test.com',
        'amount': "2000",
      });

      final jsonResponse = response.data;
      print(jsonResponse["customer"]);

      // final auth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));
      // final body = {
      //   'payment_method_types': ['card'],
      //   'line_items': [
      //     {
      //       'price': nikesPriceId,
      //       'quantity': 1,
      //     }
      //   ],
      //   'mode': 'payment',
      //   'success_url': 'http://localhost:8080/#/success',
      //   'cancel_url': 'http://localhost:8080/#/cancel',
      // };
      //   final result = await Dio().post(
      //   "https://api.stripe.com/v1/checkout/sessions",
      //   data: body,
      //   options: Options(
      //     headers: {HttpHeaders.authorizationHeader: auth},
      //     contentType: "application/x-www-form-urlencoded",
      //   ),
      // );
      // return result.data['id'];
      return jsonResponse["ephemeralKey"];
      // return jsonResponse["customer"];
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
