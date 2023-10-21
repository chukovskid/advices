import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/chat/colors.dart';
import 'package:advices/screens/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../App/helpers/CustomCircularProgressIndicator.dart';
import '../../../App/helpers/resizableWidget.dart';
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
  User? user;
  String chatId = "";
  bool loading = true;
  bool mkLanguage = true;
  int? price;
  final FocusNode _messageFocusNode = FocusNode();

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
        ? Center(child: CustomCircularProgressIndicator())
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
                              // padding: const EdgeInsets.symmetric(
                              //   horizontal: 20.0,
                              //   vertical: 10.0,
                              // ),
                              decoration: BoxDecoration(
                                color: mobileChatBoxColor,
                                border: Border(
                                  top: BorderSide(color: dividerColor),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ResizableWidget(
                                      minHeight: 56,
                                      maxHeight:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Container(
                                        color: mobileChatBoxColor,
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          focusNode: _messageFocusNode,
                                          controller: _messageController,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            filled: true,
                                            fillColor: mobileChatBoxColor,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700]),
                                            hintText: 'Напиши порака!',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 56,
                                      child: Container(
                                        color: mobileChatBoxColor,
                                        child: Row(
                                          children: [
                                            // IconButton(
                                            //   icon: _buildPriceButton(),
                                            //   onPressed: () {
                                            //     _showPriceBottomSheet();
                                            //   },
                                            // ),
                                            IconButton(
                                              icon: Icon(Icons.send,
                                                  color: Colors.white),
                                              onPressed: () {
                                                // _nextFocus(_messageFocusNode);
                                                _submitMessage(
                                                    _messageController.text);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
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

  void _showPriceBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          TextEditingController priceControllerWeb = TextEditingController();

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Внесете цена во денари',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Material(
                    child: TextField(
                      controller: priceControllerWeb,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Цена',
                        hintText: 'Внесете цена',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      int? enteredPrice =
                          int.tryParse(priceControllerWeb.text.trim());
                      if (enteredPrice != null) {
                        setModalState(() {
                          price = enteredPrice;
                        });
                        Navigator.pop(context);
                      } else {
                        // Show error message or handle invalid price input
                        print("Invalid price entered");
                      }
                    },
                    child: Text('Зачувај'),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget _buildPriceButton() {
    return price != null
        ? Row(
            children: [
              Icon(
                Icons.lock,
                color: Colors.white,
                size: 10,
              ),
              Text(
                ' \$${price}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Set the font size as needed
                ),
              ),
            ],
          )
        : Icon(
            Icons.payment,
            color: tabColor,
          );
  }
}
