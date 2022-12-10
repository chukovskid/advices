import 'package:advices/assets/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:advices/screens/chat/colors.dart';
import '../../../App/contexts/authContext.dart';
import '../../../App/contexts/chatContext.dart';
import '../../../App/models/message.dart';
import '../../authentication/authentication.dart';
import '../widgets/chat_list.dart';
import '../widgets/contacts_list.dart';
import '../widgets/web_chat_appbar.dart';
import '../widgets/web_profile_bar.dart';
import '../widgets/web_search_bar.dart';

class WebLayoutScreen extends StatefulWidget {
  final String? chatId;
  WebLayoutScreen(this.chatId, {Key? key}) : super(key: key);

  @override
  State<WebLayoutScreen> createState() => _WebLayoutScreenState();
}

class _WebLayoutScreenState extends State<WebLayoutScreen> {
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final AuthContext _auth = AuthContext();
  List<Message> messages = [];
  User? user;
  String chatId = "";

  @override
  void initState() {
    _checkAuthentication();

    setState(() {
      chatId = widget.chatId != null ? widget.chatId.toString() : "";
    });
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
    await ChatContext.sendMessage(user!.uid, message, chatId);
    print("Submitet $message");
  }

  callbackSelectChat(selectedChatId) {
    setState(() {
      chatId = selectedChatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WebProfileBar(),
                  WebSearchBar(),
                  ContactsList(user!, callbackSelectChat),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: dividerColor),
              ),
              image: DecorationImage(
                image: AssetImage(
                  "../../../lib/assets/images/backgroundImage.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const ChatAppBar(),
                const SizedBox(height: 20),
                //////////////// TODO add text if there is no chat selected
                chatId == ""
                    ? Expanded(child: Text("Please select a chat", style: TextStyle(color: whiteColor),))
                    : Expanded(
                        child: ChatList(user!, chatId),
                      ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: dividerColor),
                    ),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 15,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: _messageFocusNode,
                            onFieldSubmitted: (String value) {
                              //Do anything with value
                              // _nextFocus(_passwordFocusNode);

                              _submitMessage(value);
                            },
                            controller: _messageController,
                            // validator: (value) => _validateInput(value.toString()),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                fillColor: Colors.transparent,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.transparent,
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print("mic button");
                        },
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        ),
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
