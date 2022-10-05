import 'dart:async';

import 'package:advices/screens/call/calls.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:advices/config/agora.config.dart' as config;

const appId = "03f0c2c7973949b3afe5e475f15a350e";
const token =
    "00603f0c2c7973949b3afe5e475f15a350eIABp/OxbbkBAHMVsPgwzNxnG+ARuGPifSxSsCrRlnOEwEWK47TwAAAAAIgAhWaSBpv06YwQAAQA2ujljAgA2ujljAwA2ujljBAA2ujlj";
const channel = "Lk37HV68oaPxOA8AHpNqcSoFgEA3+BegoHlxHbccfYh0wpMCjtWgrUFE2";

class TestCall extends StatefulWidget {
  final String token;
  final String channelId;
  final ClientRole role = ClientRole.Broadcaster;

  /// Construct the [JoinChannelVideo]
  const TestCall({Key? key, required this.token, required this.channelId})
      : super(key: key);

  @override
  _TestCallState createState() => _TestCallState();
}

class _TestCallState extends State<TestCall> {
  bool isJoined = false, switchCamera = true, switchRender = true, muted = false;
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    closeCall();
    super.dispose();
  }

  Future<void> closeCall() async {
    await _engine.leaveChannel();
    await _engine.destroy();
    // await DatabaseService.closeCall(channelId);
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(config.appId);
    // await _engine.leaveChannel();

    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(widget.token, widget.channelId, null, 0);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Agora Video Call'),
      // ),
      body: Stack(
        children: [
          Center(
        child: Stack(
          children: <Widget>[
            _remoteVideo(),
            _toolbar(),
          ],
        ),
      ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? RtcLocalView.SurfaceView()
                    : CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: channel,
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }


  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
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
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
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
          )
        ],
      ),
    );
  }


  Future<void> _onCallEnd(BuildContext context) async {
    // print("Call ENDED ++++++++++++++++ ${channelName}");
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
}
