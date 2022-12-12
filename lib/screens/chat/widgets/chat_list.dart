import 'package:advices/App/contexts/chatContext.dart';
import 'package:advices/App/models/message.dart';
import 'package:advices/screens/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_message_card.dart';
import 'package:timeago/timeago.dart' as timeago;


class ChatList extends StatefulWidget {
  final User user;
  final String chatId;


  const ChatList(this.user, this.chatId, {Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Message>>(
        stream: ChatContext.getMessagesStreamForChat(widget.chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chatMessages = snapshot.data!;
            return ListView(children: chatMessages.map(_messageCard).toList()
            , reverse: true,);
          }
          return CircularProgressIndicator();
        });
  }

  Widget _messageCard(Message message) {
    if (message.senderId == widget.user.uid) {
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
