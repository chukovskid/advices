import 'package:advices/App/contexts/callEventsContext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/models/event.dart';
import '../../../assets/utilities/constants.dart';
import '../../call/call.dart';
import '../colors.dart';
import 'package:intl/intl.dart';

class ChatsCallList extends StatefulWidget {
  final User user;
  final Function(String) callback;
  const ChatsCallList(this.user, this.callback, {Key? key}) : super(key: key);

  @override
  State<ChatsCallList> createState() => _ChatsCallListState();
}

class _ChatsCallListState extends State<ChatsCallList> {

  _navigateToMobileChat(String callId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Call(callId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<Iterable<EventModel>>(
          stream: CallEventsContext.getAllLEvents(widget.user.uid),
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

  Widget _listItem(EventModel callId) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _navigateToMobileChat(callId.channelName);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                callId.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  callId.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              // leading: CircleAvatar(
              //   radius: 20,
              //   child: callId.photoURLs?.first != null &&
              //           callId.photoURLs!.first.isNotEmpty
              //       ? Image.network(callId.photoURLs!.first)
              //       : Text(callId.displayNames!.first[0]),
              // ),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(
              //     callId.photoURLs!.first.toString(),
              //   ),
              //   radius: 30,
              // ),
              trailing: Text(
                "Закажано за: ${DateFormat.yMd().add_Hm().format(callId.startDate)}",
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
