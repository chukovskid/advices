import 'package:advices/App/providers/auth_provider.dart';
import 'package:advices/screens/call/callMethods.dart';
import 'package:advices/screens/call/calls.dart';
import 'package:advices/screens/home/home.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../App/contexts/callEventsContext.dart';
import '../video/examples/basic/join_channel_video/join_channel_video.dart';
import '../../assets/utilities/constants.dart';
import '../authentication/authentication.dart';
import 'package:advices/screens/video/config/agora.config.dart' as config;

/// This widget is the root of your application.
class DemoCall extends StatefulWidget {
  final String channelName;

  const DemoCall(this.channelName, {Key? key}) : super(key: key);

  @override
  State<DemoCall> createState() => _DemoCallState();
}

class _DemoCallState extends State<DemoCall> {
  bool isLoading = false;
  final AuthProvider _auth = AuthProvider();
  User? user;
  final myController = TextEditingController();
  bool _validateError = false;
  late final RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

  }
  Future<void> _checkAuthentication() async {
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
        child: _joinChannelButton()
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
                      SizedBox(height: 60),
                      Text(
                        'Продолжи кон видео повикот!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // SizedBox(
                      //   height: 1400,
                      //   width: 1800,
                      //   child: Container(
                      //     child: Expanded(child: VideoCall(isLocalUser: true,)),
                      //   ),
                      // ),

                      SizedBox(height: 20),
                      // AgoraLocalView(),

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

    List<String> lawyerIdandclientId = widget.channelName.split("-");
    String lawyerId = lawyerIdandclientId[0];
    String clientId = lawyerIdandclientId[1];
    String receiverId = user!.uid == clientId ? lawyerId : clientId;

    await CallEventsContext.callUser(widget.channelName, receiverId);

    setState(() {
      isLoading = false;
    });
    await openCall(widget.channelName);
  }

}
