import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/call/callMethods.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:advices/screens/call/testCall.dart';
import 'package:advices/screens/home/home.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/App/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../App/contexts/callEventsContext.dart';
import '../../App/models/event.dart';
import '../video/examples/advanced/enable_virtualbackground/enable_virtualbackground.dart';
import '../video/examples/basic/join_channel_video/join_channel_video.dart';
import '../video/examples/advanced/index.dart';
import '../video/examples/basic/index.dart';
import '../video/config/agora.config.dart' as config;
import '../../assets/utilities/constants.dart';
import '../authentication/authentication.dart';
import '../shared_widgets/base_app_bar.dart';
import 'EventDesctiprion.dart';

/// This widget is the root of your application.
class Call extends StatefulWidget {
  final EventModel call;

  /// Construct the [Call]
  const Call(this.call, {Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  bool isLoading = false;
  final AuthProvider _auth = AuthProvider();
  User? user;
  final myController = TextEditingController();
  bool _validateError = false;
  final _data = [...basic, ...advanced];

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
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

  _navigateToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  _navigateToCalls() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Calls()),
    );
  }

  _navigateToLawyerProfile() {
    List<String> lawyerIdandclientId = widget.call.channelName.split("-");
    String lawyerId = lawyerIdandclientId[0];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LawyerProfile(lawyerId, "")),
    );
  }

  Future<void> openCall(channelName) async {
    if (user == null) {
      return null;
    }
    print("Jou will join with this channelName : $channelName");
    Map<String, dynamic>? result = await CallMethods.makeCloudCall(channelName);
    if (result!['token'] != null) {
      // THIS IS WORKING ON WEB AND ANDROID!
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JoinChannelVideo(
                    token: result['token'],
                    channelId: result['channelId'],
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: _joinChannelButton() // _selectLawArea(), // _allUsersForm(),
        // child: _dropdownLawSelect(),
        );
  }

  Widget _joinChannelButton() {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15.0,
        backgroundColor: darkGreenColor,
        automaticallyImplyLeading: false,
        elevation: 10.0,
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                icon: Icon(Icons.home),
                label: Text(''),
                onPressed: _navigateToHome,
              ),
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                icon: Icon(Icons.call),
                label: Text(''),
                onPressed: _navigateToCalls,
              ),
              TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  icon: Icon(Icons.balance),
                  label: Text(''),
                  onPressed: _navigateToLawyerProfile),
              TextButton.icon(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                icon: Icon(Icons.person),
                label: Text(''),
                onPressed: _navigateToAuth,
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Icon(
                Icons.hourglass_bottom,
                color: Colors.white,
                size: 100,
              ),
            )
          : SafeArea(
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Container(
                      //   child: FaIcon(
                      //     FontAwesomeIcons.gavel,
                      //     semanticLabel: "label",
                      //     size: 50,
                      //   ),
                      //   height: MediaQuery.of(context).size.height * 0.1,
                      // ),
                      // Padding(padding: EdgeInsets.only(top: 20)),

                      Container(
                        width: MediaQuery.of(context).size.width > 500
                            ? 500
                            : double.infinity,
                        height: MediaQuery.of(context).size.height > 500
                            ? 300
                            : double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(
                              10.0), // 8.0 is the amount of padding in logical pixels
                          child: EventWidget(event: widget.call),
                        ),
                      ),
                      // Container(
                      //   child: EventWidget(event: widget.call),
                      // ),
                      SizedBox(height: 60),
                      Text(
                        'Продолжи кон видео повикот!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),

                      Container(
                        width: 200,
                        child: MaterialButton(
                          onPressed: onJoin,
                          height: 60,
                          color: orangeColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Продолжи',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      isLoading = true;
      myController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    List<String> lawyerIdandclientId = widget.call.channelName.split("-");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];
    String receiverId = user!.uid == clientId ? lawyerId : clientId;

    // TODO secure user?
    // String channelName =
    //     await DatabaseService.updateAsOpenCallForUsers(lawyerId, clientId);

    await CallEventsContext.callUser(widget.call.channelName, receiverId);

// TODO instead of saveOpenCallForUser, create a function setCallToOpen()
// // meaning there is someone at the call and is WAITING
    setState(() {
      isLoading = false;
    });
    await openCall(widget.call.channelName);
  }

  // Future<void> _handleCameraAndMic(Permission permission) async {
  //   final status = await permission.request();
  //   print(status);
  // }
}
