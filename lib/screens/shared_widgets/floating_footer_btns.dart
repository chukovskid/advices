import 'package:flutter/material.dart';
import '../home/help_screen.dart';
import '../home/home.dart';

class FloatingFooterBtns extends StatefulWidget {
  final bool? helpBtn;
  final bool? versionNumber;
  final bool? settingsBtn;
  final bool? backBtn;

  FloatingFooterBtns(
      {this.helpBtn, this.versionNumber, this.settingsBtn, this.backBtn});
  @override
  State<FloatingFooterBtns> createState() => _FloatingFooterBtnsState();
}

class _FloatingFooterBtnsState extends State<FloatingFooterBtns> {
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    getVersion();
  }
  
  Future getVersion() async {
    // await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //   setState(() {
    //   buildNumber = packageInfo.buildNumber;

    //   });
    // });
      buildNumber = "2";

  }

  void goToSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void goToHelpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                _helpBtn(),
                _versionNumber(),
                _settingsBtn(),
                _backBtn()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _helpBtn() {
    return widget.helpBtn == true
        ? Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 20,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: "helpBtn",
                onPressed: goToHelpScreen,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(Icons.help),
              ),
            ),
          )
        : SizedBox();
  }

  Widget _versionNumber() {
    return widget.versionNumber == true
        ? Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 35,
              left: MediaQuery.of(context).size.height / 25,
            ),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text("Version-0.$buildNumber",
                    style: TextStyle(
                      color: Color.fromARGB(255, 15, 4, 4),
                      fontFamily: 'OpenSans',
                    ))),
          )
        : SizedBox();
  }

  Widget _settingsBtn() {
    return widget.settingsBtn == true
        ? Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "settingsBtn",
              onPressed: goToSettingsScreen,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(Icons.settings),
            ),
          )
        : SizedBox();
  }

  Widget _backBtn() {
    return widget.backBtn == true
        ? Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "backBtn",
              onPressed: goBack,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(Icons.arrow_back_outlined),
            ),
          )
        : SizedBox();
  }
}
