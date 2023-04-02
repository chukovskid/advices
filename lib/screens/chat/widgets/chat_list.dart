import 'dart:async';

import 'package:advices/App/models/message.dart';
import 'package:advices/App/providers/chat_provider.dart';
import 'package:advices/screens/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../assets/utilities/constants.dart';
import 'my_message_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatList extends StatelessWidget {
  final User user;
  final String chatId;

  const ChatList(this.user, this.chatId, {Key? key}) : super(key: key);


//   @override
// Widget build(BuildContext context) {
//   final Stream<Iterable<Message>> messagesStream = ChatProvider.getMessagesStreamForChat(chatId);
  
//   return StreamBuilder<Iterable<Message>>(
//     stream: messagesStream,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final chatMessages = snapshot.data!;
//         return ListView(children: chatMessages.map(_messageCard).toList(), reverse: true,);
//       }
//       return Center(
//         child: CircularProgressIndicator(
//           color: darkGreenColor,
//         ),
//       );
//     },
//   );
// }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder<Iterable<Message>>(
        stream: ChatProvider.getMessagesStreamForChat(chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chatMessages = snapshot.data!;
            return ListView(
              children: chatMessages.map(_messageCard).toList(),
              reverse: true,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
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


// class ChatList extends StatefulWidget {
//   final User user;
//   final String chatId;

//   const ChatList(this.user, this.chatId, {Key? key}) : super(key: key);

//   @override
//   _ChatListState createState() => _ChatListState();
// }

// class _ChatListState extends State<ChatList> {
//   late StreamSubscription<Iterable<Message>> _streamSubscription;
  
//   late List<Message> _chatMessages = [];
  
//   @override
//   void initState() {
//     super.initState();
//     _streamSubscription = ChatProvider.getMessagesStreamForChat(widget.chatId).listen((snapshot) {
//       if (snapshot.isNotEmpty) {
//         final chatMessages = snapshot.toList();
//         setState(() {
//           _chatMessages = chatMessages;
//         });
//       }
//     });
//   }
  
//   @override
//   void dispose() {
//     _streamSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: _chatMessages.map(_messageCard).toList(),
//       reverse: true,
//     );
//   }

//   Widget _messageCard(Message message) {
//     if (message.senderId == widget.user.uid) {
//       return MyMessageCard(
//         message: message.message,
//         date: timeago.format(message.createdAt, locale: 'en_short'),
//       );
//     } else {
//       return SenderMessageCard(
//         message: message.message,
//         date: timeago.format(message.createdAt, locale: 'en_short'),
//       );
//     }
//   }
// }
