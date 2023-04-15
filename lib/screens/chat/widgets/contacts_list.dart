import 'package:advices/App/providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/models/chat.dart';
import '../../../App/models/user.dart';
import '../../../App/providers/auth_provider.dart';
import '../../../assets/utilities/constants.dart';
import '../colors.dart';
import '../screens/mobile_chat_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactsList extends StatefulWidget {
  final User user;
  final Function(String) callback;
  const ContactsList(this.user, this.callback, {Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final AuthProvider _auth = AuthProvider();

  String? loggedUserDisplayName = "";

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

  Future<void> getLoggedUser() async {
    // bool loggedIn = await _auth.isSignIn();
    FlutterUser? user = await _auth.getMyProfileInfo();
    bool userExist = user != null ? true : false;
    print("USER ////2 ${user?.displayName} ");

    setState(() => {loggedUserDisplayName = user?.displayName});
  }

  @override
  void initState() {
    super.initState();
    getLoggedUser();
    print("USER ${loggedUserDisplayName} ");
  }

  String trimString(String str) {
    return str.length > 80 ? '${str.substring(0, 42)}...' : str;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<Iterable<Chat>>(
          stream: ChatProvider.getChats(widget.user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chats = snapshot.data!;

              return ListView(
                  shrinkWrap: true, children: chats.map(_listItem).toList());
            }
            return Center(
                child: CircularProgressIndicator(
              color: darkGreenColor,
            ));
          }),
    );
  }

  Widget _listItem(Chat chat) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _selectChat(chat.id);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                chat.displayNames!
                    .firstWhere((e) => e != loggedUserDisplayName)
                    .toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  trimString(chat.lastMessage.toString()),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: lightGreenColor,
                radius: 20,
                child: chat.photoURLs?.first != null &&
                        chat.photoURLs!.first.isNotEmpty
                    ? Image.network(chat.photoURLs!.first)
                    : Text(
                        chat.displayNames!.first[0],
                        style: TextStyle(color: whiteColor),
                      ),
              ),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     chat.photoURLs!.first.toString(),
              //   ),
              //   radius: 30,
              // ),
              trailing: Text(
                timeago
                    .format(chat.lastMessageTime, locale: 'en_short')
                    .toString(),
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
