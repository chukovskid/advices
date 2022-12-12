import 'package:advices/App/contexts/usersContext.dart';
import 'package:advices/App/models/userChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/contexts/chatContext.dart';
import '../../../App/models/chat.dart';
import '../../../App/models/message.dart';
import '../colors.dart';
import '../screens/mobile_chat_screen.dart';

class ContactsList extends StatefulWidget {
  final User user;
  final Function(String) callback;

  const ContactsList(this.user, this.callback, {Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  _selectChat(chatId) {
    MediaQuery.of(context).size.width < 850.0
        ? _navigateToMobileChat(chatId)
        : widget.callback(chatId);
  }

  _navigateToMobileChat(String chatId) {
    print("_navigateToMobileChat $chatId");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileChatScreen(chatId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<Iterable<Chat>>(
          stream: ChatContext.getChats(widget.user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chats = snapshot.data!;

              return ListView(
                  shrinkWrap: true, children: chats.map(_listItem).toList());
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget _listItem(Chat chat) {
    return
        // Text("HEEEEEKKKKKK");
        Column(
      children: [
        InkWell(
          onTap: () {
            _selectChat(chat.id);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                chat.displayNames!.firstWhere((e) => e != widget.user.displayName).toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  chat.lastMessage.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  "info[index]['profilePic'].toString()",
                ),
                radius: 30,
              ),
              trailing: Text(
                chat.lastMessageTime.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const Divider(color: dividerColor, indent: 85),
      ],
    );
  }
}
