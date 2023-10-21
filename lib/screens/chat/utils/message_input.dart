import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin MessageInput<T extends StatefulWidget> on State<T> {
  int? price;

  void showPriceBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          TextEditingController priceController = TextEditingController();

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Внесете цена во денари',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Material(
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Цена',
                        hintText: 'Внесете цена',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      int? enteredPrice =
                          int.tryParse(priceController.text.trim());
                      if (enteredPrice != null) {
                        setModalState(() {
                          price = enteredPrice;
                        });
                        Navigator.pop(context);
                      } else {
                        // Show error message or handle invalid price input
                      }
                    },
                    child: Text('Зачувај'),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget buildPriceButton() {
    return price != null
        ? Row(
            children: [
              Icon(
                Icons.lock,
                color: Colors.white,
                size: 10,
              ),
              Text(
                ' \$${price}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Set the font size as needed
                ),
              ),
            ],
          )
        : Icon(
            Icons.payment,
            color: Colors.white,
          );
  }
}
