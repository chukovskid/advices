// File: payment_dialog.dart

import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget {
  final int price;
  final VoidCallback onPayment;

  const PaymentDialog({Key? key, required this.price, required this.onPayment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Наплата'),
      content: Text('Цената на оваа порака е: $price'),
      actions: [
        TextButton(
          child: Text('Плати'),
          onPressed: () {
            onPayment();
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Откажи'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
