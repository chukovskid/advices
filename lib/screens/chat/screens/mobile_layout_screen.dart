import 'package:advices/screens/chat/screens/mobile_chat_screen.dart';
import 'package:advices/screens/chat/widgets/chats_call_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:advices/screens/chat/colors.dart';
import 'package:advices/screens/chat/info.dart';
import 'package:flutter/material.dart';

import '../../../App/contexts/authContext.dart';
import '../../../assets/utilities/constants.dart';
import '../../authentication/authentication.dart';
import '../widgets/contacts_list.dart';

class MobileLayoutScreen extends StatefulWidget {
  final Function(String)? callback;

  const MobileLayoutScreen(this.callback, {Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  final AuthContext _auth = AuthContext();

  User? user;
  String chatId = "";

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
    if (widget.callback != null) {
      widget.callback!(selectedChatId);
    }
    setState(() {
      chatId = selectedChatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: darkGreenColor,
          centerTitle: false,
          // title: const Text(
          //   'Advices chat',
          //   style: TextStyle(
          //     fontSize: 20,
          //     color: Colors.grey,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.search, color: Colors.grey),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.grey),
              onPressed: _navigateToAuth,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                // text: 'ПОРАКИ',
                icon: Icon(Icons.chat),
              ),
              Tab(
                // text: 'ПОВИЦИ',
                icon: Icon(Icons.call),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContactsList(user!, callbackSelectChat),
            ChatsCallList(user!, callbackSelectChat),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: tabColor,
        //   child: const Icon(
        //     Icons.comment,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
