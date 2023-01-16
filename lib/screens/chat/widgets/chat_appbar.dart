import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../../App/models/chat.dart';
import '../../../App/providers/chat_provider.dart';
import '../colors.dart';

class ChatAppBar extends StatefulWidget {
  final String chatId;

  ChatAppBar(this.chatId, {Key? key}) : super(key: key);

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {

  bool mobView =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width <
          850.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      color: webAppBarColor,
      child: StreamBuilder<Chat>(
          stream: ChatProvider.getChat(widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chatInfo = Chat.fromSnapshot(snapshot.data);
              return _chatInfo(chatInfo);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Твои пораки!", style: TextStyle(color: whiteColor),),
              );
            }
            return Center(
                child: CircularProgressIndicator(
              color: darkGreenColor,
            ));
          }),
    );
  }

  Widget _chatInfo(Chat chat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            mobView ? _iconButton() : SizedBox(),
            SizedBox(
              width: 4,
            ),
            CircleAvatar(
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
            // ...chat.photoURLs!
            //     .map((photoURL) => CircleAvatar(
            //           radius: 20,
            //           child: Image.network(photoURL),
            //         ))
            //     .toList(),

            SizedBox(
              width: 10,
              // width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              chat.displayNames?.first ?? "Селектирајте некој од контактите",
              style: TextStyle(fontSize: 18, color: whiteColor),
            ),
          ],
        ),
        Row(
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.search, color: Colors.grey),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.more_vert, color: Colors.grey),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _iconButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_outlined,
        size: 26,
        color: whiteColor,
      ),
      onPressed: () {
        // Handle button press here
        Navigator.pop(context);
      },
    );
  }
}
