import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/contexts/chatContext.dart';
import '../../../App/models/message.dart';
import '../colors.dart';

class ContactsList extends StatefulWidget {
  final User user;

  const ContactsList(this.user, {Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<Iterable<Message>>(
          stream: ChatContext.getMessagesStreamForChat("1"),
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

  Widget _listItem(Message message) {
    return
        // Text("HEEEEEKKKKKK");
        Column(
      children: [
        InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const MobileChatScreen(),
            //   ),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                "info[index]['name'].toString()",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  "info[index]['message'].toString()",
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
                "info[index]['time'].toString()",
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
