import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/chat/colors.dart';
import 'package:advices/screens/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/providers/chat_provider.dart';
import '../../../assets/utilities/constants.dart';
import '../widgets/chat_appbar.dart';
import '../widgets/chat_list.dart';
import 'mobile_layout_screen.dart';

class WebLayoutScreen extends StatefulWidget {
  final String? chatId;
  WebLayoutScreen(this.chatId, {Key? key}) : super(key: key);

  @override
  State<WebLayoutScreen> createState() => _WebLayoutScreenState();
}

class _WebLayoutScreenState extends State<WebLayoutScreen> {
  FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final ChatProvider _chatProvider = ChatProvider();
  final AuthProvider _auth = AuthProvider();
  User? user ;
  String chatId = "";
  bool loading = true;
  bool mkLanguage = true;

  @override
  void initState() {
    chatId = widget.chatId ?? '';
    _checkAuthentication();
    super.initState();
  }

  Future<void> _checkAuthentication() async {
    user = await _auth.getCurrentUser();
    if (user == null) {
      _navigateToAuth();
    }
    setState(() {
      loading = false;
    });
  }

  void _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  Future<void> _submitMessage(String message) async {
    _messageController.clear();
    await _chatProvider.sendMessage(user!.uid, message, chatId);
  }

  void callbackSelectChat(String selectedChatId) {
    setState(() {
      chatId = selectedChatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_textFieldFocusNode);
    return loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MobileLayoutScreen(callbackSelectChat),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: dividerColor),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "../../../lib/assets/images/backgroundImage.png",
                      ),
                    ),
                  ),
                  child: chatId == ""
                      ? Center(
                          child: Text(
                          mkLanguage
                              ? "Одберете разговор"
                              : "Please select a chat",
                          style: TextStyle(color: whiteColor),
                        ))
                      : Column(
                          children: [
                            ChatAppBar(chatId),
                            Expanded(
                              child: ChatList(user!, chatId),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(color: dividerColor),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      focusNode: _textFieldFocusNode,
                                      autofocus: true,
                                      controller: _messageController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Напиши порака',
                                      ),
                                      onSubmitted: (value) => _submitMessage(
                                          _messageController.text),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () =>
                                        _submitMessage(_messageController.text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
  }
}



