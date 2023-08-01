import 'package:flutter/material.dart';
import '../../../App/providers/payment_provider.dart';

class PaymentDialog extends StatelessWidget {
  final int price;
  final String path;
  final VoidCallback onPayment;
  final PaymentProvider _paymentProvider = PaymentProvider();

  PaymentDialog(
      {Key? key,
      required this.price,
      required this.path,
      required this.onPayment})
      : super(key: key);

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Наплата'),
      content: Text('Цената за оваа услуга е: $price денари.'),
      actions: [
        TextButton(
          child: Text('Плати'),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ],
                  ),
                );
              },
            );
            String url = await _paymentProvider.getCheckoutSessionUrl(path);
            await _paymentProvider.openStripeCheckout(url, context);
            Navigator.of(context).pop(); // close the loader dialog
            Navigator.of(context).pop(); // close the dialog
            onPayment();
          },
        ),
        TextButton(
          child: Text('Откажи'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
