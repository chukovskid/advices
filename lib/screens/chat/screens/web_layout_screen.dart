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
import '../widgets/chat_appbar.dart';
import '../widgets/web_profile_bar.dart';
import 'mobile_layout_screen.dart';

////
////Remove unnecessary import statements and unused variables/fields.
// Use final or const keywords where appropriate to make the code more efficient.
// Use null safety operators (?.) to avoid NullThrownError exceptions.
// Rename variables and fields to be more descriptive and use camelCase for names.
// Use setState() in initState() to initialize chatId and user.
// Use Future and async/await keywords to make the code more readable and improve performance.
// Use a StreamBuilder instead of a StatefulWidget to update the UI based on real-time changes in the data.
// Use Theme.of(context).textTheme.bodyText1 instead of hard-coded text styles.
// Here is the impro

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
  bool mkLanguage = true;
  bool loading = true;

  @override
  void initState() {
    setState(() {
      chatId = widget.chatId != null ? widget.chatId.toString() : "";
    });
    _checkAuthentication();

    super.initState();
  }

  void _checkAuthentication() async {
    user = await _auth.getCurrentUser();
    // bool userExist = user != null ? true : false;
    if (user == null) {
      _navigateToAuth();
    }
    setState(() {
      user = user;
      loading = false;
    });
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

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: 
                        MobileLayoutScreen(callbackSelectChat),
                  
                  // SingleChildScrollView(
                  //   child: 
                    
                  //   // Column(
                  //   //   children: [
                  //   //     WebProfileBar(user?.photoURL),
                  //   //     // WebSearchBar(),
                  //   //     ContactsList(user!, callbackSelectChat),
                  //   //   ],
                  //   // ),
                  // ),
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
                            const SizedBox(height: 20),
                            Expanded(
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.send,
                                        focusNode: _messageFocusNode,
                                        onFieldSubmitted: (String value) {
                                          _nextFocus(_messageFocusNode);
                                          _submitMessage(value);
                                        },
                                        controller: _messageController,
                                        // validator: (value) => _validateInput(value.toString()),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                            fillColor: Colors.transparent,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
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
