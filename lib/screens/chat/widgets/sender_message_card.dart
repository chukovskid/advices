import 'package:advices/screens/chat/widgets/payment_dialog.dart';
import 'package:advices/screens/webView/IframeWidget.dart';
import 'package:flutter/material.dart';
import '../../../App/providers/chat_provider.dart';
import '../colors.dart';

class SenderMessageCard extends StatelessWidget {
  SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.price,
    required this.payed,
    required this.messageId,
    required this.chatId,
  }) : super(key: key);
  final String message;
  final String date;
  final int price;
  final bool payed;
  final String messageId;
  final String chatId;

  final ChatProvider _chatProvider = ChatProvider();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: payed == false
            ? InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => PaymentDialog(
                      path: "$chatId/$messageId",
                      price: price,
                      onPayment: () {
                        print('The message is paid');
                      },
                    ),
                  );
                },
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromARGB(255, 255, 255, 206), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Color.fromARGB(255, 245, 179, 179),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: buildCardContent(isPaid: payed),
                ),
              )
            : Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: (price > 0) ? Colors.lightGreen : Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                color: senderMessageColor,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: buildCardContent(isPaid: payed),
              ),
      ),
    );
  }

  Widget buildCardContent({required bool isPaid}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 70,
            top: 5,
            bottom: 20,
          ),
          child: isPaid
              ? Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white60,
                  ),
                )
              : Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Цена: $price денари',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
        Positioned(
          bottom: 4,
          right: 10,
          child: Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.done_all,
                size: 20,
                color: Colors.white60,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
