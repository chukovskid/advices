import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/chat/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../App/models/message.dart';
import '../../../App/providers/chat_provider.dart';
import '../../authentication/authentication.dart';
import '../widgets/chat_list.dart';
import '../widgets/chat_appbar.dart';

class MobileChatScreen extends StatefulWidget {
  final String chatId;

  const MobileChatScreen(this.chatId, {Key? key}) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final AuthProvider _auth = AuthProvider();
  final ChatProvider _chatProvider = ChatProvider();

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
    await _chatProvider.sendMessage(user!.uid, message, widget.chatId);
    print("Submitet $message");
  }

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: ChatAppBar(widget.chatId),
          ),
          Expanded(
            child: ChatList(user!, widget.chatId),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            focusNode: _messageFocusNode,
            onFieldSubmitted: (String value) {
              _nextFocus(_messageFocusNode);
              _submitMessage(value);
            },
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              hintStyle: TextStyle(color: Colors.grey[700]),
              hintText: 'Напиши порака!',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
