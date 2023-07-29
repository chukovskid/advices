import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/chat/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../App/helpers/resizableWidget.dart';
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
  int price = 0;

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
    if (message.isEmpty) {
      return;
    }
    _messageController.clear();
    await _chatProvider.sendMessage(user!.uid, message, widget.chatId,
        price: price);
    price = 0;
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
        Container(
          color: mobileChatBoxColor,
          child: Row(
            children: [
              Expanded(
                child: ResizableWidget(
                  minHeight: 56,
                  maxHeight: MediaQuery.of(context).size.height / 2,
                  child: Container(
                    color: mobileChatBoxColor,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      focusNode: _messageFocusNode,
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
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
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 56,
                  width: 120,
                  child: Container(
                    color: mobileChatBoxColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showPriceDialog();
                          },
                          child: _buildPriceButton(),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            _nextFocus(_messageFocusNode);
                            _submitMessage(_messageController.text);
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
  );
}

  void _showPriceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController priceController = TextEditingController();

        return Dialog(
          child: Container(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Внесете цена во денари',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Цена',
                      hintText: 'Внесете цена',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      int? enteredPrice =
                          int.tryParse(priceController.text.trim());
                      if (enteredPrice != null) {
                        setState(() {
                          price = enteredPrice;
                        });
                        Navigator.pop(context);
                      } else {
                        // Show error message or handle invalid price input
                      }
                    },
                    child: Text('Зачувај'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceButton() {
    return Container(
      width: null,
      child: price != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 10,
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${price} ден.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )
          : Icon(
              Icons.payment,
              color: tabColor,
            ),
    );
  }
}
