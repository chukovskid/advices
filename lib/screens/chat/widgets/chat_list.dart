import 'dart:async';

import 'package:advices/App/models/message.dart';
import 'package:advices/App/providers/chat_provider.dart';
import 'package:advices/screens/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/helpers/CustomCircularProgressIndicator.dart';
import '../../../assets/utilities/constants.dart';
import 'my_message_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatList extends StatelessWidget {
  final User user;
  final String chatId;

  const ChatList(this.user, this.chatId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Iterable<Message>>(
        stream: ChatProvider.getMessagesStreamForChat(chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chatMessages = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "../../../lib/assets/images/backgroundImage.png",
                  ),
                ),
              ),
              child: ListView(
                children: chatMessages.map(_messageCard).toList(),
                reverse: true,
              ),
            );
          }
          return Center(
            child: CustomCircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _messageCard(Message message) {
    if (message.senderId == user.uid) {
      return MyMessageCard(
        message: message.message,
        date: timeago.format(message.createdAt, locale: 'en_short'),
      );
    } else {
      return SenderMessageCard(
        message: message.message,
        date: timeago.format(message.createdAt, locale: 'en_short'),
      );
    }
  }
}
