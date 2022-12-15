import 'package:advices/assets/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../../App/contexts/chatContext.dart';
import '../../../App/models/chat.dart';
import '../colors.dart';

class ChatAppBar extends StatelessWidget {
  final String chatId;

  const ChatAppBar(this.chatId, {Key? key}) : super(key: key);

  // late String chatId;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      color: webAppBarColor,
      child: StreamBuilder<Chat>(
          stream: ChatContext.getChat(chatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _chatInfo(snapshot.data);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            }
            return Center(
                child: CircularProgressIndicator(
              color: darkGreenColor,
            ));
          }),
    );
  }

  Widget _chatInfo(dynamic chat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                chat?.photoURLs?.first ?? // TODO add isEmpty ?
                'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg',
              ),
              radius: 20,
            ),
            SizedBox(
              width: 10,
              // width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              chat?.displayNames?.first ??
              "Селектирајте некој од контактите",
              style: TextStyle(fontSize: 18, color: whiteColor),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
