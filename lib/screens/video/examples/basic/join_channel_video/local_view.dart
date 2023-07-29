import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:advices/screens/video/config/agora.config.dart' as config;

class VideoCall extends StatefulWidget {
  final bool isLocalUser;

  VideoCall({required this.isLocalUser});

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int _remoteUid=1;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    _engine = await RtcEngine.create(config.appId);
    await _engine.enableVideo();
    
    if(!widget.isLocalUser) {
      _engine.enableLocalVideo(false);
    }

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          setState(() {
            _remoteUid = 0;
          });
        },
      ),
    );

    await _engine.joinChannel(config.token, "InstaClass", null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: widget.isLocalUser 
            ? _localUserJoined ? rtc_local_view.SurfaceView() : CircularProgressIndicator()
            : _remoteVideo(),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != 0) {
      return rtc_remote_view.SurfaceView(
        uid: _remoteUid,
        channelId: "InstaClass",
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
