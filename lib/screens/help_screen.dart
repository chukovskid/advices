import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../helpers/sharedPreferencesHelper.dart';
import 'authentication/authentication.dart';
import 'floating_footer_btns.dart';

class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  bool languageDanish = true;

  @override
  void initState() {
    _getLanguagePreference();
  }

  Future<void> _getLanguagePreference() async {
    dynamic newState = await SharedPreferencesHelper.getLanguagePreference();
    setState(() {
      languageDanish = newState;
    });
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
      floatingActionButton:
          new FloatingFooterBtns(versionNumber: false, backBtn: true),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              // Container(
              //   height: double.infinity,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("lib/assets/images/login_background.jpg"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogo(),
                      SizedBox(height: 50.0),
                      _buildHelpText()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return Column(
      children: [
        Text(
            languageDanish
                ? "For at bruge FIDIMI Sync applikationen skal du logge ind med samme e-mailadresse og kodeord som du bruger på FIDIMI platformen."
                : "To use the FIDIMI Sync application, you need to log in with the same e-mail address and password that you use on the FIDIMI platform.",
            ),
        Text("", ),
        Text(
            languageDanish
                ? "FIDIMI Sync bruges til at indhente skridtdata fra din enhed og overføre dem til din personlige profil på FIDIMI platformen. Der er to måder, hvorpå FIDIMI Sync kan indhente skridtdata; fra Google Fit eller enhedens egen skridttæller. Vi anbefaler, at du vælger, at dine skridtdata skal indhentes fra Google Fit, idet du så kan få skridtdata fra alle de enheder, som integrerer med Google Fit. Du behøver ikke installere Google Fit på den samme enhed, som du har installeret FIDIMI Sync - det er blot vigtigt, at du installerer Google Fit på den enhed, som registrerer dine skridtdata."
                : "FIDIMI Sync is used to collect step data from your device and transfer it to your personal profile on the FIDIMI platform. The application can collect step data from Apple Health or the device sensor. We recommend that you choose Apple Health, as you can get step data from all the devices that integrate with Apple Health. All it requires is that your device is configured to forward data to Apple Health.",
            ),
        Text("", ),
        Text(
            languageDanish
                ? "På hovedsiden kan du se historikken for de senest indhentede skridtdata, herunder hvor mange skridt, du har gået i dag og de seneste syv dage. På siden finder du også et ikon nede i højre hjørne, hvor du kan ændre dine indstillinger samt logge ud af applikationen. "
                : "On the main page, you can see the history of the most recently step data, including how many steps you have taken today and the last seven days. On the page you will also find an icon in the bottom right corner, where you can change your settings and log out of the application.",
            ),
      ],
    );
  }

  Widget _buildLogo() {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 10,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Image.asset(
                    'lib/assets/images/fidimi-logo.png',
                    height: 55,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
