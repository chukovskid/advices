import 'package:advices/screens/chat/colors.dart';
import 'package:advices/screens/chat/info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../App/contexts/authContext.dart';
import '../../../App/contexts/chatContext.dart';
import '../../../App/models/message.dart';
import '../../authentication/authentication.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends StatefulWidget {
  final String chatId;

  const MobileChatScreen(this.chatId, {Key? key}) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final FocusNode _messageFocusNode = FocusNode();

  final TextEditingController _messageController = TextEditingController();

  final AuthContext _auth = AuthContext();

  List<Message> messages = [];

  User? user;

  @override
  void initState() {
    _checkAuthentication();
    super.initState();
  }

  Future<void> _checkAuthentication() async {
    user = await _auth.getCurrentUser();
    setState(() {
      user = user;
    });
    bool userExist = user != null ? true : false;
    if (!userExist) {
      _navigateToAuth();
    }
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  _submitMessage(String message) async {
    _messageController.clear();
    print("_submitMessage ${widget.chatId}");

    await ChatContext.sendMessage(user!.uid, message, widget.chatId);
    print("Submitet $message");
  }

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          info[0]['name'].toString(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(user!, widget.chatId),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.next,
            focusNode: _messageFocusNode,
            onFieldSubmitted: (String value) {
              //Do anything with value
              _nextFocus(_messageFocusNode);

              _submitMessage(value);
            },
            controller: _messageController,
            // validator: (value) => _validateInput(value.toString()),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              // prefixIcon: const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Icon(
              //     Icons.emoji_emotions,
              //     color: Colors.grey,
              //   ),
              // ),
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: const [
              //       Icon(
              //         Icons.camera_alt,
              //         color: Colors.grey,
              //       ),
              //       Icon(
              //         Icons.attach_file,
              //         color: Colors.grey,
              //       ),
              //       Icon(
              //         Icons.money,
              //         color: Colors.grey,
              //       ),
              //     ],
              //   ),
              // ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
