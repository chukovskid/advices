import 'package:flutter/material.dart';
import '../colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final int price;
  final bool payed;

  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.price,
      required this.payed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 35,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 70,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white60,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    price > 0
                        ? Row(
                            children: [
                              Text(
                                "$price ден",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              payed
                                  ? Icon(Icons.lock_open,
                                      color: Colors.green[50], size: 16)
                                  : Icon(Icons.lock,
                                      color: Colors.red[100], size: 16),
                            ],
                          )
                        : SizedBox(width: 4),
                    const SizedBox(
                      width: 5,
                    ),
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
          ),
        ),
      ),
    );
  }
}
