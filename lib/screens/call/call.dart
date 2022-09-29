import 'package:advices/screens/call/callMethods.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:advices/screens/home.dart';
import 'package:advices/screens/profile/lawyerProfile.dart';
import 'package:advices/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../examples/basic/join_channel_video/join_channel_video.dart';
import '../../examples/advanced/index.dart';
import '../../examples/basic/index.dart';
import '../../config/agora.config.dart' as config;
import '../../services/auth.dart';
import '../../utilities/constants.dart';
import '../authentication/authentication.dart';
import '../shared_widgets/base_app_bar.dart';

/// This widget is the root of your application.
class Call extends StatefulWidget {
  final String channellName;

  /// Construct the [Call]
  const Call(this.channellName, {Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  final AuthService _auth = AuthService();
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

  bool _isConfigInvalid() {
    return config.appId == '<YOUR_APP_ID>' || // Why are we using this?
        config.token == '<YOUR_TOKEN>' ||
        config.channelId == '<YOUR_CHANNEL_ID>';
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
    List<String> lawyerIdandclientId = widget.channellName.split("+");
    String lawyerId = lawyerIdandclientId[0];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LawyerProfile(lawyerId)),
    );
  }

  Future<void> openCall(channelName) async {
    if (user == null) {
      return null;
    }

    // String channelName = widget.uid + "+" + user!.uid;
    print("Jou will join with this channelName : $channelName");
    Map<String, dynamic>? result = await CallMethods.makeCloudCall(channelName);
    if (result!['token'] != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // JoinChannelVideo(
                  //       token: result['token'],
                  //       channelId: result['channelId'],
                  //     )));

                  Scaffold(
                    body: JoinChannelVideo(
                      token: result['token'],
                      channelId: result['channelId'],
                    ),
                  )));
    }
    ;
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
            stops: [-1, 2],
          ),
        ),
        child: _selectChannelName() // _selectLawArea(), // _allUsersForm(),
        // child: _dropdownLawSelect(),
        );
  }

  Widget _selectChannelName() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreenColor,
        automaticallyImplyLeading: false,
        elevation: 10.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.home),
            label: Text(''),
            onPressed: _navigateToHome,
          ),
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.call),
            label: Text(''),
            onPressed: _navigateToCalls,
          ),
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.balance),
            label: Text(''),
            onPressed: _navigateToLawyerProfile
          ),
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person),
            label: Text(''),
            onPressed: _navigateToAuth,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: FaIcon(
                    FontAwesomeIcons.gavel,
                    semanticLabel: "label",
                    size: 50,
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Go to the video call',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: MaterialButton(
                    onPressed: onJoin,
                    height: 60,
                    color: orangeColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Join',
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
      myController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    List<String> lawyerIdandclientId = widget.channellName.split("+");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];

    // TODO secure user?
    String channelName =
        await DatabaseService.updateAsOpenCallForUsers(lawyerId, clientId);
// TODO instead of saveOpenCallForUser, create a function setCallToOpen()
// // meaning there is someone at the call and is WAITING
    await openCall(channelName);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
