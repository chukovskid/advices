import 'package:advices/screens/call/callMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../examples/basic/join_channel_video/join_channel_video.dart';
import '../../examples/log_sink.dart';
import '../../examples/advanced/index.dart';
import '../../examples/basic/index.dart';
import '../../config/agora.config.dart' as config;
import '../../examples/log_sink.dart';
import '../../utilities/constants.dart';
import '../authentication/authentication.dart';

/// This widget is the root of your application.
class Call extends StatefulWidget {
  /// Construct the [Call]
  const Call({Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  final myController = TextEditingController();
  bool _validateError = false;
  final _data = [...basic, ...advanced];

  bool _isConfigInvalid() {
    return config.appId == '<YOUR_APP_ID>' || // Why are we using this?
        config.token == '<YOUR_TOKEN>' ||
        config.channelId == '<YOUR_CHANNEL_ID>';
  }

  _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Authenticate()),
    );
  }

  Future<void> openCall() async {
    Map<String, dynamic>? result = await CallMethods.makeCloudCall("Everyone");
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
    return 
     Container(
          height: double.maxFinite,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(107, 119, 141, 1),
                Color.fromRGBO(38, 56, 89, 1),
              ],
              stops: [-1, 2],
            ),
          ),
          child: _selectChannelName() // _selectLawArea(), // _allUsersForm(),
          // child: _dropdownLawSelect(),
          );
  }

  Widget _selectChannelName(){
    return     Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 34, 59, 1),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.person_outline_sharp),
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
                  'Write some channel name to connect',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      labelText: 'Channel Name',
                      labelStyle: TextStyle(color: orangeColor),
                      hintText: 'test',
                      hintStyle: TextStyle(color: Colors.black45),
                      errorText:
                          _validateError ? 'Channel name is mandatory' : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: orangeColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: MaterialButton(
                    onPressed: onJoin,
                    height: 40,
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
    // await _handleCameraAndMic(Permission.camera);
    // await _handleCameraAndMic(Permission.microphone);

    await openCall();
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => JoinChannelVideo(channelName: myController.text),
    //     ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
































































  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: Scaffold(
  //         // appBar: AppBar(
  //         //   backgroundColor: Color.fromRGBO(23, 34, 59, 1),
  //         //   elevation: 0.0,
  //         //   actions: <Widget>[
  //         //     FlatButton.icon(
  //         //       textColor: Colors.white,
  //         //       icon: Icon(Icons.person_outline_sharp),
  //         //       label: Text(''),
  //         //       onPressed: _navigateToAuth,
  //         //     ),
  //         //   ],
  //         // ),
  //         body: ListTile(
  //           onTap: () async {
  //             openCall();
  //           },
  //           title: Text(
  //             'JoinChannelVideo',
  //             style: const TextStyle(fontSize: 24, color: Colors.black),
  //           ),
  //         )

          //  _isConfigInvalid()
          //     ? const InvalidConfigWidget()
          //     : ListView.builder(
          //         itemCount: _data.length,
          //         itemBuilder: (context, index) {
          //           return _data[index]['widget'] == null
          //               ? Ink(
          //                   color: Colors.grey,
          //                   child: ListTile(
          //                     title: Text(_data[index]['name'] as String,
          //                         style: const TextStyle(
          //                             fontSize: 24, color: Colors.white)),
          //                   ),
          //                 )
          //               : ListTile(
          //                   onTap: () {
          //                     Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) => Scaffold(
          //                                   appBar: AppBar(
          //                                     title: Text("JoinChannelVideo"),
          //                                     // ignore: prefer_const_literals_to_create_immutables
          //                                     actions: [const LogActionWidget()],
          //                                   ),
          //                                   body: JoinChannelVideo(),
          //                                 )));
          //                   },
          //                   title: Text(
          //                     'JoinChannelVideo',
          //                     style: const TextStyle(
          //                         fontSize: 24, color: Colors.black),
          //                   ),
          //                 );
          //           // _data[index]['widget'] == null
          //           //     ? Ink(
          //           //         color: Colors.grey,
          //           //         child: ListTile(
          //           //           title: Text(_data[index]['name'] as String,
          //           //               style: const TextStyle(
          //           //                   fontSize: 24, color: Colors.white)),
          //           //         ),
          //           //       )
          //           //     : ListTile(
          //           //         onTap: () {
          //           //           Navigator.push(
          //           //               context,
          //           //               MaterialPageRoute(
          //           //                   builder: (context) => Scaffold(
          //           //                         appBar: AppBar(
          //           //                           title: Text(
          //           //                               _data[index]['name'] as String),
          //           //                           // ignore: prefer_const_literals_to_create_immutables
          //           //                           actions: [const LogActionWidget()],
          //           //                         ),
          //           //                         body:
          //           //                             _data[index]['widget'] as Widget?,
          //           //                       )));
          //           //         },
          //           //         title: Text(
          //           //           _data[index]['name'] as String,
          //           //           style: const TextStyle(
          //           //               fontSize: 24, color: Colors.black),
          //           //         ),
          //           //       );
          //         },
//           //       ),

//           ),
//     );
//   }
// }

// /// This widget is used to indicate the configuration is invalid
// class InvalidConfigWidget extends StatelessWidget {
//   /// Construct the [InvalidConfigWidget]
//   const InvalidConfigWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.red,
//       child: const Text(
//           'Make sure you set the correct appId, token, channelId, etc.. in the lib/config/agora.config.dart file.'),
//     );
//   }
// }
