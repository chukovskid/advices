import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:advices/config/agora.config.dart' as config;
import 'package:advices/examples/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screens/call/callMethods.dart';

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

  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  late TextEditingController _controller;
  bool _isRenderSurfaceView = false;
  late String uid;
  late String token = widget.token;
  late String channelName = widget.channelId;
  bool muted = false;

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
    _engine.destroy();
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
    // var result = await CallMethods.makeCloudCall();
    // setState(() {
    //   // token = result?["token"] ;
    //   // channelName = result?["channelName"];
    //     token = '00603f0c2c7973949b3afe5e475f15a350eIAAirL6BKbjLyEke7MvNyUTyg9Tl4J+GUboWW0pcYElEYc1EU08AAAAAIgDgYjwamtSoYgQAAQAqkadiAgAqkadiAwAqkadiBAAqkadi';
    //   channelName = '12';

    // });
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

  _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      logSink.log('switchCamera $err');
    });
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
  }

  _changeChannel() async {
    print("Test123controler: ${_controller.text}");

    Map<String, dynamic>? newCallCredentials =
        await CallMethods.makeCloudCall(_controller.text);

    if (newCallCredentials!['token'] != null) {
      await _leaveChannel();

      setState(() {
        token = newCallCredentials['token'];
        channelName = newCallCredentials['channelId'];
      });
      await _joinChannel();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
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

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
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










/////////////////////// OLD UI >>>>>
  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           TextFormField(
  //             onFieldSubmitted: (String value) async {
  //               _changeChannel();
  //             },
  //             controller: _controller,
  //             decoration: const InputDecoration(hintText: 'Channel ID'),
  //           ),
  //           if (!kIsWeb &&
  //               (defaultTargetPlatform == TargetPlatform.android ||
  //                   defaultTargetPlatform == TargetPlatform.iOS))
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                     'Rendered by SurfaceView \n(default TextureView): '),
  //                 Switch(
  //                   value: _isRenderSurfaceView,
  //                   onChanged: isJoined
  //                       ? null
  //                       : (changed) {
  //                           setState(() {
  //                             _isRenderSurfaceView = changed;
  //                           });
  //                         },
  //                 )
  //               ],
  //             ),
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: ElevatedButton(
  //                   onPressed: isJoined ? _leaveChannel : _joinChannel,
  //                   child: Text('${isJoined ? 'Leave' : 'Join'} channel'),
  //                 ),
  //               )
  //             ],
  //           ),
  //           _renderVideo(),
  //         ],
  //       ),
  //       if (defaultTargetPlatform == TargetPlatform.android ||
  //           defaultTargetPlatform == TargetPlatform.iOS)
  //         Align(
  //           alignment: Alignment.bottomRight,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: _switchCamera,
  //                 child: Text('Camera ${switchCamera ? 'front' : 'rear'}'),
  //               ),
  //             ],
  //           ),
  //         )
  //     ],
  //   );
  // }

  // _renderVideo() {
  //   return Expanded(
  //     child: Stack(
  //       children: [
  //         Container(
  //           child: (kIsWeb || _isRenderSurfaceView)
  //               ? const rtc_local_view.SurfaceView(
  //                   zOrderMediaOverlay: true,
  //                   zOrderOnTop: true,
  //                 )
  //               : const rtc_local_view.TextureView(),
  //         ),
  //         Align(
  //           alignment: Alignment.topLeft,
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Row(
  //               children: List.of(remoteUid.map(
  //                 (e) => GestureDetector(
  //                   onTap: _switchRender,
  //                   child: SizedBox(
  //                     width: 120,
  //                     height: 120,
  //                     child: (kIsWeb || _isRenderSurfaceView)
  //                         ? rtc_remote_view.SurfaceView(
  //                             uid: e,
  //                             channelId: _controller.text,
  //                           )
  //                         : rtc_remote_view.TextureView(
  //                             uid: e,
  //                             channelId: _controller.text,
  //                           ),
  //                   ),
  //                 ),
  //               )),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }





