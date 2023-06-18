import 'package:advices/App/contexts/callEventsContext.dart';
import 'package:advices/screens/authentication/lawyerBasedRedirect.dart';
import 'package:advices/screens/webView/IframeWidget.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:advices/screens/video/config/agora.config.dart' as config;
import 'package:advices/screens/video/examples/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../call/callMethods.dart';
import '../../../../call/calls.dart';
import '../../../../../App/services/database.dart';
import '../../../../chat/screens/mobile_chat_screen.dart';
import '../../../../payment/checkout/checkout.dart';

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  final String token;
  final String channelId;
  final ClientRole role = ClientRole.Broadcaster;

  /// Construct the [JoinChannelVideo]
  const JoinChannelVideo(
      {Key? key, required this.token, required this.channelId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false,
      switchCamera = true,
      switchRender = true,
      muted = false,
      chatOn = false,
      docAi = false,
      cameraOn = true;
  List<int> remoteUid = [];
  late TextEditingController _controller;
  bool _isRenderSurfaceView = false;
  late String uid;
  late String token = widget.token;
  late String channelName = widget.channelId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "Everyone");
    _initEngine();
    getUserUid();
  }

  @override
  void dispose() {
    super.dispose();
    _destroyEngine();
    closeCall();
  }

  void _destroyEngine() async {
    await _engine.leaveChannel();
    await _engine.destroy();
  }

  Future<void> closeCall() async {
    await _engine.leaveChannel();
    await _engine.destroy();
    await CallEventsContext.closeCall(channelName);
  }

  Future<void> getUserUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? storedUid = await preferences.getString("localUid");
    if (storedUid != null) {
      uid = storedUid;
      print("sotred UID: $uid");
    } else {
      int time = DateTime.now().microsecondsSinceEpoch;
      uid = time.toString().substring(1, time.toString().length - 3).toString();
      preferences.setString("localUid", uid);
    }
  }

  Future<void> _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    await _joinChannel();
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        logSink.log('warning $warningCode');
      },
      error: (errorCode) {
        logSink.log('error $errorCode');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        logSink.log('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        logSink.log('userJoined  $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        logSink.log('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        logSink.log('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    print("You are joining with this token: ${widget.token}");
    // await _engine.joinChannel(config.token, _controller.text, null, config.uid); // (token, channelName, )
    await _engine.joinChannel(
        token, channelName, null, 0); // (token, channelName, )
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  /// Toolbar layout
  Widget _toolbarWeb() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _toolbarButtons()),
    );
  }

  Widget _toolbarMobile() {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 0, bottom: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _toolbarButtons(),
      ),
    );
  }

  /// Toolbar layout
  List<Widget> _toolbarButtons() {
    return <Widget>[
      Tooltip(
        message: 'End Call',
        child: RawMaterialButton(
          onPressed: () => _onCallEnd(context),
          child: Icon(
            Icons.call_end,
            color: Colors.white,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.redAccent,
          padding: const EdgeInsets.all(12.0),
        ),
      ),
      Tooltip(
        message: muted ? 'Unmute' : 'Mute',
        child: RawMaterialButton(
          onPressed: _onToggleMute,
          child: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? Colors.white : Colors.blueAccent,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: muted ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12.0),
        ),
      ),
      kIsWeb
          ? SizedBox()
          : Tooltip(
              message: 'Switch Camera',
              child: RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
            ),
      Tooltip(
        message: cameraOn ? 'Turn off camera' : 'Turn on camera',
        child: RawMaterialButton(
          onPressed: _onToggleCamera,
          child: Icon(
            cameraOn ? Icons.videocam : Icons.videocam_off,
            color: cameraOn ? Colors.blueAccent : Colors.white,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: cameraOn ? Colors.white : Colors.blueAccent,
          padding: const EdgeInsets.all(12.0),
        ),
      ),
      LawyerBasedRedirect(
          lawyerWidget: Tooltip(
            message: docAi ? 'Disable Document AI' : 'Enable Document AI',
            child: RawMaterialButton(
              onPressed: _onToggleDocAi,
              child: Icon(
                docAi ? Icons.edit_document : Icons.document_scanner_outlined,
                color: docAi ? Colors.blueAccent : Colors.white,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: docAi ? Colors.white : Colors.blueAccent,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
          nonLawyerWidget: SizedBox()),
      Tooltip(
          message: chatOn ? 'Disable Chat' : 'Enable Chat',
          child: RawMaterialButton(
            onPressed: _onToggleChat,
            child: Icon(
              chatOn ? Icons.chat_outlined : Icons.subtitles_off_outlined,
              color: chatOn ? Colors.blueAccent : Colors.white,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: chatOn ? Colors.white : Colors.blueAccent,
            padding: const EdgeInsets.all(12.0),
          )),
      // RawMaterialButton(
      //   onPressed: () => _confirmPayment(context),
      //   child: Icon(
      //     Icons.payments_outlined,
      //     color: Colors.white,
      //     size: 20.0,
      //   ),
      //   shape: CircleBorder(),
      //   elevation: 2.0,
      //   fillColor: Colors.greenAccent,
      //   padding: const EdgeInsets.all(12.0),
      // ),
    ];
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileLayout =
        screenWidth < 600; // Set the breakpoint for mobile layout

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _viewRows(),
                ),
              ],
            ),
            if (docAi && isMobileLayout)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: screenWidth * 0.85,
                child: IframeWidget(src: "https://advices.chat/"),
              ),
            if (chatOn && isMobileLayout)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: screenWidth * 0.85,
                child: MobileChatScreen(channelName),
              ),
            isMobileLayout ? _toolbarMobile() : _toolbarWeb(),
          ],
        ),
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());
    remoteUid.forEach((int uid) => list.add(rtc_remote_view.SurfaceView(
          uid: uid,
          channelId: channelName,
        )));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  Future<void> _onCallEnd(BuildContext context) async {
    print("Call ENDED ++++++++++++++++ ${channelName}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calls()),
    );
    await closeCall();

    // TODO

    // Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onToggleCamera() {
    cameraOn ? _engine.disableVideo() : _engine.enableVideo();
    setState(() {
      cameraOn = !cameraOn;
    });
  }

  void _onToggleDocAi() {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobileLayout =
          screenWidth < 600; // Set the breakpoint for mobile layout

      if (isMobileLayout && chatOn) {
        chatOn = false;
      }
      docAi = !docAi;
    });
  }

  void _onToggleChat() {
    setState(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobileLayout =
          screenWidth < 600; // Set the breakpoint for mobile layout

      if (isMobileLayout && docAi) {
        docAi = false;
      }
      chatOn = !chatOn;
    });
  }
}

_confirmPayment(BuildContext context) {
  showPopup(context);
  redirectToCheckout(context);
}

void showPopup(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text('Успешна наплата'),
    ),
  );
}
