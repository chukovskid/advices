import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/chat/widgets/chats_call_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:advices/screens/chat/colors.dart';
import '../../../assets/utilities/constants.dart';
import '../../authentication/authentication.dart';
import '../widgets/contacts_list.dart';
import 'mobile_chat_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  final Function(String)? callback;
  final bool isDrawer;

  const MobileLayoutScreen(this.callback, {Key? key, this.isDrawer = false})
      : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  final AuthProvider _auth = AuthProvider();
  User? user;
  String chatId = "";
  bool showChat = false;

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

  callbackSelectChat(selectedChatId) {
    bool isLargeScreen = MediaQuery.of(context).size.width >= 850.0;

    if (widget.callback != null) {
      widget.callback!(selectedChatId);
    }

    if (!widget.isDrawer && isLargeScreen) {
      setState(() {
        chatId = selectedChatId;
      });
    } else if (widget.isDrawer) {
      setState(() {
        chatId = selectedChatId;
        showChat = true;
      });
    } else {
      _navigateToMobileChat(selectedChatId);
    }
  }

  _navigateToMobileChat(String chatId) {
    print("_navigateToMobileChat $chatId");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileChatScreen(chatId)),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: darkGreenColor,
          centerTitle: false,
          leading: widget.isDrawer && showChat
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      showChat = false;
                    });
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: _navigateToAuth,
            ),
          ],
          bottom: widget.isDrawer && showChat
              ? null
              : TabBar(
                  indicatorColor: tabColor,
                  indicatorWeight: 4,
                  labelColor: tabColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.chat),
                    ),
                    Tab(
                      icon: Icon(Icons.call),
                    ),
                  ],
                ),
        ),
        body: widget.isDrawer && showChat
            ? MobileChatScreen(chatId)
            : TabBarView(
                children: [
                  ContactsList(user!, callbackSelectChat),
                  ChatsCallList(user!, callbackSelectChat),
                ],
              ),
      ),
    );
  }
}
