import 'package:advices/App/models/event.dart';
import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/call/call.dart';
import 'package:advices/assets/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../App/contexts/callEventsContext.dart';
import '../authentication/authentication.dart';
import '../shared_widgets/BottomBar.dart';
import '../shared_widgets/base_app_bar.dart';
import 'package:intl/intl.dart';
import 'callMethods.dart';

class Calls extends StatefulWidget {
  const Calls({
    Key? key,
  }) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isLoading = false;
  late AnimationController controller;
  final AuthProvider _auth = AuthProvider();
  User? user;
  @override
  void initState() {
    _checkAuthentication();
    super.initState();
  }

  Future<void> _checkAuthentication() async {
    // bool loggedIn = await _auth.isSignIn();
    user = await _auth.getCurrentUser();

    setState(() {
      user = user;
    });
    print(user?.uid);
    bool userExist = user != null ? true : false;
    if (!userExist) {
      _navigateToAuth();
    }
  }

  Future<void> openCall(channelName) async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      return null;
    }
    Map<String, dynamic>? result = await CallMethods.makeCloudCall(channelName);
    if (result!['token'] != null) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Call(channelName)),
      );
    }
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        redirectToHome: true,
      ),
      bottomNavigationBar: BottomBar(
        fabLocation: FloatingActionButtonLocation.endDocked,
        shape: CircularNotchedRectangle(),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundColor,
            stops: [-1, 1, 2],
          ),
        ),
        child: isLoading
            ? Center(
                child: Icon(
                  Icons.hourglass_bottom,
                  color: Colors.white,
                  size: 100,
                ),
              )
            : _cardsList(),
      ),
    );
  }

  Widget _cardsList() {
    return StreamBuilder<Iterable<EventModel>>(
      stream: CallEventsContext.getAllLEvents(user?.uid),
      builder: ((context, snapshot) {
        if (!snapshot.hasData)
          return Icon(
            Icons.hourglass_bottom,
            color: Colors.white,
            size: 100,
          );
        if (snapshot.hasData) {
          final calls = snapshot.data!;
          return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              children: calls.map(_card).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              semanticsLabel: 'Linear progress indicator',
            ),
          );
        }
      }),
    );
  }

  Widget _card(EventModel call) {
    return Card(
      elevation: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            // leading: const Icon(Icons.person),
            title: Text(call.title.toString()),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 16,
                        ),
                        Text(' ${call.description}'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16),
                        Text(
                            ' ${DateFormat("yyyy-MM-dd hh:mm").format(call.startDate)}'),
                        SizedBox(
                          width: 24,
                        ),
                        call.open == true
                            ? Text(
                                'Некој ве чека веќе',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.green),
                              )
                            : Text('Сеуште нема никој')
                      ],
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => openCall(call.channelName),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
