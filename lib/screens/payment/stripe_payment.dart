
// import 'package:advices/payment/webhook_payment.dart';
import 'package:flutter/material.dart';

import 'checkout/checkout.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class StripePayment extends StatelessWidget {
  const StripePayment({Key? key}) : super(key: key);
  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      print(amount);
                    // HttpsCallable callable = FirebaseFunctions.instance
                    //     .httpsCallable('stripePaymentIntentRequest');
                    // dynamic response = await callable.call(<String, dynamic>{
                    //   'email': email,
                    //   'amount': "2200",
                    // });
                    // final jsonResponse = response.data;
                    // print(jsonResponse["customer"]);
      redirectToCheckout(context);
    //   Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => CheckoutPage(sessionId: jsonResponse["paymentIntent"],)),
    // );

      // 2.1 initialise for Web
      // if (kIsWeb) {
      //   // redirectToCheckout(context);
      //   // WebhookPaymentScreen();
      // } else {
      //   // 2. Initialize the payment sheet
      //   // await Stripe.instance.initPaymentSheet(
      //   //     paymentSheetParameters: SetupPaymentSheetParameters(
      //   //   paymentIntentClientSecret: jsonResponse['paymentIntent'],
      //   //   merchantDisplayName: 'Grocery Flutter course',
      //   //   customerId: jsonResponse['customer'],
      //   //   customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      //   //   // testEnv: true,
      //   //   // merchantCountryCode: 'SG',
      //   // ));
      //   // await Stripe.instance.presentPaymentSheet();
      //   // ScaffoldMessenger.of(context).showSnackBar(
      //   //   const SnackBar(
      //   //     content: Text('Payment is successful'),
      //   //   ),
      //   // );
      // }
    } catch (errorr) {
      print(errorr);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );


      // if (errorr is StripeException) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('An error occured ${errorr.error.localizedMessage}'),
      //     ),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('An error occured $errorr'),
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('Pay 20\$'),
        onPressed: () async {
          await initPayment(
              amount: 50.0, context: context, email: 'email@test.com');
        },
      )),
    );
  }
}
